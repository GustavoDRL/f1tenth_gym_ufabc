---
name: wizard
description: Gera um wizard bash interativo para os passos de um processo que só um humano pode executar (provisionar infra, criar credencial, configurar DNS) — cada passo pergunta, valida e só avança confirmado. Use quando falta um roteiro guiado para um processo manual.
argument-hint: "[descrição do processo manual]"
allowed-tools: Read Grep Glob Agent
model: sonnet
effort: medium
---

Despache para o subagente **wizard-builder** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Objetivo: um script `.sh` que decompõe o processo manual em passos com pergunta+validação+confirmação, no caminho escolhido pelo operador (nunca `.claude/hooks/`).
- O agente **gera** o script; nunca o executa — execução é ato separado do operador.
- Aplique o **GATE padronizado** (parar e perguntar em múltipla escolha; nada irreversível sem confirmação).
- Gere o **RASTRO .md** ao final, conforme o subagente.
