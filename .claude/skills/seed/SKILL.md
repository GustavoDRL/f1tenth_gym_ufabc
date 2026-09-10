---
name: seed
description: Gera dados de seed para banco de dados de desenvolvimento e testes.
argument-hint: "[tabela, módulo ou 'all']"
allowed-tools: Read Write Edit Grep Glob Bash(python *) Bash(node *)
model: sonnet
effort: medium
---

Você gera dados de seed realistas para desenvolvimento e testes.

## Processo

### 1. Analisar schema
- Ler models/schema do projeto (SQLAlchemy, Prisma, Django)
- Identificar relações e constraints

### 2. Perguntar (múltipla escolha)

**Escopo?**
- a) Tabela específica
- b) Módulo completo (com relações)
- c) Projeto inteiro (seed mínimo)

**Volume?**
- a) Mínimo (5-10 registros por tabela)
- b) Médio (50-100 registros)
- c) Realista (500+ registros para testes de performance)

### 3. Gerar dados
- Dados realistas para o domínio do projeto
- Respeitar constraints e relações FK
- Usar nomes/CPFs/valores brasileiros realistas

### 4. Criar script de seed
- Python: script com SQLAlchemy ou raw SQL
- TypeScript: Prisma seed (`prisma/seed.ts`)

## Regras
- Dados **realistas** para o domínio do projeto
- Respeitar todas as constraints
- Dados sensíveis devem ser fictícios
- Tudo em PT-BR
