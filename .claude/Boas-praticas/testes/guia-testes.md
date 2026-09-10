# Guia de Testes

> Baseline global de testes. Sobrescrevível pelo `development/coding-standards.md` do projeto.
> Consumido por `test-generator` (`/test`, `/coverage`, `/mock`) e `escrever-teste`.

## Sumário
- [Lanes (quem escreve × quem roda)](#lanes-quem-escreve--quem-roda)
- [Tipos de teste](#tipos-de-teste)
- [Estrutura AAA](#estrutura-aaa)
- [Cobertura por prioridade](#cobertura-por-prioridade)
- [Cálculo crítico (P0)](#cálculo-crítico-p0)
- [Mocks](#mocks)
- [Qualidade](#qualidade)
- [Nomenclatura](#nomenclatura)

## Lanes (quem escreve × quem roda)
- **Quem escreve código NUNCA roda testes.** `feature-builder`/`escrever-teste` **escrevem** sem rodar; **`/test`** (test-generator) **roda** a suíte; o **`corretor`** corrige produção no loop `/test`⇄`/corrigir`.
- `/test` só edita **arquivos de teste**; achado de bug de produção vira **relatório para o `corretor`**, não correção.

## Tipos de teste
- **Unitário** — função/classe isolada.
- **Integração** — módulos interagindo (ex.: rota + service + banco de teste).
- **E2E** — fluxo completo.
- Escolha pela criticidade do alvo; não escreva E2E onde um unitário cobre.

## Estrutura AAA
- **Arrange · Act · Assert** — um assert principal por teste.
- Testes **independentes e determinísticos**: sem `random` sem seed, sem depender de ordem, sem lógica condicional dentro do teste.
- Nome descreve o **comportamento**, não a implementação (`test_login_recusa_senha_invalida`, não `test_login_2`).

## Cobertura por prioridade
- Se o projeto tem plano (ex.: `tests/PLANO-COBERTURA-TESTES.md`, P0–P3), **o plano manda**.
- Sem plano, priorize: **P0** segurança/pagamento/negócio core → **P1** API/validação → **P2** utils → **P3** config.
- Níveis de ambição por módulo: mínimo tolerável ~60–70% · padrão 80%+ · máxima ~90–95%.
- **Piso de P0: 80% de branch** nos alvos de segurança, dinheiro e cálculo crítico. Isso não é ambição, é o mínimo — abaixo disso o review bloqueia (ver [code review](../code-review/guia-code-review.md)).
- **Cobertura de linha é necessária, não suficiente — busque branches.**

## Cálculo crítico (P0)
Vale para qualquer cálculo cujo resultado errado custa dinheiro, decisão ou confiança: valor a pagar, rateio, imposto, juro, score, prazo, cobrança recorrente.
- **Valores-âncora com fonte.** Cada caso de teste carrega o resultado esperado **e de onde ele veio** (contrato, planilha do negócio, resposta da API oficial, norma). Número esperado sem procedência não é teste — é a implementação se auto-confirmando.
- **Nunca float para dinheiro.** Use `Decimal`/inteiro em centavos; em TypeScript, inteiro ou lib de precisão arbitrária. `0.1 + 0.2 != 0.3` também vale para a sua fatura.
- **Arredondamento é explícito e testado** — política declarada (meio para cima, bancário, truncar), casas fixas, e um caso que prove o comportamento na fronteira (`x.5`).
- **Teste os limites, não só o meio:** primeiro e último período, valor zero, valor mínimo e máximo, quantidade 1, quantidade máxima, percentual 0% e 100%, e a soma das partes fechando com o todo (nenhum centavo criado ou perdido no rateio).
- **Reprocessar não pode dobrar.** Aplicar a mesma operação duas vezes com a mesma chave produz o mesmo estado final — ver [idempotência nas integrações](../erros-logging/guia-erros-logging.md).
- Cálculo crítico é sempre **P0**, mesmo que o módulo pareça pequeno.

## Mocks
- Mocke **na fronteira**: I/O, APIs externas, banco. **Nunca** mocke função interna.
- Reuse fixtures/factories do projeto; `parametrize`/`it.each` para variantes; `side_effect`/`mockRejected` para erros.
- Mock reflete o **contrato real** da dependência. Fixtures ≠ **mock server** (server completo é feature via `/build`).

## Qualidade
- **Qualidade acima de quantidade:** 10 testes que cobrem o que importa > 50 superficiais.
- Cubra happy path · edge (None/vazio/zero/negativo/limites/Unicode) · erro (exceção/timeout/conexão recusada/não encontrado) · regressão (o cenário que já falhou) · **idempotência** (o mesmo evento chega duas vezes → mesmo efeito).
- Não teste implementação; teste comportamento.

## Nomenclatura
- **Python:** `test_*.py` (pytest). **TypeScript:** `*.test.ts(x)` — **não** `.spec.ts` neste ecossistema.
- Ver [nomenclatura de arquivos](../nomenclatura/guia-arquivos-e-branches.md).
