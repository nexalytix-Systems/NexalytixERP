# Schema do banco — reconstruído do zero (sem acesso ao banco antigo)

## Método usado

Como não havia acesso ao Supabase antigo, o schema **não é um dump** — foi
reconstruído por engenharia reversa do `MAPA` de sincronização que já existe
dentro do `index.html` (a função que sobe/desce dados da nuvem). Esse mapa
já diz, para cada tela do sistema, exatamente quais campos vão para qual
tabela — então em vez de eu chutar a estrutura, extraí ela do que o próprio
sistema já usa em produção.

Isso foi validado de verdade, não só lido: instalei um PostgreSQL local,
rodei o `schema.sql` e o `policies.sql` do zero, inseri uma venda completa
(empresa → loja → categoria → produto → cliente → pedido → item → pagamento)
e conferi os `JOIN`s. Depois simulei **duas empresas fictícias** com usuários
diferentes e testei — direto na API simulada, não só pela tela — se uma
conseguia ler, alterar ou apagar dado da outra. As três tentativas
retornaram zero linhas afetadas.

## O que está coberto (60 tabelas, campos reais)

Todo o núcleo operacional do sistema: catálogo (categorias, produtos,
grupos de opções, fichas técnicas, insumos), PDV (pedidos, itens,
pagamentos, mesas, comandas, caixas, turnos), estoque (movimentações,
contagens, transferências, ordens de produção), financeiro (contas,
categorias financeiras, lançamentos, DRE), clientes, cupons, entregadores,
fornecedores, notas de entrada, cardápio digital, áreas de entrega e o
cadastro de lojas parceiras (ex-`clientes_nexor`).

Cada tabela já nasce com `empresa_id`, RLS ativado e a política "só vê a
própria empresa" (arquivo `policies.sql`) — a função `minha_empresa()`
lê o `empresa_id` do perfil da pessoa logada.

## O que NÃO está coberto ainda (19 tabelas)

Levantei que estas 19 do índice original **não são acessadas pelo
`index.html`** (0 ocorrências de busca no código) — ou são responsabilidade
de outro serviço, ou são histórico/rascunho que não chegou a ser usado:

- `whatsapp_config`, `whatsapp_gestores`, `whatsapp_mensagens`,
  `whatsapp_pendentes`, `whatsapp_sessoes` — pertencem ao robô de WhatsApp
  (serviço à parte, não à interface web). Só faz sentido desenhar isso
  quando/se vocês decidirem reconstruir essa integração.
- `assistente_conversas`, `assistente_rotinas` — recurso de assistente
  dentro do sistema, uso muito pontual no código.
- `audit_log`, `backups`, `loja_versao`, `migracao_sucursal_loja` — não
  aparecem em nenhuma chamada do front-end; provavelmente eram
  administradas direto no painel do Supabase ou por script separado.
- `app_usuarios`, `app_sessoes` — possivelmente redundantes com
  `auth.users` do próprio Supabase (o sistema já usa `auth.users` para
  login); não recriei para não duplicar sem necessidade.
- `fiscal_config`, `pedidos_online`, `menu_layout`, `sucursal_permissoes`,
  `lojas` — usadas em pontos bem específicos do código; não tive tempo de
  reverter cada uma neste primeiro pacote.

**Nenhuma dessas bloqueia o teste do dia a dia** (vender, cadastrar
produto, ver relatório, controlar estoque, lançar financeiro). Se ao testar
vocês esbarrarem numa tela que depende de uma dessas, me avisem qual —
eu volto no código, acho o trecho exato que grava/lê aquela tabela (do
mesmo jeito que fiz com as 60 já prontas) e completo o schema.

## Coisas para revisar antes de considerar isso "definitivo"

- **Os tipos de coluna são inferidos por nome, não confirmados.** Por
  exemplo, todo campo que termina em `_id` virou `uuid`; todo campo com
  "valor", "preco", "total" etc. no nome virou `numeric(14,4)`. Funciona
  para o teste, mas o time deveria revisar linha a linha antes de um
  cliente pagante depender disso — é exatamente o V80.1/V81/V82/V83 que o
  `DECISOES.md` original descrevia: regra vivendo só de convenção quebra.
- **`sucursal_id` versus `loja_id`.** O código já mistura os dois nomes
  (a própria tabela `migracao_sucursal_loja`, que ficou de fora, sugere que
  isso já estava em transição). Usei `sucursal_id` como padrão porque é o
  nome mais usado no `MAPA`, mas `perfis.loja_id` continua com esse nome
  porque é o que o código de login realmente lê.
- **As políticas de RLS são o ponto de partida, não o final.** Elas
  bastam para isolar por empresa, que era o crítico. Regras mais finas
  (ex.: operador de caixa não edita financeiro) ainda dependem do `cargo`
  em `perfis` e não foram desenhadas aqui — ficam para quando o time
  revisar permissão por papel.

## Como rodar

No SQL Editor do projeto Supabase novo, nesta ordem:
1. `supabase/esquema/schema.sql`
2. `supabase/esquema/policies.sql`

(os dois já rodam limpos do zero — foi assim que testei.)
