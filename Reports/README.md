# Reports — Relatórios de Execução dos Agentes

Este diretório armazena os rastros gerados pelos agentes do ecossistema Claude Code. **Todo agente grava
um rastro ao final de toda execução** — é obrigatório pela `Guidelines/00-prompt-constitution.md`.

## Nomenclatura

```
YYYY-MM-DD_HH-MM-SS_<agente>_<projeto>_<tipo>.md
```

Os **segundos são obrigatórios**: a granularidade de minuto colide na cadência "um agente por vez".
Em shell, o nome sai de `$(date +%Y-%m-%d_%H-%M-%S)`.

**Exemplos:**
- `2026-08-01_14-30-05_security-scanner_comic-creator_scan-completo.md`
- `2026-08-01_16-00-42_test-generator_carteira-mcp_coverage-gaps.md`
- `2026-08-01_09-15-11_pr-reviewer_maestro_pr-42.md`

## Template Padrão

```markdown
# Relatório: [Tipo]

| Campo | Valor |
|-------|-------|
| **Data** | YYYY-MM-DD HH:MM:SS UTC |
| **Agente** | [Nome do agente] |
| **Projeto** | [Nome do projeto] |
| **Sessão** | [CLAUDE_SESSION_ID] |
| **Duração** | [X minutos] |
| **Aprovado por** | [quem autorizou — operador] |
| **Executado por** | [quem executou — agente/operador] |
| **Commit** | [hash curto, quando houve escrita] |

## Resumo Executivo

[2-3 frases sobre o que foi feito e o resultado principal]

## Gates acionados

| Fase | Parada | Opções apresentadas | Decisão do operador |
|------|--------|---------------------|---------------------|
| [F0] | [o que travou] | [a/b/c] | [o que foi escolhido] |

Nenhuma parada durante a execução → escreva "nenhuma", nunca omita a seção.

## Resultados Detalhados

[Conteúdo específico do agente — achados, testes, docs gerados, etc.]

## Métricas

| Métrica | Valor |
|---------|-------|
| [métrica relevante] | [valor] |

## Screenshots (se aplicável)

[Links para screenshots em Reports/screenshots/]

## Ações Recomendadas

1. [Ação 1]
2. [Ação 2]
```

## Por que "Aprovado por × Executado por"

Sem CI, este rastro é a **única evidência** de que um gate humano aconteceu. Separar quem autorizou de
quem executou é a segregação de funções mínima: em qualquer revisão posterior, dá para responder quem
autorizou aquela mudança sem depender da memória de ninguém.

## Agentes que geram relatório

Todos os 21 subagentes despacháveis. Os que gravam com mais frequência:

| Agente | Tipo de relatório |
|--------|-------------------|
| `security-scanner` | Scan de segurança com achados por severidade |
| `test-generator` | Cobertura, execução da suíte e achados para o corretor |
| `pr-reviewer` | Revisão em 5 dimensões com veredito e confiança |
| `docbot` | Documentação gerada/atualizada |
| `debugger` | Causa raiz provada e abordagem recomendada |

Exceção: a skill `/executar` grava o rastro no **workspace do plano** (`progresso.md` +
`relatorios/T*-report.md`), não aqui — está declarado no próprio prompt dela.

## Screenshots

O subdiretório `screenshots/` armazena capturas geradas via Chrome DevTools MCP durante a bateria viva
do `/qa` e a crítica de usabilidade.
