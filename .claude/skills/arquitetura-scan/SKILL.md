---
name: arquitetura-scan
description: Varre o código por oportunidades de aprofundar módulos (interface larga, responsabilidade espalhada, acoplamento indevido) e apresenta como relatório HTML navegável. Use antes de um refactor grande ou quando o código resiste a mudança sem causa óbvia.
argument-hint: "[módulo | diretório | 'projeto inteiro']"
allowed-tools: Read Grep Glob Bash(python3 *) Agent
model: opus
effort: high
---

Despache para o subagente **arquitetura-scanner** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Objetivo: `docs/arquitetura/scan-<data>.md` (sempre); versão HTML navegável só quando o scan roda dentro de um workspace de planejamento (`docs/planos/<data>-<nome>/`), via `.claude/visual/visual_gate.py` reaproveitado — nunca gerador novo.
- Achado = interface larga / responsabilidade espalhada / acoplamento indevido, sempre com `arquivo:linha`; estilo/nomenclatura não conta (isso é `pr-reviewer`/`optimizer`).
- O agente só reporta — a correção é aplicada depois por `optimizer`/`feature-builder`.
- Aplique o **GATE padronizado** (parar e perguntar em múltipla escolha; nada irreversível sem confirmação).
- Gere o **RASTRO .md** ao final, conforme o subagente.
