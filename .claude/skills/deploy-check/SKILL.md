---
name: deploy-check
description: Valida a prontidão de deploy end-to-end — validação local (incl. deploy local + app no ar), compara o deploy.sh de produção com o local, e prepara (via /runbook) o manual de deploy produtivo. Veredito PRONTO/NÃO PRONTO + rastro.
argument-hint: "[branch de integração, default: main]"
allowed-tools: Read Write Grep Glob Bash(git *) Bash(npm *) Bash(pnpm *) Bash(pytest *) Bash(python *) Bash(uv *) Bash(docker *) Agent
model: sonnet
effort: high
---

Você **valida a prontidão de deploy** de ponta a ponta e **prepara o deploy produtivo**. Skill direta — **não há subagente de CI/CD**; roda no nível principal. Não há CI configurada no repo hoje, então a validação é **local**.

## Processo

### 1. Checklist de validação local
Rode na branch de integração (default `main`). **Não checo CI** (não há pipeline configurado).

| Check | Comando (adapta à stack) | Bloqueia? |
|-------|--------------------------|-----------|
| Mudanças não commitadas? | `git status` | sim |
| Branch atualizada com a base? | `git fetch && git status` | sim |
| Testes (re-roda na integração) | `pytest` / `uv run pytest` / `pnpm test` | sim |
| QA das features afetadas | `/qa --diff` (roda o QA só das features tocadas) | sim |
| Lint/format | `ruff`/`black --check` / `eslint`/`prettier` | sim |
| Build | `docker compose build` / `pnpm build` | sim |
| Migrations pendentes | `alembic heads`/`current` · `prisma migrate status` | sim |
| Reversão da migration ensaiada (se o pacote tem migration) | ensaio no banco de teste, `CLAUDE_CONFIRM_DB=1` | sim |
| Error tracking do serviço declarado | `.claude/observabilidade.md` ou variável de DSN no `.env.example` | sim |
| Auditoria de deps | `pip audit` / `pnpm audit` | aviso |

### 2. Deploy local (ensaio do produtivo)
Executa o **script/rotina de deploy local**, **sobe a aplicação** localmente e **valida as alterações** de verdade (smoke/end-to-end nos fluxos afetados). É o ensaio que dá confiança pro deploy produtivo. Falha aqui → **NÃO PRONTO**.

### 3. Comparação do deploy produtivo × local
Localiza o **`deploy.sh` de produção** e o compara com o **script de deploy local** (`diff`): passos, variáveis de ambiente, ordem, migrations, serviços. **Divergência não justificada → NÃO PRONTO** até revisão/justificativa.

### 4. Manual de deploy produtivo (via /runbook)
Aciona o **`/runbook`** para gerar o manual de deploy produtivo com base nas alterações + na documentação do pacote (do `/fix`/`/debug`), para que o agente que fará o deploy em produção tenha **tudo em mãos** (passos, env, migrations, rollback). Consolida o caminho do manual no veredito.

### 5. Smoke pós-deploy (o roteiro, não a execução)
Defino e entrego o **smoke pós-deploy**: 3–5 chamadas que provam que o essencial respondeu depois de subir (rota principal, autenticação, a operação que move valor, o job que precisa voltar a rodar), cada uma com **resultado esperado** e o **critério de aborto** que manda reverter na hora. Sem esse roteiro definido → **NÃO PRONTO**: subir sem saber o que conferir depois é o mesmo que não conferir. A execução em produção é do operador, seguindo o runbook.

### 6. Veredito + rastro
```
DEPLOY CHECK — [PROJETO] (base: main)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Validação local (testes/lint/build/migrations)
✅ QA das features afetadas (/qa --diff): APROVADO
✅ Deploy local subiu e validou os fluxos afetados
⚠️  deploy.sh prod × local: 1 diferença (variável NOVA_ENV) — justificar
✅ Manual de deploy gerado (via /runbook)
✅ Reversão da migration ensaiada (up → down → up)
❌ Error tracking: serviço 'worker' sem destino de alerta configurado
✅ Smoke pós-deploy definido (4 chamadas + critério de aborto)

VEREDICTO: NÃO PRONTO — error tracking ausente; justificar o diff do deploy.sh
```
Grave o veredito em `Reports/$(date +%Y-%m-%d_%H-%M-%S)_deploy-check_<projeto>_prontidao.md` seguindo `Reports/README.md`. Se `Reports/` não existir, crie.

## Regras
- **Validação local completa** — sem CI, o ensaio local (incl. deploy local + app no ar) é a garantia.
- Veredito claro: **PRONTO / NÃO PRONTO**; diff não justificado do `deploy.sh` prod×local **bloqueia**.
- QA de feature REPROVADO **bloqueia** (NÃO PRONTO).
- **Serviço sem error tracking declarado = NÃO PRONTO.** A declaração é verificável: um `.claude/observabilidade.md` de uma linha (ferramenta · destino do alerta · quem recebe) ou a variável de DSN no `.env.example`. Projeto que conscientemente não tem error tracking registra isso **uma vez** nesse arquivo, com o motivo — aí vira `aviso`, não bloqueio. O que não vale é o silêncio: ver `Boas-praticas/deploy-release/` › *Monitoramento em produção*.
- **Pacote com migration e rollback não ensaiado = NÃO PRONTO.** Plano B que nunca rodou não é plano B. Pacote sem migration → linha marcada N/A.
- O veredito do `/qa --diff` **inclui a bateria viva Chrome MCP** para features web; logo, feature web sem bateria viva = **NÃO PRONTO** (via o próprio veredito do `/qa` — não duplico a lógica aqui).
- **Rastro obrigatório** em `Reports/` (uso `Write` **apenas** para o rastro/manual, nunca código de produção).
- O manual produtivo vem do **`/runbook`** (não reimplemento aqui).
- Tudo em PT-BR.
