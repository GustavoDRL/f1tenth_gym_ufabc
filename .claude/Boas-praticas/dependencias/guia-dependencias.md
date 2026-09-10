# Guia de Dependências

> Baseline global de gestão de dependências. Consumido por `/deps` e `feature-builder`.

## Sumário
- [Gerenciadores](#gerenciadores)
- [Adicionar uma dependência](#adicionar-uma-dependência)
- [Lockfiles](#lockfiles)
- [Auditoria](#auditoria)

## Gerenciadores
- **Python: `uv`** (`uv add`, `uv run`). **Node: `pnpm`** nos projetos (npm apenas onde já é o padrão do repo).
- **Scripts Python autônomos:** metadata **PEP 723** inline (`# /// script … dependencies = [...] ///`) para rodar via `uv run` sem projeto.

## Adicionar uma dependência
- **Suba a escada antes de adicionar:** stdlib → recurso nativo → dependência **já instalada** → só então nova dependência. Não adicione um pacote para o que poucas linhas resolvem.
- Justifique a dependência nova (o que ela faz que o que já existe não faz) no PR.
- **Versões exatas, nunca "latest".**
- Antes de adotar, confira em um minuto: **licença** compatível com o uso (cuidado com copyleft forte em produto fechado, e com pacote sem licença declarada — sem licença é "sem permissão"); **manutenção** viva (último release, issues respondidas, mais de um mantenedor); sinais de **abandono** (arquivado, sem commit há anos, deprecated no próprio README); e o peso das **transitivas** que ela arrasta.
- Dependência que falha nesses critérios mas resolve o problema: adote com **decisão registrada** (ADR) e o plano de saída — não em silêncio.

## Lockfiles
- Lockfile (`uv.lock`, `pnpm-lock.yaml`) é **versionado** — garante build reproduzível.
- Atualização de dependência é uma mudança como outra: entra em branch, PR e review.

## Auditoria
- `/deps` audita versões desatualizadas e vulnerabilidades conhecidas (CVE) — alimenta o [guia de segurança](../seguranca/guia-seguranca.md).
- Dependência com **CVE crítico** é tratada como achado de segurança — para o que estiver fazendo e trate primeiro.
- **Prazo de correção (SLA) por severidade**, contado da descoberta: **crítico para o que estiver fazendo** e trata agora · alto no mesmo dia de trabalho · médio e baixo no próximo toque naquele repositório. Não dá para cumprir? Registre o risco aceito e a data de revisão — o que não pode é o relógio correr sem ninguém olhando.
- Sem CI que rode a auditoria sozinho, deixe o **Dependabot** ligado no repositório: ele abre as PRs sem exigir pipeline.
