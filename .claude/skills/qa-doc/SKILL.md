---
name: qa-doc
description: Cria/atualiza/mantém a doc de QA por feature (tríade DOMINIO/MAPA-TESTES/WORKFLOW-E2E) via entrevista. Use quando uma feature precisa de doc de "o que/como testar".
argument-hint: "[nome ou descrição da feature]"
allowed-tools: Read Grep Glob Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **qa-doc-mapper** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Objetivo: garantir que `docs/features/<feature>/` tenha a tríade completa e viva, no formato de `Guidelines/templates/FEATURE-QA-DOC-TEMPLATE.md`.
- Se a feature já tem doc, é atualização in-place (modo manutenção), nunca `-v2`.
- Aplique o **GATE padronizado** (parar e perguntar em múltipla escolha; nada irreversível sem confirmação).
- Gere o **RASTRO .md** ao final, conforme o subagente.
