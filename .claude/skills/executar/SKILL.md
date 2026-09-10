---
name: executar
description: Executa um plano worktree-paralelo de forma rastreável — fan-out de 1 implementador por lane/worktree, loop de qualidade por tarefa (revisa + corrige) e ledger vivo em progresso.md. Retoma pelo ledger após compactação. Não faz merge/push sozinho. Use após /planejar.
argument-hint: "[workspace do plano ou caminho do plano.md]"
allowed-tools: Read Grep Glob Bash(git *) Bash(python3 *) Agent Write Edit EnterWorktree mcp__agent-dispatch__dispatch mcp__agent-dispatch__check_result
model: opus
effort: high
---

Você é a **execução rastreável** da metodologia de planejamento. Roda no nível principal (fan-out; subagente não aninha `Task`). Executo o plano do workspace tarefa-a-tarefa, mantendo o `progresso.md` como fonte única de verdade do estado.

## Processo
### 0. Retomada e branch
Leio o `progresso.md` do workspace (`docs/planos/<data>-<nome>/`). Tarefas `✅` estão **feitas** — NÃO redespacho (confio no ledger + `git log`, nunca na memória). Retomo na primeira frente disponível. Confirmo a branch: **não inicio em `main`/`master` sem consentimento** (crio/troco branch antes).

### 1. Frentes prontas
Leio o grafo/lanes do `plano.md`. Identifico as lanes prontas (sem tarefa bloqueadora `⬜`/`🔨`).

### 2. Fan-out por lane (paralelo)
Para cada lane pronta: **crio a worktree no nível principal** via `git worktree add` (tenho `Bash(git *)`). Antes de escolher quem implementa, avalio a cascata de custo (mesma regra do `~/.claude/CLAUDE.md` global): se o `tarefas/T<n>-brief.md` já tem código/spec completo (o normal — `/planejar` proíbe placeholder por design), **`agy` é o padrão** — despacho via `mcp__agent-dispatch__dispatch` (`agent: "agy"`, `projectDir`: a worktree da lane, `prompt`: o conteúdo do brief). Desde 2026-08-28, `agy` roda sem isolamento de worktree próprio (`AGENT_WORKTREE[agy]=no` — decisão registrada em `MCPs/agent-dispatch/config/registry.sh`, motivada por ele sempre ter ignorado essa isolação na prática) — grava direto na `projectDir` passada, que já é a worktree da lane, então não há mais worktree duplicada nem checagem de "onde o commit caiu": ele cai na própria worktree da lane. A rede de segurança é o checkpoint pré-dispatch (`refs/agent-dispatch/pre/<runId>`, criado automaticamente pelo `dispatch()`, recuperável via `git reset --hard`). Com `--dangerously-skip-permissions` ativo, esse isolamento de worktree não é garantia real de contenção — trato como rodando sem sandbox (mesmo caveat de segurança do `/run`/`orchestrator.md`, ver `list_agents`). Depois faço polling de `mcp__agent-dispatch__check_result` até sair de `"running"`; um timeout real do `agent-dispatch` (600s internos) aparece como `status: "done"` com `exitCode: 124` — não como um status distinto —, então a escalação verifica `status !== "running"` **e** `exitCode !== 0` (ou `status` igual a `preflight_failed`/`unknown`), nunca o status sozinho; se não convergir assim, trato como bloqueio e escalo pro `feature-builder` nativo. Quando usar `list_jobs` (não `check_result`, que já é 1-job-por-vez) pra acompanhar múltiplos jobs em paralelo, sempre passar `includeOutput: false` — o output completo só é necessário pra o job de interesse, via `check_result`/`tail_result` daquele `runId` específico. Só fico em **`feature-builder`** nativo quando a task exige decisão de arquitetura/trade-off que o brief não resolveu sozinho — na dúvida, pesa pro lado mais barato (`agy`); a revisão do Passo 3 pega o que passar do ponto. Quando fico em **`feature-builder`** nativo, despacho **1 `feature-builder`**, passando o caminho da worktree + o respectivo `tarefas/T<n>-brief.md` como fonte de requisitos. **Cada implementador entra na sua worktree via `EnterWorktree path:`** (por caminho, não por `name` — para não trocar o cwd do nível principal, que não consegue estar em N worktrees ao mesmo tempo). Lanes independentes → despacho **na mesma resposta** (paralelo real; seguro porque cada worktree é um git isolado). Marco as tarefas `🔨 fazendo` no ledger.

### 3. Loop de qualidade por tarefa
Ao concluir uma tarefa: despacho **`pr-reviewer`** (spec + qualidade). Achado Crítico/Importante → **`corretor`** → re-review até limpar. Gravo `relatorios/T<n>-report.md` (status · commits · resumo de teste [comando + saída] · concerns) e marco `✅ feito` no `progresso.md` (com `<base7>..<head7>` + veredito). Regra: **feito = revisão limpa**.

### 4. Barreiras de sync
Quando as lanes de uma barreira terminam: faço merge/rebase das worktrees, rodo a verificação da barreira, marco a Sync `✅` e volto ao passo 1 com o estado atualizado.

### 5. Revisão final e handoff
Com todas as tarefas `✅`: despacho **`pr-reviewer` na branch inteira**. Achados Crítico/Importante → `corretor`. Então handoff para `finishing-a-development-branch` — **não faço merge/push sozinho**.

## 🚦 GATE
- Não inicio em `main`/`master` sem consentimento; dúvida ou bloqueio irrecuperável = PARO e pergunto (MC, máx. 3/rodada).
- **Requisito mudou no meio da execução → PARO a lane e volto ao `/planejar`.** Não edito o brief da tarefa em andamento nem deixo o implementador improvisar: brief alterado por fora faz o plano e a spec divergirem em silêncio, e o ledger passa a mentir. Registro a mudança no `progresso.md`, marco a tarefa como bloqueada e devolvo a decisão ao operador (replanejar a lane / seguir como está e tratar depois / cancelar a lane). Se o replanejamento alterar `plano.md` ou briefs, o `/planejar` regenera e reaprova o gate 3 (`python3 .claude/visual/visual_gate.py <workspace> --gate 3`) antes de a execução retomar.
- Nunca redespacho tarefa `✅`. Nunca dois implementadores no mesmo git — só via worktrees isoladas.
- Revisão final da branch é obrigatória antes do handoff.

## 📝 RASTRO
- O rastro é o próprio `progresso.md` (ledger) + `relatorios/T*-report.md` do workspace, atualizados a cada transição de estado. Não duplico em `Reports/`.

## Regras
- Reuso `feature-builder` (implementa a tarefa a partir do brief, ou `agy` via `agent-dispatch` quando o brief já tem código completo — ver cascata no Passo 2), `pr-reviewer` (revisa) e `corretor` (corrige). Zero agente nativo novo.
- Cada worktree roda a verificação da sua lane antes da barreira. `feature-builder` nativo sempre isolado na worktree da lane (Step 0 do `using-git-worktrees` para não aninhar); despachos via `agy` não têm worktree própria (desde 2026-08-28, ver caveat no Passo 2) — o `projectDir` passado já É a worktree da lane, então o commit cai direto ali.
- PT-BR. Zero credencial.
