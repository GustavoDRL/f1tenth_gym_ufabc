---
name: mapa-sistema
description: Mapeia a engenharia da solução — componentes (C4-like), modelo de dados (ERD) ou sequências dos fluxos críticos — via código real e entrevista, em docs/architecture/. Use avulso ou quando a trilha de planejamento apontar o artefato como lacuna.
argument-hint: "[componentes | dados | sequencias] [escopo]"
allowed-tools: Read Grep Glob Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **mapa-sistema** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Objetivo: garantir `docs/architecture/mapa-componentes.md` (modo componentes), `docs/architecture/modelo-dados.md` (modo dados) ou `docs/architecture/sequencias/<fluxo>.md` (modo sequencias) — diagrama Mermaid + tabelas com evidência `arquivo:linha` ou `[A CONFIRMAR]`.
- Alimenta a trilha de planejamento profundo: o `/coletar-specs` cataloga esses artefatos e o `revisor-detetive` os usa como evidência. Wireframes/telas são do `/mapa-telas` — outro agente.
- Aplique o **GATE padronizado** (parar e perguntar em múltipla escolha; nada irreversível sem confirmação).
- Gere o **RASTRO .md** ao final, conforme o subagente.
