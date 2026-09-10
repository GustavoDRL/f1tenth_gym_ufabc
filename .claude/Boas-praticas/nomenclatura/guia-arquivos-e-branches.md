# Guia de Nomenclatura — Arquivos, Pastas e Branches

> Baseline global. Sobrescrevível pelo `development/coding-standards.md` do projeto.

## Sumário
- [Arquivos e pastas](#arquivos-e-pastas)
- [Testes](#testes)
- [Branches](#branches)
- [Rastros de agente](#rastros-de-agente)

## Arquivos e pastas
- **Python:** arquivos e módulos em `snake_case.py`.
- **TypeScript:** arquivos em **`kebab-case.ts`** (`auth-controller.ts`, `user-service.ts`).
- **Pastas:** `kebab-case`. Evite espaços e `SCREAMING_SNAKE` em nomes de arquivo/pasta de docs (a base legada tem casos assim — não replique).
- **ADR:** `decisions/NNN-slug-kebab.md` (3 dígitos, autonumerado).
- **Docs de projeto:** esqueleto padrão `00-README.md` + `architecture/` + `decisions/` + `development/`.

## Testes
- **Python:** `test_*.py` (pytest).
- **TypeScript:** siga o sufixo que o repositório já usa (`*.test.ts(x)` ou `*.spec.ts`) — consistência vence preferência.
- Nome do teste descreve o **comportamento** verificado, não a implementação.

## Branches
- **Base = `main`** (não há `develop` no fluxo real; PRs/merges vão direto para `main`).
- Padrão: **`<tipo>/<slug-kebab>`**, com `<tipo>` = tipo do conventional commit — `feat/ fix/ refactor/ chore/ docs/`.
- Slug em **kebab-case PT-BR** descrevendo a mudança (`feat/mock-credenciais-env`, `refactor/dispatchers-finos`).
- **Incidente de produção:** branch `fix/<slug>` (rótulo `hotfix/` opcional para urgência). O que muda é o **rigor + `/postmortem` obrigatório**, **não** a base — continua saindo de e voltando para `main`. Sem back-merge (não há `develop`).

## Rastros de agente
- Formato central: `Reports/AAAA-MM-DD_HH-MM-SS_<agente>_<projeto>_<tipo>.md` (segundos evitam colisão). Ver `Prompt_system/Guidelines/00-prompt-constitution.md`.
