# Boas Práticas de Engenharia

Fonte única dos padrões de engenharia do hub. Vale para **qualquer projeto**. Cada projeto pode
**detalhar/sobrescrever** no seu `development/coding-standards.md` — em conflito, **o doc do projeto vence**;
na ausência dele, **estes documentos são o padrão**.

Os agentes do ecossistema Claude Code (`feature-builder`, `corretor`, `optimizer`, `test-generator`,
`escrever-teste`, `pr-reviewer`) consultam **estes guias + o `development/coding-standards.md` do projeto**
ao escrever ou revisar código.

> **Onde estes guias moram:** no hub, em `Boas-praticas/`. Em cada projeto-alvo, o `deploy.sh` os copia
> para **`.claude/Boas-praticas/`** — é de lá que os agentes leem quando rodam dentro do projeto. Caminhos
> citados nos prompts (`Boas-praticas/<x>/`) devem ser procurados nos dois lugares; não achando nenhum, o
> agente cai no fallback (padrão dos vizinhos + `CLAUDE.md` local). O
> [mapa de documentação](./documentacao/mapa-documentacao.md) lista onde cada projeto vive.

## Índice de padrões

Organizados pelo ciclo de desenvolvimento (do código à entrega).

### Fundamentos (como o código é escrito)
| Domínio | Guia | Cobre |
|---------|------|-------|
| **Código** | [`codigo/guia-padroes-codigo.md`](./codigo/guia-padroes-codigo.md) | Nomenclatura de código, estilo/formatação, tipagem, comentários, docstrings |
| **Arquitetura** | [`arquitetura/guia-arquitetura.md`](./arquitetura/guia-arquitetura.md) | Camadas, reuso, integração externa, ADRs, versionamento de API |
| **Design System** | [`design-system/guia-design-system.md`](./design-system/guia-design-system.md) | Onde achar os tokens do projeto, regra de UI, piso de acessibilidade, dark mode |
| **Nomenclatura** | [`nomenclatura/guia-arquivos-e-branches.md`](./nomenclatura/guia-arquivos-e-branches.md) | Arquivos, pastas, branches |
| **Erros & Logging** | [`erros-logging/guia-erros-logging.md`](./erros-logging/guia-erros-logging.md) | Logging estruturado, sem print, exceções, níveis |

### Validação (como se garante qualidade)
| Domínio | Guia | Cobre |
|---------|------|-------|
| **Testes** | [`testes/guia-testes.md`](./testes/guia-testes.md) | Lanes, tipos, AAA, cobertura P0–P3, cálculo crítico, mocks |
| **Segurança** | [`seguranca/guia-seguranca.md`](./seguranca/guia-seguranca.md) | OWASP, secrets/`.env`, dado pessoal (base legal/retenção/titular), auth, o que nunca logar |
| **Code Review & PR** | [`code-review/guia-code-review.md`](./code-review/guia-code-review.md) | Template de PR, 5 dimensões, severidade, scoring, veredito |

### Entrega e operação
| Domínio | Guia | Cobre |
|---------|------|-------|
| **Commits** | [`commit/guia-conventional-commits.md`](./commit/guia-conventional-commits.md) | Conventional Commits em PT-BR, tipos, escopo, SemVer |
| **Deploy & Release** | [`deploy-release/guia-deploy-release.md`](./deploy-release/guia-deploy-release.md) | Deploy manual/local, gate, SemVer, changelog, runbook, monitoramento em produção |
| **Restore de banco** | [`deploy-release/runbook-restore.md`](./deploy-release/runbook-restore.md) | Procedimento real de restore, ensaio prévio, promoção por renomeação, janela perdida |
| **Incidente** | [`incidente/guia-incidente.md`](./incidente/guia-incidente.md) | Severidade SEV1–4, incidente de segurança, postmortem obrigatório, blameless |
| **Dependências** | [`dependencias/guia-dependencias.md`](./dependencias/guia-dependencias.md) | uv/pnpm, escada antes de adicionar, licença e manutenção, SLA de CVE |
| **Banco & Migrations** | [`banco-migrations/guia-banco-migrations.md`](./banco-migrations/guia-banco-migrations.md) | Alembic/Prisma, reversão provada, expand e contract, nada destrutivo sem gate |

### Transversal
| Domínio | Guia | Cobre |
|---------|------|-------|
| **Documentação** | [`documentacao/guia-documentacao.md`](./documentacao/guia-documentacao.md) | Doc durável × pacote, rastro, marcador de incerteza, Obsidian/Mermaid |
| **Mapa de docs** | [`documentacao/mapa-documentacao.md`](./documentacao/mapa-documentacao.md) | Onde vive cada projeto-alvo: caminho, stack, manifesto, estado do `.claude/` |
| **Doc de QA por feature** | [`documentacao/guia-feature-qa-doc.md`](./documentacao/guia-feature-qa-doc.md) | Tríade `docs/features/<f>/`: DOMINIO, MAPA-TESTES, WORKFLOW-E2E |
| **Planejamento em 3 camadas** | [`documentacao/guia-planejamento-3-camadas.md`](./documentacao/guia-planejamento-3-camadas.md) | Coletar → revisar → planejar, modo detetive, premortem, execução rastreável |

## Princípios que atravessam tudo
- **Reuso primeiro; mudança mínima** (YAGNI, DRY, KISS, SOLID). Copie o padrão dos vizinhos antes de inventar.
- **PT-BR** em domínio/negócio e comentários; inglês aceito em utilitários genéricos.
- **Evidência sobre suposição:** afirme com `arquivo:linha`; o que não dá para confirmar é marcado, não afirmado.
