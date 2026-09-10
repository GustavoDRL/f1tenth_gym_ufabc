---
name: changelog
description: Gera ou atualiza CHANGELOG.md baseado em commits convencionais.
argument-hint: "[desde: tag, data ou 'last-release']"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: medium
---

Despache para o subagente **docbot** no **modo `changelog`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Modo `changelog` = a partir de `git log --oneline --no-merges` no range de `$ARGUMENTS` (vazio → última tag, `git describe --tags --abbrev=0`), agrupado por tipo de conventional commit (feat/fix/docs/refactor/test/chore) + Breaking Changes, com hash curto e referência a PR quando houver.
- É a **fonte única do agrupamento**: o `/release` consome esta saída como corpo da release (não reimplementa).
- GATE padronizado + RASTRO .md, conforme o subagente.
