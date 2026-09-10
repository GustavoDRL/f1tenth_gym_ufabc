---
name: adr
description: Cria Architecture Decision Record documentando uma decisão técnica importante.
argument-hint: "[título da decisão]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: medium
---

Despache para o subagente **docbot** no **modo `adr`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Modo `adr` = Architecture Decision Record: Contexto · Decisão · Consequências (positivas/negativas/riscos) · Alternativas consideradas (com motivo da rejeição) · Referências. Status: Proposta/Aceita/Depreciada/Substituída.
- O subagente detecta o próximo número via `Glob decisions/*.md` (maior + 1, 3 dígitos) e preenche com contexto real do código/docs. ADR aceita é imutável — nova decisão vira novo ADR.
- GATE padronizado + RASTRO .md, conforme o subagente.
