---
name: fix
description: Aplica a correção de um bug já diagnosticado (pós-/debug), escrevendo produção + testes SEM rodar. Use quando a causa raiz é conhecida.
argument-hint: "[descrição da correção ou referência ao diagnóstico do /debug]"
allowed-tools: Read Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **feature-builder** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- `/fix` = **1ª implementação** do fix diagnosticado pelo `/debug`: plano curto (GATE), mudança cirúrgica e **escreve os testes dos cenários do diagnóstico** — mas **NÃO roda a suíte** (lane estrita "quem escreve nunca roda"). Entrega a branch no remote + o **pacote de docs** (problema · como testar · como reproduzir · porquê), base para o `/review`.
- **Distinção de `/corrigir`:** `/fix` é a primeira correção (entra no loop); `/corrigir` é o **corretor** dentro do loop `/test`⇄`/corrigir`, corrigindo produção a partir dos achados do `/test`. A **execução** dos testes é sempre do `/test`.
- Handoff: `/test` (roda) → `/corrigir` (se houver achado) → `/review`. GATE + RASTRO .md conforme o subagente.
