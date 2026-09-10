# Guia de Banco & Migrations

> Baseline global de banco de dados e migrations. Consumido por `/migrate` e `/seed`, alinhado aos
> hooks de guarda (`guard-bash`).

## Sumário
- [Ferramentas](#ferramentas)
- [Migrations reversíveis](#migrations-reversíveis)
- [Expand e contract](#expand-e-contract)
- [Operações destrutivas](#operações-destrutivas)
- [Seed](#seed)

## Ferramentas
- **Python/SQLAlchemy → Alembic.** **Node/Prisma → `prisma migrate`.**
- Toda mudança de schema é uma **migration versionada**, nunca alteração manual no banco.

## Migrations reversíveis
- Toda migration tem um **caminho de volta provado**, não só escrito. Reversão que nunca foi executada não é plano B, é esperança.
- **Ferramenta com `down` nativo** (Alembic): escreva o `downgrade` e ensaie `up → down → up` num banco de teste, conferindo que o estado final é igual ao inicial.
- **Ferramenta sem `down`** (Prisma): o reverso vem de `migrate diff --script` ou de `migrate reset` + reaplicar — ensaie o caminho que você usaria de fato no incidente.
- O ensaio é **gateado por hook**: o operador autoriza com `CLAUDE_CONFIRM_DB=1`, e vale só para banco de teste.
- Migration acompanha o código que a usa, no mesmo PR; a **ordem** (infra/migration antes do código que depende dela) é definida no plano de merge.
- Documente constraints e índices criados.

## Expand e contract
Durante um deploy, código velho e schema novo convivem — ainda que por segundos. Mudança destrutiva feita de uma vez derruba a aplicação que ainda está no ar.
- **Destrutivo vai em duas releases.** Primeiro **expand**: cria a coluna/tabela nova (nullable ou com default), passa a escrever nos dois lugares, faz o backfill. Depois, com o código novo já em produção e estável, **contract**: para de ler o antigo e só então remove.
- **Nunca no mesmo deploy:** criar coluna `NOT NULL` sem default, renomear coluna em uso, remover coluna que o código atual ainda lê, mudar tipo de forma incompatível.
- Renomear = criar novo + copiar + passar a usar + remover depois. Renomear direto é `DROP` disfarçado.
- Backfill de tabela grande vai **em lotes**, fora do caminho da migration, com progresso observável.

## Operações destrutivas
- **Nada destrutivo sem gate explícito.** `DROP TABLE`, `TRUNCATE` e `DELETE FROM` sem `WHERE` são **bloqueados por hook**, sem escape.
- **Reversão de migration** (`alembic downgrade`, `prisma migrate reset`, `migrate --fake`) é **gateada**, não proibida: o operador autoriza com `CLAUDE_CONFIRM_DB=1` para o ensaio em banco de teste. Sem isso o agente não consegue cumprir a regra de provar a volta.
- Perda de dados é irreversível — trate como ação de alto risco, sempre com backup/plano de rollback.

## Seed
- Dados de seed são **realistas mas fake** — nunca dados reais de produção (ver [segurança/LGPD](../seguranca/guia-seguranca.md)).
- Seed é idempotente quando possível; documenta o que popula.
