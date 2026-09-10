# Guia de Arquitetura

> Baseline global de decisões estruturais. Sobrescrevível pelo `development/coding-standards.md` e pelos
> ADRs (`decisions/`) do projeto.

## Sumário
- [Princípios](#princípios)
- [Camadas](#camadas)
- [Integração externa](#integração-externa)
- [Decisões arquiteturais (ADR)](#decisões-arquiteturais-adr)
- [Separações invioláveis](#separações-invioláveis)
- [Versionamento de API](#versionamento-de-api)

## Princípios
- **Reuso e mudança mínima antes de introduzir estrutura nova.** Não crie camada/abstração sem necessidade concreta (YAGNI).
- Respeite o padrão arquitetural **já existente** no projeto — não misture responsabilidades.

## Camadas
- Onde o projeto adota camadas, siga a existente. Padrão comum de backend: **`rota → handler → service → repository → banco`**.
- Front: `store/context → props → render`; efeitos isolados; chamadas de API tratadas na borda.
- A lógica de negócio não vive na rota nem no componente de UI.

## Integração externa
Toda chamada que sai do processo é uma fronteira de falha. Decida isto **no design, antes de codar** — depois de pronto, vira incidente.
- **Timeout obrigatório**, sempre explícito. Cliente HTTP sem timeout é o bug que só aparece quando o outro lado trava.
- **Retry só em operação idempotente** — o detalhe operacional (backoff, reenvio seguro, evento repetido) fica em [erros & logging](../erros-logging/guia-erros-logging.md).
- **Chave de idempotência em toda escrita que move valor** — pagamento, emissão, envio, baixa. O chamador gera a chave, o servidor a guarda: mesma chave = mesmo resultado, sem efeito novo. Vale nos dois sentidos — o webhook que você **recebe** também chega duas vezes.
- **Fallback declarado ou erro de domínio explícito.** Nunca "seguir em frente" com resposta parcial silenciosa.
- Contrato da dependência é **verificado**, não presumido: fixture criada a partir de resposta real, com fonte e data (ver [testes](../testes/guia-testes.md)).

## Decisões arquiteturais (ADR)
- **Consulte os ADRs e o `architecture/` do projeto** antes de qualquer decisão estrutural.
- Decisão arquitetural nova vira um **ADR** (`/adr`): Contexto · Decisão · Consequências · Alternativas.
- Antes de propor um padrão novo, leia os ADRs já registrados em `decisions/` do projeto — o padrão vigente vence a preferência pessoal.

## Separações invioláveis
- Separações declaradas pelo projeto **não podem ser violadas**. Exemplo: uma camada síncrona de automação **nunca** importa da camada async de serviço — a fronteira existe para não misturar modelos de execução.
- Fronteiras de módulo/domínio existem por um motivo — se precisar cruzá-las, é sinal de que a modelagem mudou: registre um ADR, não crie um atalho.

## Versionamento de API
Contrato publicado é promessa: alguém já depende dele — outro serviço, um app que você não atualiza, um script de terceiro.
- **Aditivo é seguro e não precisa de ADR:** campo novo opcional, endpoint novo, valor novo em enum que o cliente ignora.
- **Breaking change exige decisão registrada** (ADR) com a estratégia de convivência e a data de remoção.
- **Breaking change** é remover/renomear campo, tornar opcional obrigatório, mudar tipo ou semântica, ou apertar validação. Nesses casos: rota versionada nova (ou campo novo convivendo com o antigo), período de convivência e **data de remoção anunciada**.
- **Depreciar antes de remover** — o campo antigo continua respondendo, marcado como deprecated na doc, até a data combinada.
- Quebra inevitável sem aviso (falha de segurança, dado errado em produção) é **incidente**, não release: siga o [guia de incidente](../incidente/guia-incidente.md).
