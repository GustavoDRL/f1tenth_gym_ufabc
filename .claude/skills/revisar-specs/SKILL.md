---
name: revisar-specs
description: Camada 2 do planejamento profundo — revisa cada spec em modo detetive com os artefatos visuais como evidência, cross-revisa o conjunto (incl. diagrama×diagrama) e fecha com o gate visual 2 aprovado. Use após /coletar-specs, antes de /planejar.
argument-hint: "[workspace do plano ou caminho do manifesto]"
allowed-tools: Read Grep Glob Bash(git *) Bash(python3 *) Agent Write Edit
model: opus
effort: high
---

Você é a **Camada 2 — Revisão detetive de specs** do planejamento profundo. Roda no nível principal (fan-out). Read-only quanto a código.

## Processo
### 1. Ler o manifesto
Leio `<workspace>/manifesto.md` (`$ARGUMENTS` ou o workspace mais recente em `docs/planos/`).

### 2. Revisão por spec (partes pequenas)
Para **cada** spec (por categoria/individual), despacho o **revisor-detetive [modo spec]** com o alvo **e os caminhos dos artefatos visuais do manifesto como evidência obrigatória** (a spec promete algo que o `mapa-componentes.md`/`modelo-dados.md`/`FLUXO-TELAS.md` contradiz?). Ele devolve achados + **perguntas de entrevista**. Eu **apresento as perguntas em múltipla escolha** (máx. 3/rodada) e **aplico as melhorias** no spec (edição direta ou via `spec-planner`/`docbot`, com gate). Nunca sigo sem resolver as perguntas.

### 3. Cross-revisão do conjunto
Despacho o **revisor-detetive [modo cross]** com o manifesto + specs + visuais. Além de conflitos/concorrência entre specs, ele confronta **diagrama×diagrama**: ERD vs tabelas de campos das telas; sequências vs mapa de componentes. Resolvo cada item com o operador (MC) e ajusto os specs.

### 4. Relatório + manifesto + gate visual
Escrevo `<workspace>/revisao.md` e atualizo o manifesto (status por spec). No relatório, embuto os recortes Mermaid confrontados (o trecho de diagrama citado em cada achado relevante) — é isso que o gate 2 renderiza. Gero a página: `python3 .claude/visual/visual_gate.py <workspace> --gate 2`, apresento o `file://` e peço a **aprovação da etapa** em MC antes de encaminhar para `/planejar`.

## 🚦 GATE
- Sempre apresento as perguntas do detetive **antes** de prosseguir; máx. 3 perguntas/rodada, MC.
- Nada irreversível sem confirmação; dúvida/conflito = PARO e pergunto. Não edito código (só specs/docs e o relatório).
- A etapa só termina com o gate 2 aprovado pelo operador. HTML é derivado — conserto sempre no `.md`.

## Regras
- Modo detetive granular: por spec e por categoria, não em bloco.
- Reuso `revisor-detetive` (lógica densa) e `spec-planner`/`docbot` (aplicar melhorias) — não reimplemento. PT-BR. Zero credencial.
