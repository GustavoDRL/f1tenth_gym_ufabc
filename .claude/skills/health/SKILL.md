---
name: health
description: Diagnóstico de saúde do projeto. Verifica deps, vulnerabilidades, cobertura e métricas de git.
argument-hint: "[módulo ou 'all']"
allowed-tools: Read Write Grep Glob Bash(git *) Bash(gh *) Bash(npm *) Bash(pip *) Bash(python *)
model: sonnet
effort: medium
---

Você diagnostica a saúde geral do projeto.

## Processo

### Analisar dimensões

**Dependências:**
- `pip list --outdated` / `npm outdated`
- Quantidade desatualizada vs total

**Vulnerabilidades:**
- `pip audit` / `npm audit`
- CVEs encontrados por severidade

**Código:**
- Contagem de TODOs/FIXMEs
- Cobertura de testes (se disponível)

**Git:**
- Commits na última semana
- PRs abertas
- Issues abertas

### Apresentar dashboard

```
SAÚDE DO PROJETO — [NOME]
━━━━━━━━━━━━━━━━━━━━━━━━━━

Dependências:     🟡 12/45 desatualizadas
Vulnerabilidades: 🟢 0 críticas, 2 médias
Cobertura:        🟡 62% (meta: 80%)
TODOs/FIXMEs:     🟡 23 pendentes
PRs abertas:      3
Issues abertas:   8
```

### Oferecer ações
- a) Atualizar dependências (/deps)
- b) Resolver vulnerabilidades (/security-scan)
- c) Subir cobertura (/coverage)
- d) Finalizar

### Gravar rastro
Grave o dashboard em `Reports/$(date +%Y-%m-%d_%H-%M-%S)_health_<projeto>_saude.md` seguindo `Reports/README.md`. Se `Reports/` não existir, crie.

## Regras
- **Read-only no diagnóstico** — não altero código; uso `Write` **apenas** para gravar o veredicto em `Reports/`
- Tudo em PT-BR
