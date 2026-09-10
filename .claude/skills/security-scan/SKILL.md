---
name: security-scan
description: Aciona o security-scanner para análise OWASP Top 10 + dependências + secrets + auth no escopo dado. Use antes de deploy, em auditoria periódica ou pós-incidente.
argument-hint: "[escopo: 'all', módulo ou 'recent']"
allowed-tools: Read Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **security-scanner** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- O security-scanner pergunta escopo/contexto/prioridade, varre as **4 dimensões** (OWASP Top 10 · dependências · secrets · auth) **em sequência no próprio contexto** (subagente nativo não despacha `Task` aninhado), classifica por severidade e grava o relatório em `Reports/`.
- **Gate crítico:** achado CRÍTICO no meio da varredura → PARA e pergunta antes de seguir.
- **Read-only sobre produção:** a varredura **não corrige código**. Achados de produção viram handoff para o loop **`/test`⇄`/corrigir`** (o `corretor` corrige); a skill só descreve o "como resolver", não aplica.
- Posição nos fluxos: no **pré-deploy (A4)** o `/security-scan` **re-roda sempre** como última checagem OWASP; na **manutenção (A7)** entra sob demanda no drill-down; em **feature nova (A2)** é obrigatório após o loop e antes do `/pr`.
