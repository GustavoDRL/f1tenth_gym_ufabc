# Guia de Documentação

> Baseline global de documentação gerada e rastros. Sobrescrevível pelo `development/coding-standards.md`
> do projeto. Docstrings in-code ficam no [guia de código](../codigo/guia-padroes-codigo.md).

## Sumário
- [Dois tipos de doc](#dois-tipos-de-doc)
- [Marcador de incerteza](#marcador-de-incerteza)
- [Formato e convenções](#formato-e-convenções)
- [Rastro obrigatório](#rastro-obrigatório)

## Dois tipos de doc
- **Doc de pacote (da branch)** — entregue pelo `feature-builder` (via `/fix`//`/build`) e usada no review: **(1) o problema · (2) como testar · (3) como reproduzir · (4) o porquê da solução**. Vive na branch, serve à entrega.
- **Doc técnica durável** — produzida pelo `docbot` (`/docs`, `/explain`, `/diagram`, `/adr`, `/changelog`, `/glossary`): README, `architecture/`, `api-reference`, ADRs, glossário. É a referência de longo prazo do módulo/API.
- **São escopos distintos** — a doc durável não reescreve a de pacote nem vice-versa.

## Marcador de incerteza
- **Fato que não pôde ser confirmado contra o código NÃO é afirmado como certo** — é marcado.
- **Token único: `[A CONFIRMAR]`** (opcionalmente `[A CONFIRMAR: com quem/onde]`). Unifica os antigos `[A CONFIRMAR COM O TIME]`, `[INFERIDO]` e `⚠️ A validar`.
- Precisão acima de velocidade: doc imprecisa é pior que doc ausente.

## Formato e convenções
- **Idioma:** PT-BR técnico e direto.
- **Diagramas:** Mermaid, baseados no código real (arquitetura `graph TB`, sequência `sequenceDiagram`, dados `erDiagram`; ≤~15 nós, labels descritivos).
- **Frontmatter Obsidian** (`title/date/tags/aliases`) + wiki-links `[[ ]]` são **obrigatórios apenas no vault `Estudo/`**; na doc de projeto/API são opcionais (a maioria não usa).
- **Versões exatas, nunca "latest";** exemplos com dados realistas; **zero credenciais/secrets reais** (use placeholders).

## Rastro obrigatório
- Todo agente grava rastro `.md` ao final em `Reports/AAAA-MM-DD_HH-MM-SS_<agente>_<projeto>_<tipo>.md`, incluindo a seção **"Gates acionados"** (qual parada ocorreu e a opção escolhida pelo operador). Ver `Prompt_system/Guidelines/00-prompt-constitution.md`.
