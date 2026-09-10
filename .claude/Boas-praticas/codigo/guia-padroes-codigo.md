# Guia de Padrões de Código

> Baseline global de **estilo, nomenclatura, tipagem, comentários e docstrings**. Sobrescrevível pelo
> `development/coding-standards.md` do projeto. Ver também [nomenclatura de arquivo/branch](../nomenclatura/guia-arquivos-e-branches.md)
> e [commits](../commit/guia-conventional-commits.md).

## Sumário
- [Princípios](#princípios)
- [Nomenclatura de código](#nomenclatura-de-código)
- [Estilo e formatação](#estilo-e-formatação)
- [Tipagem](#tipagem)
- [Comentários](#comentários)
- [Docstrings](#docstrings)

## Princípios
- **Reuso primeiro:** procure utilitário/padrão existente antes de criar; copie o padrão dos arquivos vizinhos.
- **Mudança mínima** que satisfaz o requisito. Sem abstração especulativa (YAGNI); sem clever que alguém decifra às 3h.
- **SOLID · DRY · KISS · YAGNI**; 1 arquivo = 1 responsabilidade.
- **Idioma:** PT-BR em identificadores de **domínio** (negócio) e comentários; inglês aceito em utilitários genéricos (`load`, `save`, `run`, `base_url`) — como no código real.

## Nomenclatura de código

| Elemento | Python | TypeScript |
|----------|--------|------------|
| Variáveis / funções | `snake_case` | `camelCase` |
| Classes / tipos / interfaces | `PascalCase` | `PascalCase` |
| Constantes | `UPPER_SNAKE_CASE` | `UPPER_SNAKE_CASE` |
| Privado | prefixo `_` | `private` / `#` |

- Nomes descrevem o **comportamento/intenção**, não a implementação.
- **Imports:** ordem `stdlib → terceiros → locais`; **absolutos** (evite relativos em Python).

## Estilo e formatação
- **Formatação é de ferramenta, não manual.** Python: **Black + isort**, lint **mypy**/Pylint. TS: **Prettier + ESLint**.
- **Line-length 100** como baseline (Python e TS).
- Sem código morto; **sem `print()`/`console.log` em produção** — use logging estruturado.
- Scripts Python autônomos: metadata **PEP 723** inline (`# /// script … ///`) para rodar via `uv run`.

## Tipagem
- **Type hints/anotações obrigatórios.**
- Python moderno: `dict[str, str]`, `X | None`, `from __future__ import annotations` (py≥3.10).
- TS em **strict mode**; **proíbe `any` e `@ts-ignore`**.

## Comentários
- **Comente o "porquê", não o "o quê".** O comentário explica a **decisão, a armadilha, o trade-off** — nunca parafraseia o código.
- **Proibido comentar o óbvio.** Se só repete o que a linha já diz, remova.
- **Simplificação deliberada** (atalho com teto conhecido) é marcada com **`# ponytail:`** / `// ponytail:`, nomeando o teto e o caminho de upgrade. (A equipe já usa esse marcador no código.)
- Idioma: **PT-BR** nos comentários inline.

## Docstrings
- **Funções/classes públicas sempre** têm docstring; privadas complexas quando o "porquê" não é óbvio; algoritmos complexos e magic numbers sempre.
- **Python: Google Style** (Args/Returns/Raises/Example), curtas e diretas. **TS: JSDoc.**
- Descreve **contrato e intenção**, não a implementação linha a linha.
