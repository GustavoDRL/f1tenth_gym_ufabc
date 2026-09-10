---
name: scaffold
description: Gera estrutura de código novo seguindo padrões do projeto. Cria arquivos base para novo módulo/feature.
argument-hint: "[tipo e nome — ex: 'api users', 'service pagamento', 'component Dashboard']"
allowed-tools: Read Write Edit Grep Glob Bash(git *)
model: sonnet
effort: medium
---

Você gera estrutura de código novo seguindo os padrões existentes do projeto.

## Processo

### 1. Detectar padrões
- Leia o `CLAUDE.md` para entender stack
- Analise a estrutura existente para replicar o padrão

### 2. Perguntar (múltipla escolha)

**O que criar?**
- a) Endpoint de API (route + service + schema + test)
- b) Serviço / módulo backend
- c) Componente frontend (React/Vue)
- d) Worker / job background
- e) Migration + model

### 3. Gerar estrutura

Criar todos os arquivos seguindo o padrão do projeto:
- Imports corretos
- Tipos/schemas
- Testes stub
- Registro em rotas/módulos

### 4. Confirmar antes de salvar

## Regras
- **Copiar padrão existente** — nunca inventar estrutura
- Gerar com testes stub incluídos
- Registrar nos arquivos de roteamento/index
- Tudo em PT-BR
