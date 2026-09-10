# Guia de Deploy & Release

> Baseline global de entrega. Consumido por `/deploy-check`, `/release`, `/runbook`.

## Sumário
- [Deploy é manual/local](#deploy-é-manuallocal)
- [Deploy-check (gate)](#deploy-check-gate)
- [Release e versionamento](#release-e-versionamento)
- [Runbook](#runbook)
- [Monitoramento em produção](#monitoramento-em-produção)

## Deploy é manual/local
- **Sem CI/CD configurado** nestes projetos — o deploy é **manual/local**. Nenhum agente assume pipeline; `/deploy-check` **não checa CI**.
- Base do fluxo = **`main`**.

## Deploy-check (gate)
- Roda na branch de integração (default `main`) e emite veredito **PRONTO / NÃO PRONTO**.
- Verifica: **lint/build** verdes · **migrations** aplicáveis · **dependências** auditadas · sobe a app localmente e **valida** que responde.
- **Compara `deploy.sh` produção × local** — diff relevante **bloqueia** (o ambiente tem que bater).
- O passo a passo manual do deploy é do `/runbook`.

## Release e versionamento
- **SemVer:** `feat` → minor (x.Y.0) · `fix` → patch (x.y.Z) · `BREAKING CHANGE`/`!` → major (X.0.0).
- **Changelog** é gerado pelo `/changelog` (fonte única do agrupamento por tipo) e reaproveitado como corpo da release — não reimplemente.
- Tag + release são **ações externas com gate**: confirmação explícita antes de `git tag`/`gh release create`.

## Runbook
- Documenta o procedimento operacional manual (subir/derrubar serviço, variáveis, rollback local, verificação pós-deploy).
- Serve de referência na hora do deploy e do incidente (ver [incidente](../incidente/guia-incidente.md)).
- **Restore de banco tem runbook próprio e ensaiado:** [runbook-restore.md](./runbook-restore.md).
- **Rollback é procedimento escrito e ensaiado**, não improviso: os comandos exatos para voltar a versão anterior, incluindo o `down` da migration quando houver, e o critério objetivo de "reverter agora" (ver [expand e contract](../banco-migrations/guia-banco-migrations.md)).

## Monitoramento em produção
Sem isto, o primeiro a saber que quebrou é o usuário — e o postmortem começa tarde demais.
- **Todo serviço no ar tem error tracking**, com exceção não tratada chegando a uma pessoa. Serviço novo sem isso não está pronto para deploy.
- **Alguém recebe o alerta.** Alerta que cai em canal que ninguém lê é o mesmo que alerta nenhum; defina o destino antes de subir.
- **Verificação pós-deploy** — depois de subir, exercite os caminhos que importam (a rota principal, o login, a operação que move valor) e confira o erro nos primeiros minutos. Se piorou, reverta: essa é a hora barata.
- **Sinais mínimos**, mesmo sem stack de observabilidade: taxa de erro, latência do caminho crítico, fila crescendo e job que parou de rodar.
- Log estruturado é a base disso — ver [erros & logging](../erros-logging/guia-erros-logging.md).
