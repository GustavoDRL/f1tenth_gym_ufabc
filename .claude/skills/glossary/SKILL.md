---
name: glossary
description: Gera ou atualiza o glossário de termos do domínio do projeto.
argument-hint: "[projeto ou 'all']"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: low
---

Despache para o subagente **docbot** no **modo `glossary`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Modo `glossary` = tabela de termos do domínio do projeto + termos técnicos (serviços externos, siglas internas). O método de construção (fontes, ordem, formato, `[A CONFIRMAR]` para termo sem evidência) vive no system prompt do docbot, em *Glossário — como construir*. Glossário já existente no repo é **ponto de partida**, nunca é recriado.
- GATE padronizado + RASTRO .md, conforme o subagente.
