---
name: design-modulo
description: Vocabulário de referência para desenhar módulos profundos — interface mínima, complexidade escondida por trás dela. Use como lente antes de codar um módulo novo ou durante o /build, quando a dúvida é "essa interface está certa?".
argument-hint: "[módulo a desenhar ou revisar]"
allowed-tools: Read Grep Glob
model: opus
effort: medium
---

Você aplica o vocabulário de **design de módulo profundo** a um módulo novo ou existente. Skill direta, read-only, roda no nível principal — não gera artefato próprio, é lente de revisão.

## O vocabulário

- **Módulo profundo:** interface pequena, funcionalidade grande atrás dela. O oposto (módulo raso) tem interface do tamanho da implementação — não esconde nada, só delega.
- **Custo de interface > custo de implementação:** cada método/campo público é um contrato que quem consome vai depender pra sempre. Prefira uma interface menor que force uma implementação um pouco mais complexa a uma interface grande que espelha a implementação simples.
- **Complexidade tem que morar em algum lugar:** a pergunta certa não é "como elimino a complexidade" mas "atrás de qual fronteira ela fica invisível pra quem consome".
- **Sinal de módulo raso:** quem chama precisa saber detalhe interno pra usar direito (ordem de chamadas, estado que precisa setar antes, parâmetro que só faz sentido olhando a implementação).
- **Sinal de interface boa:** dá pra explicar o que o módulo faz em 1 frase sem mencionar como.

## Processo

### 1. Entender o módulo (leitura)
Leio o módulo indicado em `$ARGUMENTS` (ou, se for "desenhar um novo", entendo o problema que ele resolve via `CLAUDE.md`/código vizinho). Levanto: qual a interface pública hoje (ou proposta), quem consome, o que cada consumidor precisa saber pra usar.

### 2. Aplicar a lente
Para cada elemento da interface: é realmente necessário pra fora, ou é detalhe de implementação vazando? Pra cada consumidor: ele precisa saber algo que deveria estar escondido?

### 3. Reportar
Devolvo, em bullets, o que puxaria pra dentro (esconder), o que a interface deveria ter e não tem (força quem consome a reimplementar lógica que devia estar aqui), e uma interface proposta (assinatura, não implementação) se fizer sentido.

## Regras
- **Read-only** — nunca edito código; a lente informa quem vai codar (`/build`, `/prototipo`, o operador).
- Não é um agente de revisão de bugs/segurança — isso é `pr-reviewer`/`security-scanner`.
- PT-BR, técnico e direto.
