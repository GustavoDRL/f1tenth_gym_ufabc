---
name: migrate
description: Cria ou gerencia migrations de banco de dados (Alembic para Python, Prisma para TypeScript).
argument-hint: "[descrição da migration]"
allowed-tools: Read Write Edit Grep Glob Bash(git *) Bash(python *) Bash(alembic *) Bash(npx prisma *)
model: sonnet
effort: high
---

Você cria e gerencia migrations de banco de dados.

## Processo

### 1. Detectar ORM
- Python: Alembic (SQLAlchemy) → `alembic revision --autogenerate`
- TypeScript: Prisma → `npx prisma migrate dev`

### 2. Perguntar (múltipla escolha)

**Ação?**
- a) Criar nova migration
- b) Aplicar migrations pendentes
- c) Reverter última migration
- d) Verificar status das migrations

**Tipo de mudança?** (se criar nova)
- a) Adicionar tabela/coluna
- b) Alterar tipo/constraint
- c) Remover tabela/coluna
- d) Adicionar índice

### 3. Gerar migration
- Analisar models/schema atuais
- Gerar migration com nome descritivo
- Escrever **up e down** — a reversão faz parte da migration, não é opcional
- Revisar SQL gerado antes de aplicar
- **Coluna que guarda dado pessoal** (CPF/documento, e-mail, telefone, endereço, dado financeiro): sinalizar na descrição da migration e confirmar com o operador a finalidade e o prazo de retenção — ver `Boas-praticas/seguranca/`
- **Mudança destrutiva** (remover/renomear coluna em uso, `NOT NULL` sem default, mudança incompatível de tipo): aplicar **expand e contract** em duas releases, nunca de uma vez — ver `Boas-praticas/banco-migrations/`

### 4. Provar a reversão (antes de considerar pronta)
Ensaio a reversão **no banco de teste** e confiro que o estado final bate com o inicial. O comando depende da ferramenta:
- **Alembic:** `upgrade head → downgrade -1 → upgrade head`.
- **Prisma:** não gera `down` — uso `migrate diff --from-schema-datamodel --to-migrations --script` para obter o script reverso e aplico, ou `migrate reset` + reaplicar. O que **não** vale é declarar reversível sem ter provado.

O hook `guard-bash` gateia reversão de migration: preciso do operador definindo **`CLAUDE_CONFIRM_DB=1`** no ambiente. Sem essa autorização → **PARO e peço**, não contorno. Falhou ou deixou resíduo → **PARO e reporto**: a migration não está pronta. Banco de teste indisponível → PARO e pergunto (nunca rodo isso em banco de dev com dado, muito menos em produção).

### 5. Confirmar antes de aplicar

## Regras
- **NUNCA** aplicar migration destrutiva sem confirmação
- Migrations são **reversíveis** — `down` escrito e **executado** ao menos uma vez (passo 4)
- Nome descritivo: `add_commission_rules_table`, `alter_proposal_status_enum`
- Tudo em PT-BR
