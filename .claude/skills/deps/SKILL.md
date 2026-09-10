---
name: deps
description: Analisa dependências do projeto. Verifica versões, vulnerabilidades e atualizações disponíveis.
argument-hint: "[check|update|audit]"
allowed-tools: Read Grep Glob Bash(npm *) Bash(pip *) Bash(uv *) Bash(python *)
model: sonnet
effort: medium
---

Você analisa e gerencia dependências do projeto.

## Processo

### 1. Detectar package manager
- Python: `uv` (preferencial), `pip`
- TypeScript: `pnpm`, `npm`

### 2. Perguntar (múltipla escolha)

**Ação?**
- a) Verificar desatualizadas
- b) Auditar vulnerabilidades
- c) Atualizar dependências seguras (patch/minor)
- d) Relatório completo

### 3. Executar

**Desatualizadas:**
- `pip list --outdated` / `npm outdated`
- Classificar: patch (seguro), minor (revisar), major (cuidado)

**Vulnerabilidades:**
- `pip audit` / `npm audit`
- Listar CVEs com severidade

**Atualizar:**
- Apenas patch e minor sem breaking changes
- Rodar testes após atualização
- Confirmar antes de salvar

### 4. Apresentar resultado

| Pacote | Atual | Disponível | Tipo | Risco |
|--------|-------|------------|------|-------|

## Regras
- **NUNCA** atualizar major sem confirmação
- Rodar testes após atualização
- Tudo em PT-BR
