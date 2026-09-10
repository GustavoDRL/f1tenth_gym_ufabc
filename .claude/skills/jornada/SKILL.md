---
name: jornada
description: Captura/atualiza a jornada do usuário de uma feature (personas, fluxos de tarefa, expectativas, atrito) em docs/features/<feature>/JORNADA-USUARIO.md. Use antes da revisão de usabilidade.
argument-hint: "[feature]"
allowed-tools: Read Grep Glob Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **jornada-usuario** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Objetivo: garantir `docs/features/<feature>/JORNADA-USUARIO.md` completa (persona, mapa de jornada, expectativas, atrito, critérios de sucesso).
- Jornada é UX — distinta da matriz RBAC do DOMINIO (leia, não duplique).
- Aplique o **GATE padronizado** (parar e perguntar em múltipla escolha; nada irreversível sem confirmação).
- Gere o **RASTRO .md** ao final, conforme o subagente.
