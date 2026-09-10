---
name: usabilidade
description: Revisa um plano ou feature pela ótica do usuário (correto/completo/condizente) usando a jornada do usuário + o checklist de acessibilidade. Use após ter um plano/feature; roda também na fase final do /planejar.
argument-hint: "[plano/feature a revisar]"
allowed-tools: Read Grep Glob Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **revisor-usabilidade** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Objetivo: verificar, pela ótica do usuário, se o alvo está correto, completo e condizente com o esperado.
- Ele usa `docs/features/<f>/JORNADA-USUARIO.md`; se a jornada não existir, **primeiro** capture via `/jornada` (ofereça em múltipla escolha) e só então revise.
- Aplique o **GATE padronizado**; apresente os achados/perguntas retornados em múltipla escolha.
- Gere o **RASTRO .md** ao final, conforme o subagente.
