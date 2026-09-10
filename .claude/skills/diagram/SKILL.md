---
name: diagram
description: Gera diagramas Mermaid de arquitetura, fluxo de dados, sequência ou entidade-relacionamento.
argument-hint: "[tipo: arch|flow|sequence|er] [escopo]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: medium
---

Despache para o subagente **docbot** no **modo `diagram`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Modo `diagram` = Mermaid por tipo (arquitetura `graph TB` · fluxo `flowchart` · sequência `sequenceDiagram` · dados `erDiagram` · ciclo `stateDiagram-v2` · classe `classDiagram`), baseado no código real: máx. ~15 nós, labels descritivos, sintaxe validada.
- Tipo e escopo são perguntados pelo subagente na Fase 1.
- GATE padronizado + RASTRO .md, conforme o subagente.
