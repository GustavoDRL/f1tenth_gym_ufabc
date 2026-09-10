---
name: pesquisa
description: Investiga uma pergunta contra fontes primárias de alta confiança (docs oficiais, código-fonte, specs) e grava o achado em docs/pesquisa/ com citação por afirmação. Use quando a resposta precisa ser verificável, não vir de memória.
argument-hint: "[pergunta] [escopo: repo | web | ambos]"
allowed-tools: Read Grep Glob WebSearch WebFetch Agent
model: sonnet
effort: medium
---

Despache para o subagente **pesquisador** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Objetivo: `docs/pesquisa/<slug>.md` com cada afirmação citando fonte (URL+data ou `arquivo:linha`); contradição entre fontes registrada, nunca resolvida em silêncio; lacuna vira `[NÃO VERIFICADO]`.
- Ordem de confiança das fontes: código do repo > docs oficiais > busca ampla (só para achar a fonte primária, nunca citada como fonte em si).
- Aplique o **GATE padronizado** (parar e perguntar em múltipla escolha; nada irreversível sem confirmação).
- Gere o **RASTRO .md** ao final, conforme o subagente.
