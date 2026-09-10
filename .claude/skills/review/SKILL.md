---
name: review
description: Revisão completa de PR em 5 dimensões (lógica, segurança, performance, qualidade, testes) com veredito ponderado. Use ao revisar uma PR, um diff ou antes de planejar um merge.
argument-hint: "[número do PR ou 'current' para branch atual]"
allowed-tools: Read Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **pr-reviewer** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- O pr-reviewer percorre as **5 dimensões (lógica · segurança · performance · qualidade · testes) sequencialmente no próprio contexto** — subagente nativo **não** despacha `Task` aninhado (mesma razão do `/security-scan`; **não** lance 5 sub-análises paralelas). Lê cada arquivo **completo**, não só o diff; base do fluxo = `main`.
- A suíte já vem verde do loop `/test`⇄`/corrigir` — a dimensão Testes avalia **qualidade/cobertura**, não re-executa. Veredito ponderado APPROVE / REQUEST CHANGES / REJECT.
- **Pipeline:** REQUEST CHANGES/REJECT em PR grande → **`/merge-plan`** (merge-planner) → `/build` → loop. GATE + RASTRO .md conforme o subagente.
