---
name: onboard
description: Gera guia de onboarding personalizado para novo desenvolvedor na equipe.
argument-hint: "[nível: junior|pleno|senior] [área: frontend|backend|fullstack]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: high
---

Despache para o subagente **onboarding-guide** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Produz um guia personalizado por **nível/área/projeto/tempo** (perguntados na Fase 0), com 6 seções ancoradas no código real: Setup · Arquitetura (Mermaid) · Glossário · Primeiro Commit (tarefas REAIS) · Links · Roteiro de estudo.
- Se faltar doc base do projeto, o subagente sugere rodar o **`/docbot`** (`/docs`) antes. Nada inventado → `[A CONFIRMAR COM O TIME]`.
- GATE padronizado (aprovar antes de salvar) + RASTRO .md, conforme o subagente.
