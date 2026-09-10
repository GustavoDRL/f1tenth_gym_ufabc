---
name: explain
description: Explica código, arquitetura ou fluxo de forma clara e didática. Útil para onboarding e aprendizado.
argument-hint: "[arquivo, função, módulo ou conceito]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: medium
---

Despache para o subagente **docbot** no **modo `explain`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Modo `explain` = explicação didática por função/classe/módulo/conceito/arquitetura: propósito, fluxo passo a passo, dependências (quem usa / de quem depende), pontos de atenção e diagrama Mermaid se ajudar. Baseado no código real, referências com `arquivo:linha`.
- Nível de detalhe (resumo / completo / deep dive) é perguntado pelo subagente na Fase 1.
- GATE padronizado + RASTRO .md, conforme o subagente.
