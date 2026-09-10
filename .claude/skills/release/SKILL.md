---
name: release
description: Cria release no GitHub com changelog automático baseado em commits convencionais.
argument-hint: "[tipo: major|minor|patch ou versão específica]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: medium
---

Despache para o subagente **github-manager** no **modo `release`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Analisa `git tag --sort=-v:refname` + `git log <tag>..HEAD`, monta o changelog por tipo e sugere a versão semver (feat→minor, fix→patch, BREAKING/`!`→major). O agrupamento do changelog é a lógica do **`/changelog`** (fonte única) — reaproveitada, não reimplementada.
- GATE padronizado (confirmar versão + notas antes de criar tag/release) + RASTRO .md, conforme o subagente.
