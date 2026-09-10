---
name: backlog
description: Visualiza e organiza backlog de issues do repositório GitHub.
argument-hint: "[filtro opcional: label, milestone ou assignee]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: low
---

Despache para o subagente **github-manager** no **modo `backlog`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- **Read-only:** roda `gh issue list` com o filtro escolhido (estado/label/milestone/assignee) e apresenta o backlog organizado em tabela. Oferece drill-down ou criar issue (`/issue`).
- RASTRO .md conforme o subagente.
