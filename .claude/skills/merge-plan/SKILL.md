---
name: merge-plan
description: Aciona o merge-planner (Plan Mode) para transformar o relatório de review num plano de merge seguro e ordenado. Use após um REQUEST CHANGES em PR grande/arriscada (migration, auth/pagamento, muitos bloqueantes); PR pequena corrige direto via /build.
argument-hint: "[relatório do pr-reviewer ou número do PR]"
allowed-tools: Read Grep Glob Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **merge-planner** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- O merge-planner opera em **Plan Mode absoluto** (nunca edita/executa/commita): consome o relatório do `pr-reviewer`, classifica os achados em 🔴bloqueante/🟡recomendado/🔵opcional e produz um PLANO DE IMPLEMENTAÇÃO com ordem segura, checkpoints e **rollback por tarefa**. Grava o rastro em `Reports/`.
- **Opcional por risco:** só para PR grande/arriscada; PR pequena corrige direto via `/build` e volta ao loop.
- **Executor do plano = feature-builder** (`/build`): escreve sem rodar → loop `/test`⇄`/corrigir` → re-review.
- **Deploy manual/local** (sem CI/blue-green): o plano define a ORDEM segura; o manual de deploy é do `/deploy-check`//`runbook`. Base = `main`.
