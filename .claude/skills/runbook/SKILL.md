---
name: runbook
description: Gera runbook operacional para procedimentos de deploy, rollback, incidentes e manutenção.
argument-hint: "[tipo: deploy|rollback|incident|maintenance]"
allowed-tools: Read Write Grep Glob Bash(git *)
model: sonnet
effort: medium
---

Você gera runbooks operacionais para a equipe.

## Processo

### 1. Perguntar (múltipla escolha)

**Tipo de runbook?**
- a) Deploy — procedimento de deploy para produção
- b) Rollback — como reverter um deploy problemático
- c) Incidente — procedimento de resposta a incidentes
- d) Manutenção — tarefas periódicas (backup, limpeza, atualização)

**Ambiente?**
- a) Staging
- b) Produção
- c) Ambos

### 2. Analisar projeto

- Ler CLAUDE.md e docker-compose.yml
- Identificar serviços e dependências
- Verificar CI/CD existente

### 3. Gerar runbook

```markdown
# Runbook: [Tipo] — [Projeto]

**Última atualização:** YYYY-MM-DD
**Responsável:** [time/pessoa]

## Pré-requisitos
- [ ] Acesso a [ambiente]
- [ ] Ferramentas instaladas

## Procedimento

### Passo 1: [Ação]
```comando```
**Verificação:** [como confirmar que funcionou]

### Passo 2: [Ação]
...

## Em caso de falha
[procedimento de rollback]

## Contatos
| Situação | Contato |
|----------|---------|
```

### 4. Confirmar e salvar
Apresente o runbook para revisão. Após aprovação, salve o documento no projeto (ex.: `docs/runbooks/<tipo>.md`) e grave o rastro em `Reports/$(date +%Y-%m-%d_%H-%M-%S)_runbook_<projeto>_<deploy|rollback|incident|maintenance>.md` seguindo `Reports/README.md`. Se `Reports/` não existir, crie.

## Regras
- **Verificação em cada passo** — nunca avançar sem confirmar
- **Rastro obrigatório** — grava em `Reports/` (`Write` apenas para docs/rastro, nunca código)
- **Rollback documentado** — sempre ter plano B
- Baseado na infraestrutura real do projeto
- Tudo em PT-BR
