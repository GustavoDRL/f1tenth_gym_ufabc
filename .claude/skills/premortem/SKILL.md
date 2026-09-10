---
name: premortem
description: Estressa um plano/decisão assumindo que JÁ FALHOU daqui a 6 meses e trabalhando de trás pra frente — gera motivos de falha, investiga cada um em paralelo e produz plano revisado + checklist. Use para "premortem", "stress-test", "o que pode matar isso", "onde isso quebra".
argument-hint: "[plano/decisão a estressar]"
allowed-tools: Read Grep Glob Bash(git *) Agent Write
model: opus
effort: high
---

Você roda um **premortem** no nível principal: assume o fracasso já consumado e trabalha de trás pra frente. O frame "JÁ FALHOU" é o mecanismo — sem ele, vira análise de risco polida.

## Quando NÃO aplicar
Ideia vaga sem plano concreto (planeje primeiro); pergunta com resposta única; feedback de rascunho (isso é edição); decisão irreversível já tomada; pedido de suporte multi-perspectiva. Nesses casos, PARO e digo por quê.

## Processo
### 1. Contexto mínimo
Preciso de: (a) o que é (1 frase); (b) para quem; (c) como é o sucesso (a falha é o inverso). Varro a conversa + `CLAUDE.md`/`memory/` antes; se faltar, pergunto **a peça mais importante que falta** (uma por vez, conversacional).

### 2. Frame
Digo, nomeando o plano real: "É daqui a 6 meses. O **<plano real>** falhou. Vamos olhar pra trás e descobrir por quê."

### 3. Motivos de falha
Passo único e abrangente: gero **todos** os motivos reais pelos quais morreu — específicos, ancorados nos detalhes, sem encher com motivos fracos. Quantidade real (pode ser 4, pode ser 9), sem forçar número.

### 4. Fan-out (paralelo)
Despacho **um `investigador-premortem` por motivo, na MESMA resposta** (paralelo — despacho sequencial deixa um influenciar o outro). Cada briefing traz: o plano completo (o quê/para quem/sucesso + contexto), o frame "já falhou", e o motivo atribuído.

### 5. Síntese
Leio todos os retornos e produzo: **falha mais provável** · **falha mais perigosa** (mais dano, mesmo se menos provável) · **premissa oculta** (a maior coisa dada como certa) · **plano revisado** (mudanças concretas, cada uma mapeada a uma falha — específicas, não "considere testar") · **checklist pré-lançamento** (3-5 itens verificáveis, cada um previne/detecta uma falha).

### 6. Saída
Gravo o relatório em `Reports/$(date +%Y-%m-%d_%H-%M-%S)_premortem_<projeto>_<alvo>.md` (síntese no topo, um bloco por falha: história/premissa/sinais). No chat, resumo de 3 frases: falha mais provável, premissa oculta, revisão mais importante.

## 🚦 GATE
- Contexto insuficiente → pergunto (uma por vez). Não aplico premortem quando não cabe (ver "Quando NÃO aplicar").
- Nada irreversível sem confirmação. Não executo o plano.

## Regras
- Reuso `investigador-premortem` (lógica densa por falha) — não reimplemento. PT-BR. Zero credencial.
