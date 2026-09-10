# Guia — Doc de QA por feature (`docs/features/`)

> **O quê:** cada funcionalidade tem um conjunto de docs vivo em `docs/features/<feature>/`
> que diz **o que testar e como**, consumida pela skill `/qa`. Formato canônico:
> `Prompt_system/Guidelines/templates/FEATURE-QA-DOC-TEMPLATE.md`. Gerada/mantida pelo
> subagente `qa-doc-mapper` (skill `/qa-doc`).

## Estrutura
`docs/features/<feature>/` com 5 arquivos:
- `DOMINIO.md` — fluxo de uso · perfis de usuário/permissões · regras de negócio & pontos críticos · gotchas · **Módulos/arquivos cobertos** (chave do mapeamento `git diff → feature`).
- `MAPA-TESTES.md` — o que testar × como × o que valida × evidência.
- `WORKFLOW-E2E.md` — bateria E2E e como executar.
- `JORNADA-USUARIO.md` — a ótica do usuário: personas, mapa de jornada, expectativas e atrito (gerado por /jornada).
- `FLUXO-TELAS.md` — fluxo de navegação de telas: wireframe, dados capturados por tela e diagrama de transições (gerado por /mapa-telas, quando existir).

## Regras
- Documento **vivo**: atualizar in-place, nunca `-v2`.
- Incerteza → `[A CONFIRMAR]`. Doc imprecisa é pior que ausente.
- A seção "Módulos/arquivos cobertos" é **obrigatória** — sem ela `/qa` não ativa a feature pelo diff.
- PT-BR, exemplos realistas, zero credencial.

## Como usar
- `/qa-doc <feature>` — cria/atualiza a doc.
- `/qa --diff` — roda o QA só das features tocadas pelas alterações.
