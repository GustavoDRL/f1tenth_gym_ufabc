---
name: spec
description: Especifica uma tarefa/feature de forma validável antes de implementar. Use para transformar uma ideia vaga em spec acionável com critérios "feito quando".
argument-hint: "[descrição da tarefa ou feature]"
allowed-tools: Read Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **spec-planner** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Produz a **spec validável** antes de qualquer código: cenário de uso ("Usuário **[X]** faz **[Y]**, esperando **[Z]**"), checklist linear de 3–10 passos verificáveis, e critérios **"feito quando ..."** binários (≥3 funcionais + ≥3 técnicos); lacunas viram **⚠️ A validar**. Salva em `spec-<slug>.md` no projeto-alvo.
- A spec alimenta o **feature-builder** (`/build`). Intenção ambígua → o subagente PARA e pergunta.
- GATE padronizado + RASTRO .md, conforme o subagente.
