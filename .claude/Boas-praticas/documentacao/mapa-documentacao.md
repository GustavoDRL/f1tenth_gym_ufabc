# Mapa de Documentação — projetos-alvo do hub

> Índice canônico de onde vive cada projeto onde este hub é deployado. É a **primeira parada da Fase 0**
> de qualquer agente: antes de assumir que algo não existe, procure aqui.
>
> **Premissa:** os caminhos abaixo são absolutos na máquina do operador. Dentro de um projeto-alvo, a
> fonte de verdade é sempre o `CLAUDE.md` local + o código; este mapa só diz onde as coisas estão.

## Projetos-alvo

| Projeto | Caminho | O que é | Manifestos | `.claude/` |
|---|---|---|---|---|
| **comic_creator** | `~/Documents/Gustavo/comic_creator` | Backend Python + frontend JS | `backend/pyproject.toml` · `frontend/package.json` | parcial (`commands/`) |
| **SyncHear** | `~/Documents/Gustavo/SyncHear` | App Flutter + backend Python | `synchear_backend/pyproject.toml` | **completo** (deploy de 01/08) |
| **carteira-mcp** | `~/Documents/Gustavo/Investimento/carteira-mcp` | Servidor MCP em Python + frontend | `pyproject.toml` · `frontend/package.json` | completo (hooks + settings) |
| **maestro** | `~/Documents/Gustavo/maestro` | Gerador Python + app (backend/frontend) | `gerador/requirements.txt` · `app/backend/requirements.txt` · `app/frontend/package.json` | parcial (`agents/`, `skills/`) |
| **plan** | `~/Documents/Gustavo/plan` | Vault de planejamento: domínio Python + API + SPA | `gerador/requirements.txt` · `app/backend/requirements.txt` · `app/frontend/package.json` | completo (hooks + settings) |
| **tbi** | `~/Documents/Gustavo/tbi` | Modelo de predição de trauma (TBI) em Python | `requirements.txt` | ausente |
| **GenAi-EdU** | `~/Documents/Gustavo/GenAi-EdU` | EduAnalytics Pro — dashboard Streamlit de desempenho acadêmico + IA (`code/v2` é a versão corrente) | `code/v1/requirements.txt` · `code/v2/requirements.txt` | ausente |
| **f1** | `~/Documents/Gustavo/f1` | Corrida autônoma F1TENTH: ROS2 em container + MCP server. **Dois repos lado a lado**, o pai não é git | `f1tenth_code/mcp_server/pyproject.toml` | ausente |

> **Todos os 8 têm `CLAUDE.md`.** O de `f1` fica no diretório pai (que não é repositório — são dois
> repos lado a lado, `f1tenth_code` e `f1tenth_gym_ufabc`), então não é versionado: se a pasta sumir,
> o guia some junto.

## Convenção de documentação por projeto
Quando um projeto tem documentação estruturada, ela segue este layout (nem todo projeto tem todos):
- `00-README.md` ou `README.md` — entrypoint
- `CLAUDE.md` — contexto para os agentes (stack, comandos, convenções, risco)
- `architecture/` — visão de sistema e componentes
- `decisions/` — ADRs numerados (`NNN-*.md`)
- `development/coding-standards.md` — padrão de código do projeto (**sobrescreve** `Boas-praticas/`)
- `docs/features/<feature>/` — tríade de QA por feature (DOMINIO · MAPA-TESTES · WORKFLOW-E2E); ver
  [guia-feature-qa-doc.md](./guia-feature-qa-doc.md)

## O hub
- `Prompt_system/Agents/` · `Skils/` — os agentes e as skills distribuídos pelo `deploy.sh`
- `Prompt_system/Boas-praticas/` — baseline global de engenharia (este diretório)
- `Prompt_system/runtime/` — camada de execução multiagente (harness, orquestrador, redação, evals) e o
  verificador do hub (`harness.lint_hub`)
- `Prompt_system/Guidelines/` — constituição de prompt, catálogos, fluxos e templates
