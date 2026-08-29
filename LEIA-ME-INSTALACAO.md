# Instalação do zero — Nexalytix (versão de testes / "produção" inicial)

Este pacote já está limpo de qualquer menção a Jolô, Nexor ou Joia — inclusive
identificadores internos (chaves de `localStorage`, nome de tabela, URLs de
infraestrutura antiga). Ver o changelog no fim deste arquivo.

## O schema do banco já está pronto — reconstruído do zero

Como vocês não têm mais acesso ao projeto Supabase antigo, reconstruí o
schema inteiro (`supabase/esquema/schema.sql` e `policies.sql`) por
engenharia reversa da lógica de sincronização que já existe dentro do
`index.html` — não é chute: são os campos reais que o próprio sistema já
lê e grava. Testei do zero num PostgreSQL local antes de entregar: criei
as 60 tabelas, apliquei as políticas de RLS, simulei uma venda completa e
simulei duas empresas fictícias tentando ler/alterar/apagar dado uma da
outra pela API — as três tentativas de invasão retornaram zero linhas.
Detalhes completos, o que ficou de fora e por quê, em
`supabase/esquema/LEIA-ME-SCHEMA.md`.

Isso significa que o Passo 2 abaixo não depende mais do banco antigo:
é só rodar os dois arquivos prontos, na ordem.

---

## Passo 1 — Criar o projeto Supabase novo (do zero, separado do antigo)

1. Acesse [supabase.com](https://supabase.com) → **New project**.
2. Nome sugerido: `nexalytix-producao` (ou o nome que preferirem).
3. Escolha uma senha forte de banco e guarde num gerenciador de senhas
   (1Password, Bitwarden) — nunca em arquivo de texto solto.
4. Região: a mais próxima dos seus usuários (ex.: `sa-east-1` para Brasil).
5. Espere o projeto provisionar (leva ~2 minutos).

## Passo 2 — Rodar o schema

1. No projeto novo, abra **SQL Editor**.
2. Cole o conteúdo de `supabase/esquema/schema.sql` e rode.
3. Cole o conteúdo de `supabase/esquema/policies.sql` e rode (precisa ser
   depois do schema — as políticas referenciam as tabelas).
4. Confirme em **Table Editor** que as 60 tabelas apareceram, todas com o
   cadeado de RLS fechado.

## Passo 3 — Pegar a URL e a chave do projeto

1. **Project Settings → API**.
2. Copie a **Project URL** (ex.: `https://abcxyz123.supabase.co`).
3. Copie a chave **anon / publishable** (nunca a `service_role`).

## Passo 4 — Configurar o `index.html`

Abra `index.html`, procure por `var NUVEM=` (perto do topo do bloco de
JavaScript) e preencha:

```js
var NUVEM={
  url:'https://SEU-PROJETO-NOVO.supabase.co',
  chave:'sua-chave-anon-aqui',
  ...
};
```

## Passo 5 — Publicar a Edge Function

A função `supabase/functions/criar-usuario/index.ts` cria contas no Supabase
Auth sem expor a chave de administração no navegador.

```bash
supabase login
supabase link --project-ref SEU-PROJETO-NOVO
supabase functions deploy criar-usuario
```

### 5.1 — Ajustar o CORS da Edge Function

Antes ou logo depois do deploy, edite
`supabase/functions/criar-usuario/index.ts` e troque a primeira linha de
`ORIGENS` pelo endereço real onde o Nexalytix vai ficar publicado (você só
vai saber o endereço definitivo depois do Passo 7 — pode voltar aqui e
rodar `supabase functions deploy criar-usuario` de novo depois). Sem isso,
o navegador bloqueia a criação de usuário por CORS.

## Passo 6 — Subir para um repositório GitHub novo (separado do antigo)

Importante: **não** reutilize a conta/repositório antigo — este pacote já
teve os links para `rafaeluendes-jpg.github.io/...` neutralizados de
propósito, porque aquilo era infraestrutura de outra pessoa.

```bash
cd nexalytix   # a pasta deste pacote
git init
git add .
git commit -m "Instalação inicial - Nexalytix"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git
git push -u origin main
```

## Passo 7 — Ativar o GitHub Pages

1. No repositório, **Settings → Pages**.
2. Em **Source**, escolha **GitHub Actions** (o workflow
   `.github/workflows/pages.yml` já vem pronto no pacote).
3. Dê um push na branch `main` (ou rode manualmente em **Actions →
   Publicar Nexalytix → Run workflow**).
4. Em ~1 minuto o site fica disponível em
   `https://SEU-USUARIO.github.io/SEU-REPOSITORIO/`.
5. **Domínio próprio (opcional):** crie um arquivo `CNAME` na raiz do
   repositório com o domínio desejado, ex.: `app.seudominio.com.br`, e aponte
   um registro CNAME nesse domínio para `SEU-USUARIO.github.io`.

## Passo 8 — Primeiro acesso e cadastro do negócio de teste

1. Abra o link publicado.
2. Crie o primeiro usuário/empresa pela tela de login.
3. Cadastre ao menos uma unidade/loja (o gerador de demonstração exige isso).
4. Cadastre as formas de pagamento que a empresa vai usar.
5. Vá em **Sistema → Gerar Vendas de Demonstração**. Como a empresa ainda
   não tem categorias/produtos, o sistema mostra a pergunta **"Este teste é
   para qual tipo de negócio?"** com as opções: Cafeteria, Confeitaria/Bolos,
   Sorveteria/Gelateria, Restaurante, Pizzaria e Outro/Genérico. Escolha uma
   e clique em **Gerar vendas** — o sistema cria categorias, produtos e
   vendas de exemplo já no perfil daquele ramo.
6. Para recomeçar com outro tipo de negócio, use **Apagar dados de
   demonstração** e gere de novo escolhendo outra opção.

---

## O que eu NÃO consigo fazer daqui

- Não tenho acesso de rede a `supabase.co`, `github.com` (além de clonar
  código público) nem a provedores de hospedagem — por isso os passos acima
  são para vocês executarem, não algo que eu rode sozinho.
- 19 tabelas do sistema original ainda não foram reconstruídas (WhatsApp,
  assistente, auditoria, config fiscal) — ver a lista completa e o porquê
  em `supabase/esquema/LEIA-ME-SCHEMA.md`. Nenhuma delas bloqueia o teste
  do dia a dia (venda, produto, estoque, financeiro).
- Não tenho como recriar a arte do logo/ícone/fundo de login — os arquivos
  `logo-icone.png`, `logo-icone-192.png` e `login-fundo.jpg` ainda são a arte
  antiga, só com nome de arquivo genérico. Precisam de uma arte nova de
  verdade antes de qualquer cliente externo ver a tela de login.

---

## Changelog desta limpeza (o que foi feito e por quê)

- Todo texto visível (título, telas, comprovantes, PWA) trocado:
  "Joia/JOIA/Nexor/NEXOR" → **Nexalytix**; "Jolô/Jolo" → **Doce Aroma**
  (nome usado só como exemplo em comentários/placeholders remanescentes).
- **Identificadores internos renomeados** (antes eu tinha deixado por
  segurança, agora renomeei porque vocês pediram zero menção):
  `clientes_nexor` → `clientes_parceiros` (tabela — já refletido no
  `TABELAS.md` e na Edge Function), `DB.clientesNexor` → `DB.clientesParceiros`,
  `telaClientesNexor()` → `telaClientesParceiros()`,
  `telaFinanceiroNexor()` → `telaFinanceiroParceiros()`, chaves de
  `localStorage`/`sessionStorage` (`nexor_dados`, `nexor-auth`, `nexor_modo`,
  `nexor_sessao` etc.) → prefixo `app_`/`app-`, nomes de arquivo de
  exportação CSV/JSON (`nexor-vendas-...csv` etc.) → prefixo `export-`.
- **URLs de infraestrutura real da operação antiga, neutralizadas**: o link
  do cardápio digital e do app do franqueado
  (`rafaeluendes-jpg.github.io/...`), o robô de WhatsApp
  (`nexor-whatsapp.onrender.com`) e o identificador do projeto Supabase
  antigo (`cevghkndzpzvnzwifhnm`) viraram placeholders óbvios
  (`SEU-CARDAPIO-DIGITAL.exemplo.com`, `SEU-PROJETO` etc.) em vez de
  continuarem apontando para serviços de terceiros.
- Arquivos de imagem renomeados (`joia-icone.png` → `logo-icone.png`,
  `joia-fundo.jpg` → `login-fundo.jpg`); os `nexor-*.png` que não eram
  usados em lugar nenhum do sistema foram removidos do pacote.
- `manifest.json`, `sw.js` (nome do cache) e o workflow do GitHub Pages
  ajustados para o nome novo.
- **`DECISOES.md` (143 KB de histórico interno da operação da Jolô),
  `ARQUITETURA.md` e `LEIA-ME.md` antigos foram removidos deste pacote** —
  não fazem parte do que roda no navegador e são histórico de outro cliente,
  não deveriam ir para uma instalação nova.
- Adicionado o seletor de **tipo de negócio** (Cafeteria, Confeitaria/Bolos,
  Sorveteria, Restaurante, Pizzaria, Outro) na tela "Gerar Vendas de
  Demonstração" — cada opção pré-carrega categorias e produtos de exemplo
  do ramo escolhido.
