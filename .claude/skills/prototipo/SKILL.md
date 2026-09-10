---
name: prototipo
description: Constrói um protótipo descartável para responder uma dúvida de design (o state model faz sentido? essa lógica se sustenta?) — nunca vira produção sem passar por /spec + /build depois. Use quando a dúvida é "isso funciona assim?", não "implemente isso".
argument-hint: "[a dúvida de design a responder]"
allowed-tools: Read Grep Glob Bash Write Edit
model: sonnet
effort: medium
---

Você constrói um **protótipo descartável** para responder uma dúvida concreta de design — não uma feature. Skill direta, roda no nível principal.

## Processo

### 1. Isolar a dúvida (GATE, múltipla escolha)
Antes de escrever qualquer código, confirmo com o operador: (1) qual é a dúvida exata a responder (ex.: "esse state model cobre o caso de cancelamento no meio do fluxo?"); (2) onde o protótipo pode viver sem contaminar código de produção (arquivo/pasta isolada, ex. `scratch/` ou `_prototipo_<slug>/`, fora do caminho normal de build/import). Dúvida vaga ("será que funciona?") → **PARO e peço a dúvida específica**.

### 2. Construir o mínimo que responde
Escrevo só o suficiente pra a dúvida ter resposta observável — sem tratamento de erro completo, sem testes formais, sem integração real (mocka o que não é o foco da dúvida). Comento no topo do arquivo: `// PROTÓTIPO DESCARTÁVEL — responde: <dúvida>. Não usar em produção sem passar por /spec + /build.`

### 3. Rodar e reportar
Executo o protótipo (ou descrevo como o operador roda, se exigir ambiente que não tenho aqui) e reporto a resposta à dúvida original em 3-5 linhas: o que o protótipo mostrou, e se a resposta é "sim, o design se sustenta" ou "não, achei o problema X".

### 4. Destino do protótipo (GATE, múltipla escolha)
Pergunto o que fazer com o código: (a) descartar agora (`rm`, com confirmação) · (b) manter como referência em `scratch/` (não entra em produção) · (c) virar feature de verdade — nesse caso, encaminho para `/spec` (o protótipo não pula a especificação, só informa ela).

## 🚦 GATE
- Nunca escrevo fora do caminho isolado combinado no Passo 1.
- Nada irreversível (deletar, mover pra produção) sem confirmação explícita.
- Dúvida vaga = PARO e peço a dúvida específica antes de codar qualquer coisa.

## Regras
- **Nunca** um protótipo vira produção sem passar por `/spec` + `/build` — mesmo que o código "já funcione".
- Marcação `PROTÓTIPO DESCARTÁVEL` obrigatória no topo de todo arquivo criado.
- PT-BR. Zero credencial.
