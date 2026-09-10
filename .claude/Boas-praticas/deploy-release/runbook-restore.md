# Runbook — Restore de banco

> Procedimento operacional para restaurar o banco a partir de um backup. **Não é um template
> a preencher depois**: é o passo a passo real, para ser seguido às 2h da manhã sem pensar.
> Um backup nunca restaurado não é backup — é um arquivo grande.

## Antes de precisar (faça hoje)

1. **Saiba onde está o backup.** Caminho, host, bucket. Se a resposta for "acho que tem um
   dump em algum lugar", você não tem backup.
2. **Saiba a idade do backup mais recente.** Um dump de três meses atrás é um dado histórico,
   não um plano de recuperação.
3. **Ensaie o restore uma vez.** Os passos abaixo, num banco descartável, cronometrando.
   O número que sai daí é o seu RTO real — não o que você imagina que seja.
4. **Anote o que ficou de fora.** Backup do banco não traz arquivos enviados por usuário, fila
   em memória, nem variável de ambiente. Liste o que mais precisa voltar junto.

## Restaurar

**Pare o que escreve antes de restaurar.** App e workers derrubados — restaurar com escrita
concorrente produz um estado que não é nem o antigo nem o novo.

```bash
# 0. congelar o estado atual, mesmo quebrado — é a sua única volta se o restore piorar
pg_dump "$DATABASE_URL" -Fc -f "pre-restore-$(date +%Y-%m-%d_%H-%M-%S).dump"

# 1. conferir o backup ANTES de destruir qualquer coisa
ls -lh <caminho-do-backup>                              # existe? tamanho plausível?
pg_restore --list <backup>.dump | grep -c "TABLE DATA"  # abre? quantas tabelas com dado?

# 2. restaurar num banco NOVO, nunca por cima do atual
createdb restore_teste
pg_restore -d restore_teste --no-owner --no-privileges <backup>.dump

# 3. conferir o conteúdo antes de promover
psql restore_teste -c "\dt"                                   # tabelas vieram?
psql restore_teste -c "select count(*) from <tabela_central>"  # volume plausível?
psql restore_teste -c "select max(<coluna_data>) from <tabela_central>"  # até quando o dado vai?

# 4. promover: renomear, nunca apagar
psql -c "alter database app rename to app_antes_do_restore"
psql -c "alter database restore_teste rename to app"

# 5. subir a aplicação e rodar o smoke pós-deploy
```

## Depois

- **Confirme a janela perdida.** Do timestamp do backup até o incidente: o que aconteceu nesse
  intervalo não voltou. Diga isso explicitamente a quem precisa saber — não deixe implícito.
- **Guarde o banco antigo** (`app_antes_do_restore`) até ter certeza. Espaço em disco é mais
  barato que dado perdido.
- **Postmortem obrigatório** — ver [incidente](../incidente/guia-incidente.md). Se o restore
  demorou mais que o esperado, o gargalo é uma ação preventiva com dono e prazo.

## Este runbook foi ensaiado

Em **01/08/2026**, num Postgres 16 descartável (container, 5.000 linhas): os 6 passos rodaram na
ordem acima, o volume conferiu antes da promoção e a renomeação deixou o banco anterior intacto
como `app_antes_do_restore`. **RTO medido: 1s** — número de laboratório, com dado minúsculo e sem
rede; serve para provar que o procedimento fecha, não para dimensionar o real. Re-ensaie com o
volume de produção para ter o seu número.

O que o ensaio mostrou que vale lembrar: `pg_restore --list | grep -c "TABLE DATA"` é a conferência
mais barata de "o dump abre e tem conteúdo", e a comparação de contagem antes de promover é o que
transforma o passo 3 em gate de verdade em vez de formalidade.

## Adapte ao seu banco

Os comandos acima são PostgreSQL. Para outro banco, o **roteiro** é o mesmo e só os comandos
mudam: congelar o atual → conferir o backup → restaurar isolado → conferir o conteúdo →
promover por renomeação → smoke. Se o seu projeto usa SQLite, "restaurar" é copiar o arquivo —
mas o passo de conferir o conteúdo antes de promover continua valendo.
