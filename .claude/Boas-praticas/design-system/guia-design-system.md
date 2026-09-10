# Guia de Design System

> Baseline global de UI. Vale para todo código de frontend (React, Vue, dashboards). Sobrescrevível pelo
> `development/coding-standards.md` do projeto. A fonte dos **valores** é sempre o design system do próprio
> projeto — este guia fixa a regra e diz onde procurar.

## Sumário
- [Onde está a fonte](#onde-está-a-fonte)
- [Regra](#regra)
- [Quando se aplica](#quando-se-aplica)

## Onde está a fonte
Procure nesta ordem, e **pare no primeiro que existir**:
- **Design system declarado** no `CLAUDE.md` do projeto (caminho ou pacote).
- **Tokens no repo** — `tokens.css`/`variables.css` com custom properties, `tailwind.config.*` (`theme.extend`), tema do styled-components/Chakra/MUI.
- **Biblioteca de componentes** já instalada — a variação existente manda; leia o componente vizinho antes de criar outro.
- **Nada disso existe** → é lacuna: exponha ao operador antes de inventar paleta, escala ou espaçamento.

> Quando houver duas fontes divergentes (ex.: um arquivo de tema e um config de build com hex diferentes),
> **pergunte qual manda** e registre a resposta — divergência silenciosa vira dívida de UI.

## Regra
- **Código de UI segue os tokens do projeto.** Cor, spacing, tipografia, radius, sombra, z-index e breakpoint
  vêm de token (`var(--…)` / classe utilitária), **nunca** de valor hardcoded.
- **Dark mode e acessibilidade** seguem as convenções já adotadas no projeto (não reinvente contraste/foco/estados).
- Componente novo espelha um componente existente antes de inventar variação.
- **Piso de acessibilidade**, mesmo sem design system: contraste 4.5:1 em texto normal, foco visível, alvo de toque ≥44px, hierarquia semântica de heading, `label` associado a todo campo, e nenhuma informação transmitida só por cor.
- Divergência necessária entre o código e o design system é **decisão registrada** (ADR), não desvio silencioso.

## Quando se aplica
Projetos com frontend. Projetos só-backend ignoram este guia.
