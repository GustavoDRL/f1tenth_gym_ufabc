---
name: refactor
description: Aciona o optimizer para refatorar/otimizar com disciplina de medição (baseline → muda → re-mede), sem alterar comportamento observável. Use para gargalos de performance, queries lentas ou refatoração de código quente.
argument-hint: "[arquivo ou módulo a refatorar]"
allowed-tools: Read Bash(git *) Agent
model: opus
effort: high
---

Despache para o subagente **optimizer** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- O optimizer mede **baseline** → aplica **uma mudança por vez** → **re-mede**, preservando o comportamento observável. **Sem baseline confiável → PARA** (não otimiza às cegas); se a área não tem teste que cubra o comportamento, oferece criar via `/test` antes de mexer.
- **Exceção deliberada às lanes:** otimização é empírica, então o optimizer é o **único** agente que **escreve produção E roda** benchmarks+suíte. Acionado **ad-hoc** (fora do fluxo diário).
- A saída (branch) **re-entra na entrega normal** (`/pr → /review → /deploy-check`). Rastro com tabela baseline × resultado em `Reports/`.
