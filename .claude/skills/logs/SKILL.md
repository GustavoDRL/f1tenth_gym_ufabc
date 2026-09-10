---
name: logs
description: Analisa logs e erros do projeto (arquivos de log, docker logs, saída de CI) e resume padrões de erro por frequência e severidade. Read-only.
argument-hint: "[caminho do log, 'docker', 'ci' ou 'all']"
allowed-tools: Read Write Grep Glob Bash(git *) Bash(gh *) Bash(docker *)
model: sonnet
effort: medium
---

Você **analisa logs e erros** do projeto e resume os padrões. Skill direta de observabilidade — **não há subagente dedicado**; roda no nível principal. É a skill que cumpre a rota "observabilidade" do `/run`.

## Processo

### 1. Localizar as fontes (somente leitura)
- Leia `CLAUDE.md` (onde ficam os logs, qual runtime).
- Fontes possíveis conforme `$ARGUMENTS`:
  - **Arquivo:** caminho passado, ou `*.log` / `logs/` do projeto.
  - **`docker`:** `docker compose logs --tail 500` (ou `docker logs <container>`).
  - **`ci`:** `gh run list --limit 10` + `gh run view <id> --log-failed`.
  - **`all`:** varre as disponíveis.

### 2. Agregar padrões de erro
- Agrupe linhas por **assinatura de erro** (mensagem normalizada, sem timestamps/IDs).
- Conte frequência; classifique severidade (ERROR/CRITICAL/WARN) e recorrência.
- Correlacione com `git log` recente se um erro começou após um commit (janela temporal).

### 3. Apresentar resumo
```
LOGS — [PROJETO] (fonte: ci)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔴 12×  TimeoutError: comissao?tipo=atuais (30s)   [novo desde a3f9c1]
🟡  4×  DeprecationWarning: pydantic v1 validator
🟢  ruído: 240 linhas INFO ignoradas

TOP OFENSOR: timeout no endpoint de comissão v3 → /debug
```

### 4. Gravar rastro
Grave o resumo em `Reports/$(date +%Y-%m-%d_%H-%M-%S)_logs_<projeto>_analise.md` seguindo `Reports/README.md`. Se `Reports/` não existir, crie.

## 🚦 GATE HUMANO
- **Read-only** — não altero código nem reinicio serviços; só leio logs e resumo.
- **Nunca exponho segredos** que apareçam em logs (mascaro tokens/chaves no resumo e no rastro).
- Se a fonte de log for ambígua ou inacessível, **PARO** e pergunto qual usar (múltipla escolha).

## 📝 RASTRO .md OBRIGATÓRIO
Grava em `Reports/` (ver passo 4). Uso `Write` **apenas** para o rastro, nunca código-fonte. Se `Reports/` não existir, crio.

## Regras
- Sinal sobre ruído: destaque o top-ofensor, não despeje o log inteiro.
- Sugira o próximo passo (ex.: `/debug` para o erro mais frequente).
- Tudo em PT-BR.
