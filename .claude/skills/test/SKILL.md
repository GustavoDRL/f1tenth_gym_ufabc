---
name: test
description: Gera testes automaticamente para o código especificado. Detecta framework e convenções.
argument-hint: "[arquivo, módulo ou 'recente' para mudanças do git]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: high
---

Despache para o subagente **test-generator** no **modo `test`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Modo `test` = auto-detecta o framework por evidência (pytest/Jest/Vitest/tap/Django), planeja a cobertura (GATE), escreve os testes no estilo do projeto **e roda a suíte**. Falha por bug de produção → **documenta o achado para o `corretor`** (não corrige produção); alimenta o loop `/test`⇄`/corrigir`.
- **Projeto que delega a escrita** (declarado no `CLAUDE.md`): a **escrita** dos testes é do `escrever-teste`; a **execução** da suíte no loop continua no test-generator — o próprio agente faz esse handoff.
- GATE padronizado (aprovar o plano antes de escrever) + RASTRO .md, conforme o subagente.
