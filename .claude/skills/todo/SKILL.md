---
name: todo
description: Lista e organiza TODOs, FIXMEs e HACKs encontrados no código.
argument-hint: "[list|summary|by-file|by-priority]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: low
---

Despache para o subagente **github-manager** no **modo `todo`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- **Read-only:** varre `TODO/FIXME/BUG/HACK/XXX/OPTIMIZE` **e `ponytail:`** (ignorando `node_modules/venv/.git/dist/build`), agrupa por severidade em tabela `arquivo:linha` (FIXME/BUG → alta; TODO → média; HACK/OPTIMIZE/XXX → baixa; `ponytail:` → dívida deliberada, listada à parte com o teto, quando declarado no comentário).
- Um TODO crítico pode virar issue task (label `tech-debt`) via `/issue`. RASTRO .md conforme o subagente.
