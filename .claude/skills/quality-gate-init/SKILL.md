---
name: quality-gate-init
description: Gera/atualiza .claude/quality-gate.yaml de um projeto — a config que o MCP quality-gate usa para saber quais testes rodar dado o que mudou. Use ao integrar um projeto ao quality gate de testes, ou quando a estrutura de testes mudou e a config ficou desatualizada.
argument-hint: "[path do projeto, default diretório atual]"
allowed-tools: Read Grep Glob Bash Agent
model: sonnet
effort: high
---

Despache para o subagente **quality-gate-mapper** com o alvo `$ARGUMENTS` (path do projeto; default: diretório atual).

Contexto fino (não duplica o system prompt do subagente):
- Detecta o(s) runner(s) do projeto por evidência, propõe categorias por pasta de teste real e escreve `.claude/quality-gate.yaml` no formato de `Guidelines/templates/QUALITY-GATE-YAML-TEMPLATE.md`.
- Se a config já existe, é atualização in-place (modo manutenção), nunca `-v2`.
- GATE padronizado (aprovar a lista de categorias antes de escrever) + RASTRO .md, conforme o subagente.
