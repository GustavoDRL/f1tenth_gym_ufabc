# Guia de Incidente & Postmortem

> Baseline global de resposta a incidente. Consumido por `/postmortem` (obrigatório em todo incidente) e
> pelo fluxo de incidente (Fluxo 6).

## Sumário
- [Fluxo do incidente](#fluxo-do-incidente)
- [Severidade](#severidade)
- [Incidente de segurança](#incidente-de-segurança)
- [Postmortem obrigatório](#postmortem-obrigatório)
- [Blameless](#blameless)

## Fluxo do incidente
- **Mesmo rigor do fluxo normal** (Bug → Fix → Deploy) — nada é pulado pela urgência.
- Como **não há `develop`**, branch e PR já saem de/vão para `main` como no fluxo normal; a diferença é a **urgência** (branch `fix/<slug>`, rótulo `hotfix/` opcional) e o **`/postmortem` obrigatório** ao final.
- Sequência: `/debug` (causa raiz) → `/fix` (escreve, não roda) → `/test`⇄`/corrigir` (loop) → `/pr` → `/review` → `/deploy-check` → **`/postmortem`**.

## Severidade
- **SEV1** — sistema fora do ar, impacto total.
- **SEV2** — funcionalidade crítica degradada.
- **SEV3** — funcionalidade secundária afetada.
- **SEV4** — impacto mínimo, preventivo.

## Incidente de segurança
Vazamento de dado, credencial exposta ou acesso indevido é **SEV1 por definição**, mesmo com o sistema no ar e ninguém reclamando — a severidade aqui não mede indisponibilidade, mede exposição.
- **Preservar evidência antes de consertar.** Logs, snapshot do estado, histórico de acesso — copiados para fora do alcance da correção. Quem conserta primeiro apaga a trilha de como aconteceu.
- **Rotacionar credencial na hora**, sem esperar a investigação terminar: chave exposta em commit está comprometida a partir do `git push`, mesmo que o commit tenha sido removido depois. Invalide a antiga; não confie em "o repositório é privado".
- **Determinar o alcance:** qual dado, de quantas pessoas, por quanto tempo, acessado por quem.
- **O relógio da notificação começa na descoberta.** Vazamento de dado pessoal com risco relevante aos titulares exige comunicação à ANPD e aos afetados — a Resolução CD/ANPD 15/2024 fixa **3 dias úteis** contados do conhecimento do incidente. A decisão de notificar é do **controlador** (em projeto solo, o próprio operador — não há para quem delegar); o dever do agente é **apresentar o fato e o alcance imediatamente**, com o prazo nomeado, e nunca decidir sozinho que "não precisa notificar".
- Postmortem continua obrigatório, com uma seção a mais: **o que permitiu a exposição** (não só o que a causou).

## Postmortem obrigatório
Em **todo** incidente de produção (SEV1–4). Estrutura:
- **Resumo executivo** · **Timeline** (detecção → investigação → causa raiz → fix → restauração).
- **Causa raiz** (técnica, com evidência) · **Impacto** (usuários/funcionalidades/dados).
- **Resolução** · **Ações preventivas** (cada uma com **dono e prazo**) · **Lições aprendidas**.
- Salvo em `docs/postmortems/<data>-<slug>.md` + rastro em `Reports/`.

## Blameless
- Foco em **processo, não em pessoas.** O objetivo é impedir a recorrência, não achar culpado.
- Baseado em evidência real (git log, commits, logs), nunca em suposição.
