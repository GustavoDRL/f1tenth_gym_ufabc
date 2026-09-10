# Guia de Code Review & Pull Request

> Baseline global de PR e revisão. Consumido por `pr-reviewer` (`/review`), `github-manager` (`/pr`) e
> `merge-planner` (`/merge-plan`).

## Sumário
- [Pull Request](#pull-request)
- [As 5 dimensões da revisão](#as-5-dimensões-da-revisão)
- [Severidade e confiança](#severidade-e-confiança)
- [Scoring e veredito](#scoring-e-veredito)
- [Quando planejar o merge](#quando-planejar-o-merge)

## Pull Request
- **Base = `main`** (não há `develop`). Branch `<tipo>/<slug-kebab>`.
- **Título** conventional em PT-BR, ≤70 chars (`feat(auth): adiciona login OAuth2`).
- **Body** reaproveita o **pacote de docs da branch**: (1) o problema · (2) como testar · (3) como reproduzir · (4) o porquê da solução.
- **PR pequena e focada.** PR grande/arriscada (migration, auth, pagamento, muitos bloqueantes) → passa pelo `/merge-plan` antes de corrigir.
- Abre **ready** (labels/reviewers só se pedido). A branch normalmente já está no remote (entregue pelo `/fix`//`/corrigir`).

## As 5 dimensões da revisão
Analisadas **sequencialmente no próprio pr-reviewer** (subagente nativo não faz Task aninhado), lendo cada arquivo **completo** (não só o diff):
1. **Lógica & Bugs** — condicionais invertidas, edge cases, race conditions, async incorreto, off-by-one, erros silenciados.
2. **Segurança** — ver [guia de segurança](../seguranca/guia-seguranca.md) (injection, XSS, auth, secrets). Feature que toca **dado pessoal**: confira base legal, minimização, retenção e direito do titular declarados na spec — não descubra isso no review.
3. **Performance** — N+1, queries sem índice, sync bloqueante, falta de cache/paginação/timeout.
4. **Qualidade** — SOLID/DRY, naming, funções longas, magic numbers, type hints, comentário no "porquê", consistência com os padrões.
5. **Testes** — a suíte **já vem verde** do loop `/test`⇄`/corrigir`; **não se re-executa** — avalia-se a **qualidade/cobertura** (caminhos sem teste, casos críticos ausentes, asserts fracos, mock excessivo). A cobertura é **lida do rastro do `/test`**, nunca medida no review: alvo P0 (segurança, dinheiro, cálculo crítico) abaixo do piso de 80% de branch é **bloqueante**; rastro ausente vira "não verificável", não veto.

## Severidade e confiança
- Severidade por achado: **CRÍTICO · ALTO · MÉDIO · BAIXO** — honesta, sem inflar nem minimizar.
- Confiança: **ALTA · MÉDIA · BAIXA**. Todo achado de confiança **BAIXA é relido no arquivo completo** antes de reportar (caça a falso positivo).
- Evidência sempre com `arquivo:linha`. Problema pré-existente → seção "dívida técnica", não erro da PR.

## Scoring e veredito
- Score ponderado (0–10): **Lógica(3) + Segurança(3) + Performance(2) + Qualidade(1) + Testes(2)**.
- **APPROVE** ≥8 sem críticos · **REQUEST CHANGES** 5–7 · **REJECT** <5.

## Quando planejar o merge
- **REQUEST CHANGES/REJECT em PR grande** → `/merge-plan`: classifica 🔴 bloqueante / 🟡 recomendado / 🔵 opcional, ordem segura e rollback por tarefa → `/build` implementa → volta ao loop `/test`⇄`/corrigir` → re-review.
- PR pequena: corrige direto via `/build` e volta ao loop.
