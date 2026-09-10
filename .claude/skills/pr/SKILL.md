---
name: pr
description: Cria Pull Request com título, descrição e labels gerados a partir do diff, contra a base do fluxo (main por padrão).
argument-hint: "[branch base opcional, default main]"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: medium
---

Despache para o subagente **github-manager** no **modo `pr`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Base do PR = **`main`** (não há `develop` no fluxo real). Em **incidente de produção** a base é a mesma `main`; o que muda é o rigor + `/postmortem` obrigatório, não a base. Branch no padrão `<tipo>/<slug-kebab>`.
- Título conventional (PT-BR, ≤70 chars) + **body reaproveitado do pacote de docs do `/fix`//`/build`** (problema · como testar · como reproduzir · porquê). A branch **já costuma estar no remote** (entregue pelo `/fix`//`/corrigir`) → o subagente **não faz push**, só abre o PR; fallback confirmado se não estiver.
- GATE padronizado (aprovar título+body antes de criar) + RASTRO .md, conforme o subagente.
