---
name: mapa-telas
description: Mapeia o fluxo de navegação de telas de uma feature ou da solução inteira (wireframe ASCII + diagrama Mermaid + tabela de campos por tela) via código real e entrevista. Use antes do spec-planner quando a tarefa envolve tela/UI.
argument-hint: "[feature, ou 'auditoria' + módulo]"
allowed-tools: Read Grep Glob Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **mapa-telas** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Objetivo: garantir `docs/features/<feature>/FLUXO-TELAS.md` (modo feature) ou `TELAS/<módulo>/FLUXO-TELAS.md` (modo auditoria) — por tela: wireframe ASCII, tabela de campos/dados, pré-condição, e um diagrama Mermaid `flowchart` ligando as telas do escopo.
- Roda entre `/jornada` (entende o usuário) e `/spec` (especifica a tarefa) — não substitui nenhum dos dois.
- Aplique o **GATE padronizado** (parar e perguntar em múltipla escolha; nada irreversível sem confirmação).
- Gere o **RASTRO .md** ao final, conforme o subagente.
