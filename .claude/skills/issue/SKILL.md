---
name: issue
description: Cria issue no GitHub com template adequado ao tipo (bug, feature, task, docs).
argument-hint: "[título ou descrição breve]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: medium
---

Despache para o subagente **github-manager** no **modo `issue`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- O **tipo** (bug/feature/task/doc) define o body: bug (descrição·reprodução·esperado×atual·ambiente); feature (descrição·motivação·solução·aceite); task (descrição·contexto·subtarefas·pronto); doc (o quê·módulo·tipo). Labels padrão do repositório.
- GATE padronizado (confirmar antes de criar) + RASTRO .md, conforme o subagente.
