---
name: coverage
description: Analisa cobertura de testes e identifica código não coberto. Sugere quais testes escrever.
argument-hint: "[módulo ou 'all']"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: medium
---

Despache para o subagente **test-generator** no **modo `coverage`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Modo `coverage` = **não escreve testes**: roda a cobertura, classifica os gaps por prioridade e entrega o plano de ação; ao final encaminha para `/test` gerar.
- **O plano manda:** se o projeto tem um plano de cobertura (ex.: `tests/PLANO-COBERTURA-TESTES.md`, com P0–P3), **respeite a ordem dele** — o `/coverage` confirma e mede o delta. Sem plano, ordena por criticidade (segurança/dinheiro → negócio core → API → utils).
- RASTRO .md conforme o subagente.
