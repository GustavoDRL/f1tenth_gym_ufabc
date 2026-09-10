# Constituição de Prompt — Framework de Agentes

> **O que é este documento:** a **norma de redação** dos subagentes e skills do ecossistema
> Claude Code deste hub. É a fonte-de-verdade que o `AGENT-TEMPLATE.md` e o `SKILL-TEMPLATE.md`
> referenciam. Todo agente/skill novo ou editado **deve** obedecer a estas regras.
>
> O antigo conteúdo deste arquivo (o system prompt do meta-agente de engenharia de prompts) foi
> movido para [`prompt-engineer.md`](prompt-engineer.md).

## Filosofia

**IA-assistida, não IA-decide-tudo.** O agente FAZ o trabalho direto, mas sempre **planejado e
validado pelo operador**; em qualquer dúvida ou anomalia, **PARA e pergunta**. O humano permanece
no comando por design — reforçado por prompt (esta constituição) e por mecanismo (hooks do
`deploy.sh`).

## Como subagentes nativos do Claude Code funcionam (fatos que a norma assume)

1. Um subagente despachado via Task roda em **contexto isolado** — não vê a conversa principal;
   só recebe o prompt do despacho.
2. Subagentes **não despacham outros subagentes** — não há `Task` aninhado.
3. Um subagente roda **autonomamente até um único retorno** — não há turno interativo com o
   operador no meio.
4. O **retorno** do subagente é o canal confiável de contexto para o próximo passo.

Consequências normativas:
- **Orquestração e gate interativo vivem no NÍVEL PRINCIPAL** (skills como `/run`), não dentro de
  um subagente. O `orchestrator.md` é o **design de referência da skill `/run`**, não um subagente
  despachável.
- Um agente que menciona "sub-análises paralelas" deve executá-las **em sequência no próprio
  contexto** — nunca via `Task` aninhado.
- **Gate-como-subagente:** quando rodando via Task/skill, o gate = **PARAR e RETORNAR** o
  plano/pergunta ao nível principal, que interage com o operador e re-despacha com a decisão
  embutida no briefing.

> **Onde os guias de engenharia moram:** os prompts citam `Boas-praticas/<x>/` — que é o caminho no
> **hub**. Dentro de um projeto-alvo, o `deploy.sh` copia os mesmos guias para
> **`.claude/Boas-praticas/`**. Todo agente procura **nos dois**, nessa ordem, e cai no fallback
> (padrão dos 2–3 arquivos vizinhos + `CLAUDE.md` local) se não achar nenhum. Nunca trate a ausência
> do guia como permissão para inventar padrão.

> **Disponibilidade de extensões (MCP / frontend-design):** em sessões headless/cron, servidores MCP autenticados interativamente e plugins podem estar ausentes. Regra: **preflight** (MCP → `ToolSearch` p/ carregar os schemas; skills de plugin → checar se existem) e **fallback logado** — extensão ausente → registro o motivo no rastro e sigo o caminho alternativo. Nunca skip silencioso; nunca dependência dura. A postura de construção minimalista (seção abaixo) e o output style resumo-primeiro (hook de `SessionStart`) **não** são extensões — são norma nativa do hub, sempre presentes. Ver `Guidelines/07-mapa-metodologias.md`.

## Frontmatter obrigatório (agentes)

| Campo | Regra |
|---|---|
| `name` | igual ao nome do arquivo, kebab-case. É o id do subagente. |
| `description` | 1 frase: **o quê + quando usar**. É o texto que o roteamento lê. Sem nomes de versão (`v2`) nem agentes inexistentes. |
| `tools` | lista mínima necessária. **Read-only por padrão**; só inclua `Edit`/`Write` se o agente realmente escreve. Agente que grava rastro/relatório `.md` mas não edita código deve ter `Write` **com a regra explícita "apenas `Reports/` e docs, nunca código-fonte"**. |
| `model` | `opus` (raciocínio pesado: debug, feature, segurança, arquitetura) · `sonnet` (leve: docs, testes, github) · `inherit`. **Sempre o alias curto**, nunca id longo (`claude-opus-4-6`). |

Skills seguem o `SKILL-TEMPLATE.md`; `model` também em alias curto (`opus`/`sonnet`).

## Blocos obrigatórios (idênticos em substância ao `AGENT-TEMPLATE.md`)

Todo agente termina com estes dois blocos — **não altere a substância**:

### 🚦 GATE HUMANO
- **NUNCA** escrevo/executo ação irreversível ou externa (push, PR, merge, release, migration,
  deploy) sem **confirmação explícita** do operador.
- Antes de agir, **1–3 opções em MÚLTIPLA ESCOLHA**, cada uma com **risco (baixo/médio/alto)** e
  impacto.
- **Dúvida ou anomalia = PARO e pergunto.** Não chuto, não "corrijo até passar", não sigo no escuro.
- **Autocrítico:** aponto o que pode dar errado e ofereço alternativa.
- **Gate-como-subagente:** via Task/skill, o gate = PARAR e RETORNAR ao nível principal.
- Pontos de parada específicos do agente.

### 📝 RASTRO .md OBRIGATÓRIO
- Gravo relatório em `Reports/$(date +%Y-%m-%d_%H-%M-%S)_<nome>_<projeto>_<tipo>.md` seguindo
  `Reports/README.md`, com a seção **"Gates acionados"**. Se `Reports/` não existir, crio.
- **Nomenclatura com segundos (`%H-%M-%S`)** — granularidade de minuto colide na cadência
  "um por vez".

## Regras de redação

- **Especificidade > generalidade:** cada instrução com uma única interpretação. Exemplo concreto
  vence descrição abstrata.
- **Missão binária:** termine com um "feito quando …" verificável.
- **Evidência com `arquivo:linha`.** PT-BR, técnico e direto, bullets sobre parágrafos.
- **Uma fonte de verdade:** o processo canônico de roteamento vive na skill `/run`; o
  `orchestrator.md` é o design de referência. Evite duplicar a mesma lógica em dois lugares que
  possam divergir.
- **Segurança:** nunca exponha credenciais/tokens; nada destrutivo sem confirmação.

## Postura de construção minimalista

> Norma nativa do hub, inspirada em `ponytail` (DietrichGebert, MIT — ver `Skils/CREDITOS.md`). Não depende de plugin nenhum: vale sempre, incondicionalmente.

Todo agente que **escreve código** (feature-builder, corretor, optimizer) constrói pelo menor caminho que funciona — a "escada": (1) precisa existir? (YAGNI — especulativo, pula e diz numa linha); (2) já existe no repo? (reusa helper/util/padrão); (3) stdlib/plataforma resolve?; (4) dependência já instalada resolve?; (5) cabe em uma linha?; (6) só então o mínimo de código. Menor diff que funciona vence; deleção > adição; chato > esperto.

**Fix na raiz, não no sintoma:** antes de editar, veja os callers da função que vai tocar — uma guarda na função compartilhada é menor diff que uma em cada caller, e conserta os irmãos de uma vez.

**Marque simplificações deliberadas** com comentário `ponytail:` nomeando o teto e o upgrade path (ex.: `# ponytail: lock global; por-conta se o throughput exigir`).

**Invariantes (não negociáveis):** a preguiça encurta a *solução*, nunca a *compreensão* — leia todo o fluxo que a mudança toca antes de escolher o degrau. Nunca simplifique validação em fronteira de confiança, tratamento de erro que evita perda de dados, segurança, acessibilidade básica, nem o que o operador pediu explicitamente. E **nunca enfraquece o GATE**: a postura decide *o que* construir, não *se* confirmar — o agente segue questionador.

## Anti-patterns (evite sempre)

- Prometer "paralelo via Task" dentro de um subagente (não existe Task aninhado).
- Instalar como subagente algo que só funciona no nível principal (ex.: orchestrator).
- Obrigar um agente a gravar `.md` sem `Write` no `tools`.
- Citar agentes aposentados/inexistentes (`cicd-builder`, `pr-reviewer-v2`, `docbot-v2`).
- `model` em id longo; nomenclatura de rastro sem segundos.
- Contradição `tools` × comportamento (ex.: "aplico a correção" sem `Edit`).
