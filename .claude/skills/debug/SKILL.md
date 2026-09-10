---
name: debug
description: Investiga bugs e encontra causa raiz. Use quando algo não funciona e você precisa entender por quê.
argument-hint: "[descrição do bug ou erro]"
allowed-tools: Read Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **debugger** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- O debugger é **read-only**: prova a **causa raiz** (não o sintoma) com evidência `arquivo:linha`, monta o RELATÓRIO DE DIAGNÓSTICO + **como reproduzir** + os **cenários que os testes devem cobrir**, e **recomenda a abordagem** (o caminho, **sem código pronto**).
- **Não aplica o fix:** quem implementa é o `feature-builder` via **`/fix`**, partindo deste diagnóstico. É passo **obrigatório** antes do `/fix`.
- GATE padronizado (escolher a abordagem antes de encerrar) + RASTRO .md, conforme o subagente.
