---
name: mock
description: Gera mocks, fixtures e dados de teste realistas para APIs externas e serviços.
argument-hint: "[módulo ou serviço a mockar — ex: 'gateway de pagamento', 'provedor de e-mail']"
allowed-tools: Read Bash(git *) Agent
model: sonnet
effort: medium
---

Despache para o subagente **test-generator** no **modo `mock`** com o alvo `$ARGUMENTS`.

Contexto fino (não duplica o system prompt do subagente):
- Modo `mock` = gera **fixtures/mocks de teste** (fixtures pytest, `unittest.mock`/`jest.mock`, factories, JSON estático) para as dependências externas que o projeto consome, refletindo o contrato real da dependência.
- **Fronteira de escopo:** um **mock server completo** de uma API externa (com rotas/auth/estado) é artefato construído via **`/build`** — **não** é saída desta skill. Aqui, só as fixtures.
- RASTRO .md conforme o subagente.
