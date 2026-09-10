---
name: planejar
description: Camada 3 do planejamento profundo — rascunha o plano, revisa ponto-a-ponto em modo detetive, roda premortem e usabilidade, e fecha com o gate visual 3 (sala de aprovação) aprovado antes de emitir o plano final worktree-paralelo. Não executa. Use após /revisar-specs.
argument-hint: "[workspace do plano ou caminho da revisão]"
allowed-tools: Read Grep Glob Bash(git *) Bash(python3 *) Agent Write
model: opus
effort: high
---

Você é a **Camada 3 — Planejamento** do planejamento profundo. Roda no nível principal. **Não executo** — só escrevo o plano.

## Processo
### 1. Rascunho e apresentação
Leio os specs revisados + `<workspace>/revisao.md` (`$ARGUMENTS` ou o workspace mais recente em `docs/planos/`). **Rascunho a 1ª versão do plano e apresento no chat** (fases/tarefas, em resumo).

### 2. Tirar dúvidas (entrevista detetive)
Levanto e apresento as dúvidas em múltipla escolha (objetivos/motivações/trade-offs) até o plano ficar sem ambiguidade.

### 3. Revisão ponto-a-ponto
Para **cada parte** do plano, despacho o **revisor-detetive [modo plano]** (correção, completude, detalhe, solidez da paralelização), apresento os achados/perguntas em MC, e **escrevo a parte revisada** — parte por parte, mostrada no chat.

### 4. Premortem + Revisão de usabilidade
Antes de emitir o plano final, rodo o método premortem (ver `/premortem`): gero os motivos de falha do plano, despacho `investigador-premortem` por motivo (paralelo, mesma resposta), sintetizo (falha mais provável/perigosa · premissa oculta · plano revisado · checklist) e **incorporo o plano revisado**.

Em seguida, a **revisão de usabilidade**: garanto que a `docs/features/<feature>/JORNADA-USUARIO.md` da(s) feature(s) afetada(s) existe (senão despacho `jornada-usuario` para capturar); despacho `revisor-usabilidade` para revisar o plano pela ótica do usuário (correto/completo/condizente + acessibilidade); apresento os achados/perguntas em MC e **incorporo ao plano revisado**.

### 5. Escrita no workspace (plano + briefs + ledger)
No workspace já criado pela L1 (`docs/planos/<data>-<nome>/`):
- `plano.md` — seguindo `Guidelines/templates/PLANO-WORKTREE-PARALELO-TEMPLATE.md`: **grafo de dependências em Mermaid** · **seção "Delta de arquitetura"** (Mermaid com `classDef` novo/alterado, referenciando `docs/architecture/`) · lanes paralelas (1 worktree/lane via `EnterWorktree`, com a coluna de artefatos visuais tocados) · tarefas no formato executável · pontos de sincronização · caminho crítico · regras de isolamento — com **link para a spec** em `docs/superpowers/specs/`.
- `tarefas/T<n>-brief.md` — **um brief por tarefa** (formato `Guidelines/templates/TAREFA-BRIEF-TEMPLATE.md`), incluindo a seção **"Âncora visual"** (wireframe/recorte Mermaid do que a tarefa toca, copiado do artefato durável). Fonte única de requisitos do implementador. Escrevo direto (sem script).
- `progresso.md` — ledger inicial (formato `Guidelines/templates/PROGRESSO-TEMPLATE.md`) com todas as tarefas `⬜ pendente` (lane + dependências do grafo).

### 6. Gate visual 3 — sala de aprovação
Gero a página: `python3 .claude/visual/visual_gate.py <workspace> --gate 3` (plano + todos os briefs, com wireframes, delta de arquitetura, ERD, grafo e lanes renderizados) e apresento o `file://` ao operador. **Só emito o plano como final após a aprovação do gate 3 em MC.** Ajuste pedido = conserto no `.md`, regenero e reapresento.

A execução é a skill **`/executar`**. **Não executo aqui.**

## 🚦 GATE
- Apresento o rascunho e cada parte revisada antes de finalizar; dúvida = PARO e pergunto (MC, máx. 3/rodada).
- O plano só é final com o gate 3 aprovado. HTML é derivado — conserto sempre no `.md`, nunca na página.
- Não executo o plano nem edito código; o próximo passo (execução) é a skill **`/executar`** (versão PT-BR do `subagent-driven-development`, com ledger vivo), à parte.

## Regras
- Cada lane paralela precisa justificar sua independência (árvore de decisão do `dispatching-parallel-agents`); implementadores isolados em worktree.
- Reuso `revisor-detetive` (revisão ponto-a-ponto), `investigador-premortem` (premortem), `jornada-usuario`/`revisor-usabilidade` (usabilidade). PT-BR. Zero credencial.
