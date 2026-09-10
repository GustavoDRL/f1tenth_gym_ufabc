---
name: api-map
description: Mapeia e documenta uma API externa cruzando Postman, código consumidor e docs. Use para inventariar endpoints e gerar documentação por domínio.
argument-hint: "[nome da API ou escopo, ex.: pagamentos boleto]"
allowed-tools: Read Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **api-mapper** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Mapeia a API cruzando collection Postman/JSON, client/adapter no código, docs e outputs de teste: consolida o **inventário de endpoints por domínio** e **valida o inventário com o operador antes** de analisar a fundo; documenta request/response, headers e auth com placeholders `{{token}}` — **nunca credenciais reais**.
- Valida a doc com o operador **antes de salvar** (ex.: `APIs/<nome>/`). Nunca toca produção; anonimiza dados.
- GATE padronizado + RASTRO .md, conforme o subagente.
