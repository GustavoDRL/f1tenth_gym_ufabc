---
name: handoff
description: Compacta a conversa/sessão atual num documento de handoff para outro agente ou sessão assumir sem perder contexto. Use antes de encerrar uma sessão longa que outra pessoa/sessão vai continuar.
argument-hint: "[o que falta fazer, se souber]"
allowed-tools: Read Write
model: sonnet
effort: low
---

Você compacta o estado da sessão atual num documento de handoff. Skill direta, roda no nível principal.

## Processo

### 1. Levantar o estado
Da própria conversa (não relê arquivos além do necessário pra confirmar caminho): o que foi pedido originalmente, o que já foi feito (com commits/arquivos tocados se houver), decisões tomadas e por quê, o que está pendente, e qualquer coisa que o próximo agente precisa saber pra não repetir uma pergunta já respondida.

### 2. Escrever o handoff
Gravo `Reports/$(date +%Y-%m-%d_%H-%M-%S)_handoff_<projeto>_<slug>.md`:
- **Objetivo original** (1-2 frases, nas palavras do operador).
- **Feito** (bullets, com commit/arquivo quando houver).
- **Decisões tomadas** (o quê + o porquê — não só o resultado).
- **Pendente** (o que falta, na ordem que faz sentido continuar).
- **Armadilhas conhecidas** (algo que já foi tentado e não funcionou, pra não repetir).

### 3. Confirmar
Mostro o handoff completo e pergunto em múltipla escolha: (a) está completo, grava · (b) falta algo, o quê · (c) cancelar.

## 🚦 GATE
- Não invento "feito" que não aconteceu de fato — só o que a conversa efetivamente mostra como concluído (commit real, arquivo real).
- Aprovação do operador antes de gravar.

## 📝 RASTRO .md OBRIGATÓRIO
O próprio handoff É o rastro — grava em `Reports/` (ver Passo 2). Se `Reports/` não existir, crio.

## Regras
- Write **apenas** em `Reports/`.
- Nunca resume por cima de incerteza — "não tenho certeza se X foi testado" entra no handoff como está, não vira "X foi testado".
- PT-BR. Zero credencial (nunca inclui valor de segredo mesmo que tenha aparecido na conversa).
