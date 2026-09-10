---
name: docs
description: Gera ou atualiza documentação técnica. Detecta código não documentado e cria docs no padrão do projeto.
argument-hint: "[arquivo, módulo, 'undocumented' ou 'all']"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: high
---

Despache para o subagente **docbot** no **modo `docs`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Modo `docs` = documentação técnica **durável** (README, `architecture/`, setup-guide, `api-reference` quando for API), verificada contra o código real; fato não confirmável → `[A CONFIRMAR]`. Não reescreve o **pacote de docs da branch** (isso é do `feature-builder`).
- `$ARGUMENTS = undocumented` → o subagente varre o projeto atrás de código sem doc antes de propor o plano.
- Os demais modos do docbot têm skill própria: `/explain · /diagram · /glossary · /changelog · /adr`.
- GATE padronizado (plano antes de escrever) + RASTRO .md, conforme o subagente.
