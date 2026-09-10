---
name: postmortem
description: Gera template de postmortem para documentar incidentes, causas e aprendizados.
argument-hint: "[título do incidente]"
allowed-tools: Read Write Grep Glob Bash(git *)
model: sonnet
effort: medium
---

Você gera postmortems estruturados para documentar incidentes.

## Processo

### 1. Perguntar (múltipla escolha)

**Severidade do incidente?**
- a) SEV1 — sistema fora do ar, impacto total
- b) SEV2 — funcionalidade crítica degradada
- c) SEV3 — funcionalidade secundária afetada
- d) SEV4 — impacto mínimo, preventivo

**Área afetada?**
- a) API / Backend
- b) Frontend / UI
- c) Banco de dados
- d) Integração externa (API de terceiro)
- e) Infraestrutura (Docker, deploy local/manual)

**Já foi resolvido?**
- a) Sim — documentando para aprendizado
- b) Não — ainda em andamento
- c) Workaround aplicado — correção definitiva pendente

### 2. Coletar contexto

Se já resolvido:
- `git log` para encontrar commits de fix
- Analisar o que mudou
- Identificar causa raiz

### 3. Gerar postmortem

```markdown
# Postmortem: [Título do Incidente]

**Data:** YYYY-MM-DD
**Severidade:** SEV[1-4]
**Duração:** [tempo de impacto]
**Status:** [Resolvido | Em andamento | Workaround]

## Resumo Executivo
[2-3 frases: o que aconteceu, impacto, resolução]

## Timeline
| Hora | Evento |
|------|--------|
| HH:MM | Incidente detectado |
| HH:MM | Investigação iniciada |
| HH:MM | Causa raiz identificada |
| HH:MM | Fix aplicado |
| HH:MM | Serviço restaurado |

## Causa Raiz
[Descrição técnica detalhada]

## Impacto
- **Usuários afetados:** [número/percentual]
- **Funcionalidades:** [lista]
- **Dados:** [perda/corrupção se houve]

## Resolução
[O que foi feito para resolver]

## Ações Preventivas
| Ação | Responsável | Prazo | Status |
|------|-------------|-------|--------|
| [ação 1] | [pessoa] | [data] | [ ] |
| [ação 2] | [pessoa] | [data] | [ ] |

## Lições Aprendidas
1. [O que aprendemos]
2. [O que faríamos diferente]

## Referências
- PR de fix: #NNN
- Issue: #NNN
- Logs: [link]
```

### 4. Confirmar e salvar
Apresente o postmortem para revisão. Após aprovação, salve o documento no projeto (ex.: `docs/postmortems/<data>-<slug>.md`) e grave o rastro em `Reports/$(date +%Y-%m-%d_%H-%M-%S)_postmortem_<projeto>_incidente.md` seguindo `Reports/README.md`. Se `Reports/` não existir, crie.

## Regras
- **Obrigatório em todo incidente de produção** (SEV1–4) — é o passo final do Fluxo 6 (Incidente em Produção), independente da severidade.
- **Blame-free** — foco em processo, não em pessoas
- **Rastro obrigatório** — grava em `Reports/` (`Write` apenas para docs/rastro, nunca código)
- **Ações concretas** — cada lição vira ação com responsável
- Baseado em evidências reais (git log, commits)
- Tudo em PT-BR
