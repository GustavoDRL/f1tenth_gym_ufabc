---
name: secrets
description: Inventaria e valida a configuração de segredos/env do projeto (.env.example vs .env) sem nunca expor valores. Sinaliza chaves faltando/extra e credenciais de teste vazadas.
argument-hint: "[caminho do .env, default: .env na raiz]"
allowed-tools: Read Write Grep Glob Bash(git *)
model: sonnet
effort: medium
---

Você **inventaria e valida a configuração de segredos** do projeto. Skill direta — **não há subagente dedicado**; roda no nível principal. **REGRA ABSOLUTA: nunca imprima o VALOR de um segredo** — só nomes de chave, presença/ausência e veredicto.

## Processo

### 1. Carregar contexto (somente leitura)
- Leia `CLAUDE.md` (stack, quais integrações usam segredos).
- Localize `.env.example`/`.env.sample` (contrato de chaves) e `.env`/`.env.local` (valores reais, **gitignored**). Se `.env` não estiver no `.gitignore` → **achado crítico**.

### 2. Analisar dimensões (só nomes de chave)
- **Chaves faltando:** presentes no `.env.example` mas ausentes no `.env` → app quebra em runtime.
- **Chaves extra:** presentes no `.env` mas fora do `.env.example` → contrato desatualizado.
- **Credenciais de teste vazadas:** valores de mock/homologação conhecidos que apareçam em config apontando para ambiente real. Compare **fingerprint** (comprimento/prefixo), nunca o valor.
- **Segredo commitado:** `git log -p -- .env` / `git grep` por padrões de chave no histórico tracked (só sinaliza o arquivo:commit, não imprime).

### 3. Apresentar veredicto
```
SEGREDOS — [PROJETO]
━━━━━━━━━━━━━━━━━━━━
.env no .gitignore:   ✅
Chaves faltando:      ❌ <CHAVE_A>, <CHAVE_B>
Chaves extra:         🟡 DEBUG_FLAG
Cred. teste em real:  ✅ nenhuma
Segredo no histórico: 🟢 nenhum

VEREDICTO: NÃO CONFORME — 2 chaves faltando no .env
```

### 4. Gravar rastro
Grave o veredicto em `Reports/$(date +%Y-%m-%d_%H-%M-%S)_secrets_<projeto>_inventario.md` seguindo `Reports/README.md` (só nomes de chave, nunca valores). Se `Reports/` não existir, crie.

## 🚦 GATE HUMANO
- **Nunca exponho valores de segredo** — nem em preview, nem no rastro, nem em log. Só nomes/fingerprints.
- Não altero `.env` nem rotaciono credenciais por conta própria; se o operador pedir, apresento **1–3 opções em múltipla escolha** com risco e **PARO** até confirmação.
- Dúvida/anomalia (ex.: `.env` fora do `.gitignore`) = PARO e sinalizo como crítico.

## 📝 RASTRO .md OBRIGATÓRIO
Grava em `Reports/` (ver passo 4). Uso `Write` **apenas** para o rastro, nunca código-fonte. Se `Reports/` não existir, crio.

## Regras
- **Zero valores** — a skill falha seu propósito se imprimir um segredo.
- Read-only sobre config; só o rastro é escrito.
- Tudo em PT-BR.
