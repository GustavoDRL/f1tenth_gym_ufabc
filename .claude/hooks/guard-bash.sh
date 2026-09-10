#!/usr/bin/env bash
# Guarda de comandos Bash — defense-in-depth. Fail-closed.
# NB: hooks são uma camada extra, NÃO uma barreira forte contra um agente que
# controla a string do comando. O gate autoritativo é a aprovação nativa do Claude Code.
# ponytail: cobertura de alto valor. Dívida conhecida (deferida): rm em /etc,/usr,/var;
#   dd of=; shred; find -delete; chmod 0777; doas/pkexec; rejeição de base64 -d/eval/$()/<().
set -uo pipefail
INPUT=$(cat)
command -v jq >/dev/null 2>&1 || { echo "BLOQUEADO: jq ausente — hook de seguranca nao pode validar." >&2; exit 2; }
CMD=$(jq -r '.tool_input.command // empty' <<<"$INPUT" 2>/dev/null) || { echo "BLOQUEADO: input invalido." >&2; exit 2; }
[ -z "$CMD" ] && exit 0
# Normaliza: remove aspas/barras (quoting g\it, "git") E colapsa \n/tab/espacos em espaco
# unico. A remocao do '\' + colapso de newline junta os tokens de comandos multilinha ou
# com continuacao de linha (git \<newline>push, curl ...|<newline>bash), fechando o bypass
# de quebra de linha contra os regexes de adjacencia abaixo.
CMDN=$(printf '%s' "$CMD" | tr -d '"'"'"'\\' | tr '\n\t' '  ' | tr -s ' ')

# 1) rm recursivo/forcado em caminho perigoso (/, ~, $HOME, /*, ., ..)
if printf '%s' "$CMDN" | grep -qiE 'rm[[:space:]].*(-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r|-r[[:space:]]+-f|-f[[:space:]]+-r|--recursive|--force)' \
   && printf '%s' "$CMDN" | grep -qiE '(^|[[:space:]])(/|~|\$HOME|/\*|\.|\.\.)([[:space:]]|/\*|$)'; then
  echo "BLOQUEADO: rm recursivo/forcado em caminho perigoso: $CMD" >&2; exit 2
fi
if printf '%s' "$CMDN" | grep -qiE 'no-preserve-root|mkfs|dd[[:space:]]+if=|:\(\)[[:space:]]*\{'; then
  echo "BLOQUEADO: comando destrutivo de sistema: $CMD" >&2; exit 2
fi
# 2) Pipe-to-shell (RCE / supply-chain)
if printf '%s' "$CMDN" | grep -qiE '(curl|wget|fetch)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(bash|sh|zsh|python|perl|ruby)'; then
  echo "BLOQUEADO: download direto para shell (curl|bash): $CMD" >&2; exit 2
fi
# 3) sudo / permissoes amplas
if printf '%s' "$CMDN" | grep -qiE '(^|[[:space:]])sudo([[:space:]]|$)|chmod[[:space:]]+(-[a-zR]+[[:space:]]+)?777'; then
  echo "BLOQUEADO: sudo ou chmod 777: $CMD" >&2; exit 2
fi
# 4) Banco destrutivo
# Escape restrito: ensaiar a reversao de uma migration (up -> down -> up) e' passo OBRIGATORIO
# do /migrate e do /deploy-check. Sem escape, a norma manda fazer o que o hook proibe.
# CLAUDE_CONFIRM_DB=1 e' definido pelo operador no ambiente (fora do alcance do agente).
#
# NUNCA use 'exit 0' aqui: o escape libera APENAS este bloco e o script SEGUE para os
# blocos 4b..7. Um 'exit 0' no meio da cadeia transformaria o escape num coringa que desliga
# DROP/TRUNCATE/DELETE, escrita em .env, anti-secret e o gate de push.
# O comando tambem precisa COMECAR com a reversao (inicio da linha ou apos ; && || |) e nao pode
# carregar encadeamento/substituicao/redirecionamento — senao 'alembic downgrade -1; <qualquer coisa>'
# passaria pela porta aberta para outro comando.
if printf '%s' "$CMDN" | grep -qiE '(^|[;&|][[:space:]]*)(alembic[[:space:]]+downgrade|prisma[[:space:]]+migrate[[:space:]]+reset|[a-z_.-]*migrate[[:space:]]+[^;&|]*--fake)'; then
  if [ "${CLAUDE_CONFIRM_DB:-}" = "1" ] \
     && ! printf '%s' "$CMDN" | grep -qE '[;&|`]|\$\(|>|<'; then
    :   # autorizado: segue para os demais blocos, sem pular verificacao nenhuma
  else
    echo "GATE: reversao de migration detectada ($CMD)." >&2
    echo "      Ensaie em banco de TESTE, num comando UNICO (sem ; && | \$() nem redirecionamento)," >&2
    echo "      e autorize com CLAUDE_CONFIRM_DB=1 no ambiente do Claude Code." >&2
    exit 2
  fi
fi
if printf '%s' "$CMDN" | grep -qiE 'drop[[:space:]]+(table|database|schema)|truncate([[:space:]]+table)?[[:space:]]+[a-z_.]+|delete[[:space:]]+from[[:space:]]+[a-z_.]+'; then
  echo "BLOQUEADO: operacao de banco destrutiva ($CMD). Exige confirmacao explicita do operador." >&2; exit 2
fi
# 5) Escrita/redirecionamento para arquivo sensivel ou guarda-corpo
if printf '%s' "$CMDN" | grep -qiE '>>?[[:space:]]*[^|;&]*(\.env|credential|secret|id_rsa|\.pem|\.key)' \
   || printf '%s' "$CMDN" | grep -qiE '\.git/(hooks|config)|\.claude/(settings|hooks)'; then
  echo "BLOQUEADO: escrita em arquivo sensivel (.env/segredo/.git/hooks/.claude): $CMD" >&2; exit 2
fi
# 6) Anti-secret em commit: escaneia o CONTEUDO (nao a string do comando).
#    Casa 'git commit' mesmo com 'git -C <path> commit'. Com -a/-am o commit estagia arquivos
#    tracked no ato, entao escaneia o working tree tracked (git diff HEAD); senao so o staged.
SECRET_RX='AKIA[0-9A-Z]{16}|ghp_[0-9A-Za-z]{36}|sk-[0-9A-Za-z]{20,}|xox[baprs]-[0-9A-Za-z-]+|-----BEGIN[[:space:]]+(RSA|EC|OPENSSH|PRIVATE)|ia-[a-z0-9]{20,}|eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}|[A-Z][A-Z0-9_]{2,}_(API_?KEY|TOKEN|SECRET|SENHA|PASSWORD)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9_/+-]{12,}'
if printf '%s' "$CMDN" | grep -qiE 'git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?commit'; then
  if printf '%s' "$CMDN" | grep -qiE 'commit[[:space:]]+-[a-z]*a'; then
    DIFF=$(git diff HEAD 2>/dev/null)
  else
    DIFF=$(git diff --cached 2>/dev/null)
  fi
  if printf '%s' "$DIFF" | grep -qE "$SECRET_RX"; then
    echo "BLOQUEADO: conteudo do commit parece conter secret/chave (AWS/GitHub/OpenAI/Slack/JWT/env var de segredo/chave privada). Remova antes de commitar." >&2; exit 2
  fi
fi
# 7) Gate de acao remota/irreversivel (push/PR/merge/release). Todo 'git push' e' gateado,
#    entao force-push (por -f/--force ou refspec +) ja' esta' coberto por 'git push'.
if printf '%s' "$CMDN" | grep -qiE 'git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?push|gh[[:space:]]+pr[[:space:]]+(create|merge)|gh[[:space:]]+release|git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?merge([[:space:]]|$)'; then
  if [ "${CLAUDE_CONFIRM_REMOTE:-}" = "1" ]; then
    exit 0
  fi
  echo "GATE: acao remota/irreversivel detectada ($CMD)." >&2
  echo "      O operador deve autorizar definindo CLAUDE_CONFIRM_REMOTE=1 no ambiente do Claude Code" >&2
  echo "      (fora do alcance do agente). O gate autoritativo e a aprovacao nativa do Claude Code." >&2
  exit 2
fi
exit 0
