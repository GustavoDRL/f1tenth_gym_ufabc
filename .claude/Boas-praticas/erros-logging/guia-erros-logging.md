# Guia de Erros & Logging

> Baseline global de tratamento de erros e logging. Sobrescrevível pelo `development/coding-standards.md`
> do projeto. Consumido por `feature-builder`, `corretor` e avaliado no `/review`.

## Sumário
- [Logging](#logging)
- [O que registrar](#o-que-registrar)
- [Tratamento de erros](#tratamento-de-erros)
- [Integrações externas](#integrações-externas)

## Logging
- **Proibido `print()` / `console.log` em produção.** Use o logger estruturado da stack.
- **Log estruturado**, não interpolação de string: `logger.info("pedido criado", extra={"id": id})` — não `logger.info(f"pedido {id} criado")`.
- Níveis: **debug** (diagnóstico) · **info** (evento de negócio) · **warning** (anômalo recuperável) · **error** (falha) · **critical** (indisponibilidade). Escolha o nível certo; não logue tudo como info.

## O que registrar
- Contexto que ajuda a diagnosticar: id da entidade, rota, etapa, duração.
- **Nunca** senha/token/credencial/PII (ver [segurança](../seguranca/guia-seguranca.md)).
- Não polua: log demais é tão inútil quanto log de menos.

## Tratamento de erros
- Capture **exceção específica**, não `except:`/`catch(e)` genérico que engole tudo.
- **Não silencie erro** (sem `except: pass`). Se não trata, propaga.
- Erros por camada: valide input na borda; traduza erro de infra em erro de domínio quando fizer sentido.
- Mensagem de erro é clara e acionável; nunca vaza stack trace com dado sensível ao usuário final.

## Integrações externas
- Toda chamada externa tem **timeout**; falha transitória tem **retry** com limite; defina **fallback** ou erro de domínio explícito.
- Status 0/timeout de rede é falso-negativo conhecido: a chamada **pode ter chegado** do outro lado. Reenviar só se a operação for idempotente ou carregar chave de idempotência; caso contrário, **consulte o estado** antes de repetir.
- **Retry exige idempotência.** Operação não-idempotente (criar, cobrar, enviar, baixar) só é reenviada com **chave de idempotência**: o chamador gera, o servidor deduplica, mesma chave = mesmo resultado. Sem isso, retry vira duplicata silenciosa.
- **O que você recebe também repete.** Webhook e evento de fila chegam mais de uma vez por design — processe pela chave do evento e trate reentrega como caso normal, não como erro.
