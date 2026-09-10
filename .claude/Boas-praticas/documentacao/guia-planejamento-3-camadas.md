# Guia — Planejamento profundo em 3 camadas (modo detetive)

> **O quê:** trilha de planejamento profundo para esforços multi-spec, complementar ao `/spec`
> de tarefa única. Três skills encadeáveis + o subagente `revisor-detetive`.

## As 3 camadas
1. **`/coletar-specs`** — cria o workspace do plano (`docs/planos/<data>-<nome>/`), escolhe o escopo (projeto / solução / features) e coleta specs + artefatos visuais em 4 categorias (docs duráveis + tríades de feature + specs de tarefa + artefatos visuais) num **manifesto**; visual faltante que o escopo toca vira oferta de `mapa-sistema`/`mapa-telas`. Fecha com o **gate visual 1** aprovado.
2. **`/revisar-specs`** — revisa cada spec em **modo detetive** com os artefatos visuais como evidência (spec×diagrama) e **cross-revisa** o conjunto (conflito/concorrência, coerência, otimização, diagrama×diagrama). Fecha com o **gate visual 2** aprovado.
3. **`/planejar`** — rascunha o plano, revisa **ponto-a-ponto** (detetive + múltipla escolha), roda premortem e usabilidade, e escreve o **plano final worktree-paralelo** (grafo Mermaid + delta de arquitetura + âncoras visuais nos briefs). Fecha com o **gate visual 3** (sala de aprovação) aprovado antes de emitir o plano. Não executa.

## Modo detetive
Toda revisão (por spec, por categoria, por ponto do plano) roda como um detetive cético: caça erros/lacunas/ambiguidades, verifica contra o código, e **entrevista quem pediu a tarefa** para descobrir objetivos, motivações e razões. O `revisor-detetive` devolve as perguntas; o nível principal as apresenta em múltipla escolha.

## Gates visuais (HTML local derivado)
Cada camada fecha com uma página HTML local em `<workspace>/visual/gate-<n>-*.html`, gerada por `python3 .claude/visual/visual_gate.py <workspace> --gate N` e aprovada em múltipla escolha antes da camada seguinte. Os `.md` do workspace são a **fonte única de verdade**: a página é derivada (renderiza Mermaid offline via `docs/planos/assets/mermaid.min.js`), nunca editada à mão — conteúdo errado na página se conserta no `.md` e regenera. Gate 1 apresenta o manifesto + artefatos visuais; gate 2, a revisão; gate 3 é a sala de aprovação do plano (wireframes, delta de arquitetura, ERD, grafo de dependências, lanes e briefs).

## Artefatos visuais de engenharia
Quatro artefatos são cidadãos de primeira classe da trilha: `docs/architecture/mapa-componentes.md` (componentes C4-like), `docs/architecture/modelo-dados.md` (ERD), `docs/architecture/sequencias/<fluxo>.md` (sequências com caminho de erro) — os três do agente `mapa-sistema` — e `docs/features/<f>/FLUXO-TELAS.md` (telas, do `mapa-telas`). São documentos vivos, com evidência `arquivo:linha` ou `[A CONFIRMAR]`; a L1 os cataloga, a L2 os usa como evidência e a L3 embute o delta no plano e o recorte em cada brief.

## Premortem (resiliência)
Complementar ao modo detetive: o detetive caça erros no artefato como escrito; o premortem assume que o plano **já falhou daqui a 6 meses** e trabalha de trás pra frente para achar por quê. A skill `/premortem` (fan-out de `investigador-premortem` por modo de falha) produz plano revisado + checklist pré-lançamento; o `/planejar` roda um premortem no plano antes de emitir a versão final. Use `/premortem` isolado sobre qualquer plano/decisão.

## Revisão de usabilidade (ótica do usuário)
Terceira lente da fase final, junto do premortem: verifica se o plano entrega o que o **usuário** espera (correto/completo/condizente), com base na jornada do usuário. `/jornada` (subagente `jornada-usuario`) captura personas, fluxos de tarefa, expectativas e atrito em `docs/features/<f>/JORNADA-USUARIO.md`; `/usabilidade` (subagente `revisor-usabilidade`) revisa o plano/feature por essa ótica + acessibilidade. O `/planejar` roda essa revisão na fase final antes de emitir o plano.

## Execução rastreável (após o planejamento)
O plano final de `/planejar` (worktree-paralelo) alimenta o `/executar` — a versão PT-BR do padrão `subagent-driven-development` do superpowers, integrada ao hub: reusa os agentes já existentes (`feature-builder`, `pr-reviewer`, `corretor`) e mantém o ledger em `docs/planos/`, em vez de `.superpowers/sdd/`.

**O workspace do plano.** O workspace nasce no `/coletar-specs` e acompanha a trilha inteira (`docs/planos/<data>-<nome>/`):
- `manifesto.md` / `revisao.md` — os artefatos das camadas 1 e 2.
- `visual/gate-*.html` — as páginas dos gates (derivadas, regeneráveis).
- `plano.md` — o plano final worktree-paralelo.
- `progresso.md` — o ledger (ver abaixo).
- `tarefas/T*-brief.md` — um brief por tarefa/lane.
- `relatorios/T*-report.md` — um relatório por tarefa concluída.

A spec de origem **continua** em `docs/superpowers/specs/` (produzida por `/coletar-specs` + `/revisar-specs`) — o `plano.md` apenas a **linka**, não a duplica.

**O ciclo do `/executar`** roda no nível principal, em fan-out (mesma lógica de despacho do `/run`):
1. **Retomada pelo ledger** — lê `progresso.md` antes de despachar qualquer coisa.
2. **Identifica lanes prontas** — tarefas `⬜ pendente` cujas dependências já estão `✅ feito`.
3. Despacha **1 `feature-builder` por lane/worktree**, em paralelo.
4. **Loop de qualidade por tarefa** — `pr-reviewer` revisa; se houver achado Crítico/Importante, o `corretor` corrige e o loop repete até a revisão sair limpa.
5. **Barreiras de sincronização** — merge/rebase das worktrees entre si, nos pontos de sync previstos no plano.
6. **Revisão final da branch**, quando todas as lanes fecham.
7. **Handoff para `finishing-a-development-branch`** — o `/executar` **não** faz merge/push sozinho; entrega a decisão final (merge, PR, cleanup) a essa skill.

**O ledger (`progresso.md`)** é uma tabela por tarefa: status (`⬜ pendente` / `🔨 fazendo` / `✅ feito` / `🚧 travado`), lane, dependências, commits, nota. Regra de ouro: **feito = revisão limpa** — não é "código escrito", é "passou pelo `pr-reviewer` sem pendência Crítica/Importante".

**Os relatórios por tarefa** (`relatorios/T*-report.md`) registram, para cada tarefa concluída: status · commits · resumo do teste (comando + saída) · concerns.

**Retomada após compactação.** Este é o principal ganho do ledger: se o contexto compactar ou a sessão cair no meio da execução, `progresso.md` é a **fonte de verdade**. Uma tarefa `✅` não deve ser redespachada. Ao retomar, confie no ledger + `git log` — nunca na memória da conversa.

## Quando usar
- **Tarefa única** → `/spec` + writing-plans (fluxo leve).
- **Esforço multi-spec / projeto / solução grande** → esta trilha.
