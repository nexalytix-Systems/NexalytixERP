-- ==========================================================
-- Nexalytix — schema reconstruído do zero
-- Gerado por engenharia reversa do MAPA de sincronização real
-- do index.html (não é dump do banco antigo — ver LEIA-ME-SCHEMA.md)
-- ==========================================================

create extension if not exists pgcrypto;

-- ---------- base do multi-tenant (novo, não existia no código) ----------

create table empresas (
  id uuid primary key default gen_random_uuid(),
  nome text not null,
  logo_url text,
  cor_primaria text,
  cor_secundaria text,
  favicon_url text,
  icone_pwa_url text,
  tipo_negocio text,
  criada_em timestamptz not null default now()
);
alter table empresas enable row level security;

create table perfis (
  id uuid primary key references auth.users(id) on delete cascade,
  nome text,
  cargo text,
  empresa_id uuid,
  loja_id uuid,
  sucursal_ref uuid,
  nome_unidade text,
  criado_em timestamptz not null default now()
);
alter table perfis enable row level security;

create table log_alteracoes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  usuario_id uuid,
  tabela text not null,
  registro_id uuid,
  acao text not null,
  antes jsonb,
  depois jsonb,
  criado_em timestamptz not null default now()
);
alter table log_alteracoes enable row level security;

-- ---------- reconstruídas a partir do MAPA de sincronização ----------

-- origem: DB.acertos
create table acertos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  entregador_id uuid,
  periodo_de date,
  periodo_ate date,
  qtd numeric(14,4),
  taxas numeric(14,4),
  diaria text,
  vendas jsonb default '{}'::jsonb,
  descontos numeric(14,4),
  acrescimos text,
  pago boolean default false,
  conta_id uuid,
  forma text,
  observacao text,
  data date,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table acertos enable row level security;

-- origem: DB.areas
create table areas_entrega (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  uf text,
  taxa_padrao numeric(14,4),
  tempo text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table areas_entrega enable row level security;

-- origem: filho de areas_entrega.zonas
create table areas_zonas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  area_id uuid not null,
  nome text,
  tipo text,
  taxa numeric(14,4),
  km text,
  tempo text,
  observacao text,
  ativa boolean default false,
  ordem integer,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table areas_zonas enable row level security;

-- origem: DB.baixasPend
create table baixas_pendentes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  item_ref uuid,
  item_nome text,
  item_tipo text,
  quantidade numeric(14,4),
  unidade text,
  custo_unit numeric(14,4),
  motivo_ref uuid,
  motivo_nome text,
  quem_registrou text,
  registrado_por text,
  data date,
  hora time,
  observacao text,
  situacao text,
  mov_ref uuid,
  lancada_em timestamptz,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table baixas_pendentes enable row level security;

-- origem: DB.basesCat
create table bases_catalogo (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  qtd_caixa numeric(14,4),
  valor_unit numeric(14,4),
  ficha_ref uuid,
  ativo boolean default false,
  ordem integer,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table bases_catalogo enable row level security;

-- origem: filho de caixas.movimentos
create table caixa_movimentos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  caixa_id uuid not null,
  tipo text,
  valor numeric(14,4),
  motivo text,
  responsavel text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table caixa_movimentos enable row level security;

-- origem: DB.caixas
create table caixas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  operador text,
  valor_inicial numeric(14,4),
  turno_id uuid,
  turno_nome text,
  operador_id uuid,
  aberto_txt text,
  fechado_txt text,
  esperado numeric(14,4),
  contado numeric(14,4),
  total_informado numeric(14,4),
  vendas jsonb default '{}'::jsonb,
  qtd_pedidos numeric(14,4),
  conferencia text,
  observacao text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table caixas enable row level security;

-- origem: DB.cancelamentos
create table cancelamentos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  pedido_ref uuid,
  pedido_numero text,
  valor numeric(14,4),
  data date,
  hora time,
  motivo_id uuid,
  motivo_nome text,
  observacao text,
  operador_id uuid,
  operador_nome text,
  caixa_ref uuid,
  turno_nome text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table cancelamentos enable row level security;

-- origem: DB.cardapioL
create table cardapio_config (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  ativo boolean default false,
  titulo text,
  slogan text,
  logo text,
  capa text,
  cor_principal text,
  cor_fundo text,
  whatsapp text,
  instagram text,
  endereco text,
  pedido_minimo numeric(14,4),
  tempo_entrega text,
  tempo_retirada text,
  aceita_entrega boolean default false,
  aceita_retirada boolean default false,
  pede_cpf boolean default false,
  formas_aceitas jsonb default '{}'::jsonb,
  pix_chave text,
  aviso text,
  horarios jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table cardapio_config enable row level security;

-- origem: DB.categorias
create table categorias (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  nome text,
  impressao text,
  imposto text,
  cor text,
  imagem text,
  ativa boolean default false,
  ordem integer,
  sucursais jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table categorias enable row level security;

-- origem: DB.catfin
create table categorias_financeiras (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  ordem integer,
  tipo text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table categorias_financeiras enable row level security;

-- origem: DB.clientes
create table clientes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  telefone text,
  cpf text,
  nascimento date,
  rua text,
  numero integer,
  bairro text,
  cidade text,
  referencia text,
  zona_id uuid,
  zona text,
  compras text,
  gasto numeric(14,4),
  limite_fiado numeric(14,4),
  saldo_fiado numeric(14,4),
  observacao text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table clientes enable row level security;

-- origem: DB.clientesParceiros
create table clientes_parceiros (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  rede text,
  responsavel text,
  email text,
  telefone text,
  documento text,
  cidade text,
  uf text,
  unidades text,
  plano text,
  mensalidade numeric(14,4),
  loja_id uuid,
  modulos jsonb default '{}'::jsonb,
  dia_vencimento text,
  situacao text,
  inicio date,
  observacao text,
  cobrancas jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table clientes_parceiros enable row level security;

-- origem: DB.comprasSemVinc
create table compras_sem_vinculo (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  nota_id uuid,
  nota_numero text,
  fornecedor_nome text,
  descricao text,
  documento text,
  valor numeric(14,4),
  vencimento date,
  excluido_por text,
  excluido_em timestamptz,
  dados jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table compras_sem_vinculo enable row level security;

-- origem: config por loja (chave única loja_id)
create table config_loja (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  loja_id uuid not null,
  loja_aberta boolean default false,
  tempo_entrega text,
  tempo_retirada text,
  caixa_cego boolean default false,
  layout text,
  fases jsonb default '{}'::jsonb,
  cfg_dre jsonb default '{}'::jsonb,
  cfg_mesa jsonb default '{}'::jsonb,
  cfg_modos jsonb default '{}'::jsonb,
  cfg_fiscal jsonb default '{}'::jsonb,
  cfg_totem jsonb default '{}'::jsonb,
  cfg_pdv jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table config_loja enable row level security;
create unique index uq_config_loja_loja on config_loja(loja_id);

-- origem: config por loja (chave única loja_id)
create table config_operacao (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  loja_id uuid not null,
  gerente jsonb default '{}'::jsonb,
  zap jsonb default '{}'::jsonb,
  canais jsonb default '{}'::jsonb,
  ass_plat jsonb default '{}'::jsonb,
  redes jsonb default '{}'::jsonb,
  operadores jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table config_operacao enable row level security;
create unique index uq_config_operacao_loja on config_operacao(loja_id);

-- origem: DB.contagens
create table contagens_estoque (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  data date,
  hora time,
  perda numeric(14,4),
  ganho numeric(14,4),
  resultado text,
  itens jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table contagens_estoque enable row level security;

-- origem: DB.contas
create table contas_capital (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  tipo text,
  banco text,
  agencia text,
  numero integer,
  saldo_inicial numeric(14,4),
  fixa boolean default false,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table contas_capital enable row level security;

-- origem: DB.cupomUsos
create table cupom_usos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  cupom_id uuid,
  cliente_id uuid,
  cliente_nome text,
  pedido_id uuid,
  numero integer,
  valor numeric(14,4),
  total_pedido numeric(14,4),
  data date,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table cupom_usos enable row level security;

-- origem: DB.cupons
create table cupons (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  codigo text,
  tipo text,
  valor numeric(14,4),
  teto text,
  minimo numeric(14,4),
  valido_de date,
  valido_ate date,
  hora_de time,
  hora_ate time,
  quantidade numeric(14,4),
  limite_cliente numeric(14,4),
  formas jsonb default '{}'::jsonb,
  canais jsonb default '{}'::jsonb,
  ativo boolean default false,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table cupons enable row level security;

-- origem: DB.cupons_f
create table cupons_fiscais (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  pedido_ref uuid,
  pedido_numero text,
  origem text,
  modelo text,
  serie text,
  numero integer,
  chave text,
  protocolo text,
  status text,
  motivo text,
  ambiente text,
  consumidor_nome text,
  consumidor_doc text,
  pagamento date,
  valor_total numeric(14,4),
  valor_desconto numeric(14,4),
  valor_entrega numeric(14,4),
  data_venda date,
  hora_venda time,
  nfe_agrupada_ref uuid,
  contingencia boolean default false,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table cupons_fiscais enable row level security;

-- origem: filho de entregadores.taxas
create table entregador_taxas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  entregador_id uuid not null,
  cidade text,
  valor numeric(14,4),
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table entregador_taxas enable row level security;

-- origem: DB.entregadores
create table entregadores (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  telefone text,
  cpf text,
  pix text,
  diarias jsonb default '{}'::jsonb,
  padrao boolean default false,
  ativo boolean default false,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table entregadores enable row level security;

-- origem: DB.estoqueUn
create table estoque_unidade (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  item_ref uuid,
  tipo text,
  estoque numeric(14,4),
  custo_medio numeric(14,4),
  atualizado_em timestamptz,
  criado_em timestamptz not null default now()
);
alter table estoque_unidade enable row level security;

-- origem: DB.fiadoMov
create table fiado_movimentos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  cliente_id uuid,
  tipo text,
  valor numeric(14,4),
  data date,
  pedido_id uuid,
  forma_id uuid,
  conta_id uuid,
  observacao text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table fiado_movimentos enable row level security;

-- origem: DB.fichaCats
create table ficha_grupos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table ficha_grupos enable row level security;

-- origem: filho de fichas_tecnicas.itens
create table ficha_itens (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  ficha_id uuid not null,
  insumo_id uuid,
  ficha_ref uuid,
  quantidade numeric(14,4),
  unidade text,
  perda numeric(14,4),
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table ficha_itens enable row level security;

-- origem: DB.fichas
create table fichas_tecnicas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  codigo text,
  grupo_id uuid,
  subcategoria_id uuid,
  subgrupo_id uuid,
  unidade text,
  estocavel boolean default false,
  na_producao boolean default false,
  disponivel_venda boolean default false,
  rendimento text,
  rend_unidade text,
  unidades_venda text,
  preco numeric(14,4),
  receita text,
  tempo text,
  validade date,
  temperatura text,
  observacao text,
  foto text,
  ncm text,
  cfop text,
  cest text,
  origem text,
  cst text,
  aliquota numeric(14,4),
  lojas jsonb default '{}'::jsonb,
  destino_id uuid,
  destino_fator numeric(14,4),
  estoque_atual numeric(14,4),
  custo_medio numeric(14,4),
  destino_nome text,
  destino_modo text,
  sucursais jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table fichas_tecnicas enable row level security;

-- origem: DB.formasPag
create table formas_pagamento (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  tipo text,
  bandeira text,
  taxa_pct numeric(14,4),
  taxa_fixa numeric(14,4),
  dias_recebimento numeric(14,4),
  conta_id uuid,
  ativa boolean default false,
  online boolean default false,
  ordem integer,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table formas_pagamento enable row level security;

-- origem: DB.fornec
create table fornecedores (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  empresa text,
  contato text,
  cnpj text,
  email text,
  telefone text,
  whatsapp text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table fornecedores enable row level security;

-- origem: DB.gruposIng
create table grupos_ingredientes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  compoe_cmv boolean default false,
  categoria text,
  sucursais jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table grupos_ingredientes enable row level security;

-- origem: DB.grupos
create table grupos_opcoes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  minimo numeric(14,4),
  maximo numeric(14,4),
  forcado boolean default false,
  ordem integer,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table grupos_opcoes enable row level security;

-- origem: DB.insumos
create table insumos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  codigo text,
  unidade text,
  grupo_id uuid,
  subcategoria_id uuid,
  controla_estoque boolean default false,
  compoe_cmv boolean default false,
  estoque_min numeric(14,4),
  estoque_max numeric(14,4),
  validade date,
  ean13 text,
  permite_venda boolean default false,
  embalagem text,
  estoque_atual numeric(14,4),
  fator numeric(14,4),
  custo numeric(14,4),
  custo_ultima numeric(14,4),
  modo_custo numeric(14,4),
  fornecedor_id uuid,
  descricao text,
  gelato_venda boolean default false,
  sucursais jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table insumos enable row level security;

-- origem: DB.lancFin
create table lancamentos_financeiros (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  tipo text,
  conta_id uuid,
  conta_destino_id uuid,
  forma_id uuid,
  subcategoria_id uuid,
  categoria_texto text,
  fornecedor_id uuid,
  fornecedor_nome text,
  descricao text,
  documento text,
  valor numeric(14,4),
  codigo_barras text,
  emissao date,
  vencimento date,
  pagamento date,
  pago boolean default false,
  conciliado boolean default false,
  data_conciliacao date,
  juros numeric(14,4),
  multa numeric(14,4),
  valor_original numeric(14,4),
  origem text,
  origem_ref uuid,
  observacao text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table lancamentos_financeiros enable row level security;

-- origem: DB.comandas
create table mesa_comandas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  mesa_ref uuid,
  mesa_numero text,
  nome text,
  itens jsonb default '{}'::jsonb,
  aberta boolean default false,
  aberta_em timestamptz,
  fechada_em timestamptz,
  pedido_ref uuid,
  sucursal_id uuid,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table mesa_comandas enable row level security;

-- origem: DB.mesas
create table mesas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  numero integer,
  nome text,
  lugares numeric(14,4),
  ativa boolean default false,
  sucursal_id uuid,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table mesas enable row level security;

-- origem: DB.modelosImp
create table modelos_impressao (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  tipo text,
  nome text,
  colunas integer,
  vias integer,
  corte boolean default false,
  gaveta boolean default false,
  modelo text,
  blocos text,
  manual boolean default false,
  ativo boolean default false,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table modelos_impressao enable row level security;

-- origem: DB.motivosCanc
create table motivos_cancelamento (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  ativo boolean default false,
  ordem integer,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table motivos_cancelamento enable row level security;

-- origem: DB.motivosMov
create table motivos_movimentacao (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  tipo text,
  sistema text,
  ativo boolean default false,
  lojas_visiveis jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table motivos_movimentacao enable row level security;

-- origem: DB.movEst
create table movimentacoes_estoque (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  data date,
  hora time,
  sucursal_id uuid,
  motivo_id uuid,
  identificacao text,
  observacao text,
  origem text,
  linhas jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table movimentacoes_estoque enable row level security;

-- origem: DB.notas
create table notas_entrada (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  numero integer,
  fornecedor_id uuid,
  fornecedor_nome text,
  data date,
  hora time,
  valor_mercadorias numeric(14,4),
  valor_total numeric(14,4),
  recebida boolean default false,
  pagamento date,
  itens jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table notas_entrada enable row level security;

-- origem: filho de grupos_opcoes.opcoes
create table opcoes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  grupo_id uuid not null,
  nome text,
  preco_adicional numeric(14,4),
  ordem integer,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table opcoes enable row level security;

-- origem: DB.ordensProd
create table ordens_producao (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  numero integer,
  data date,
  hora time,
  responsavel text,
  observacao text,
  previsto text,
  real_produzido text,
  diferenca text,
  itens jsonb default '{}'::jsonb,
  mov_id uuid,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table ordens_producao enable row level security;

-- origem: filho de pedidos_base.itens
create table pedido_base_itens (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  pedido_id uuid not null,
  base_ref uuid,
  base_nome text,
  ficha_ref uuid,
  quantidade numeric(14,4),
  valor_unit numeric(14,4),
  total numeric(14,4),
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table pedido_base_itens enable row level security;

-- origem: filho de pedidos.itens
create table pedido_itens (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  pedido_id uuid not null,
  produto_id uuid,
  nome text,
  quantidade numeric(14,4),
  unitario text,
  total numeric(14,4),
  opcoes jsonb default '{}'::jsonb,
  observacao text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table pedido_itens enable row level security;

-- origem: filho de pedidos.pagamentos
create table pedido_pagamentos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  pedido_id uuid not null,
  forma_id uuid,
  valor numeric(14,4),
  equipamento text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table pedido_pagamentos enable row level security;

-- origem: DB.pedidos
create table pedidos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  numero integer,
  tipo text,
  fase text,
  cliente_id uuid,
  cliente_nome text,
  cidade text,
  entregador_id uuid,
  caixa_id uuid,
  total numeric(14,4),
  taxa numeric(14,4),
  desconto numeric(14,4),
  fiscal text,
  hora time,
  data_venda date,
  mesa_id uuid,
  mesa_numero text,
  comanda_nome text,
  taxa_servico numeric(14,4),
  venda text,
  canal text,
  origem_venda text,
  equipamento text,
  senha_totem text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table pedidos enable row level security;

-- origem: DB.pedidosBase
create table pedidos_base (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  numero integer,
  sucursal_id uuid,
  sucursal_nome text,
  data date,
  responsavel text,
  observacao text,
  total numeric(14,4),
  situacao text,
  produzido boolean default false,
  mov_producao_ref uuid,
  financeiro_receber_ref uuid,
  entrada_estoque boolean default false,
  mov_entrada_ref uuid,
  financeiro_pagar_ref uuid,
  enviado_em timestamptz,
  confirmado_em timestamptz,
  entregue_em timestamptz,
  pago_em timestamptz,
  motivo_rejeicao text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table pedidos_base enable row level security;

-- origem: tabela de associação produto <-> grupo de opções
create table produto_grupos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  produto_id uuid,
  grupo_id uuid,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table produto_grupos enable row level security;

-- origem: DB.produtos
create table produtos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  nome text,
  preco numeric(14,4),
  codigo text,
  descricao text,
  categoria_id uuid,
  ativo boolean default false,
  ordem integer,
  imagem_url text,
  imagem text,
  disponivel_delivery boolean default false,
  pesado boolean default false,
  variacao boolean default false,
  nome_online text,
  disponivel jsonb default '{}'::jsonb,
  promocoes jsonb default '{}'::jsonb,
  vincula_estoque boolean default false,
  ncm text,
  cfop text,
  csosn text,
  cst text,
  origem_fiscal text,
  cest text,
  gtin text,
  unidade_tributavel text,
  ficha_id uuid,
  insumo_id uuid,
  insumo_qtd numeric(14,4),
  insumo_un text,
  sucursais jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table produtos enable row level security;

-- origem: DB.statusVenda
create table status_venda (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  papel text,
  ordem integer,
  ativo boolean default false,
  cor text,
  minutos numeric(14,4),
  som boolean default false,
  confere_pagamento boolean default false,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table status_venda enable row level security;

-- origem: filho de categorias_financeiras.itens
create table subcategorias_financeiras (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  categoria_id uuid not null,
  nome text,
  ordem integer,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table subcategorias_financeiras enable row level security;

-- origem: DB.sucursais
create table sucursais (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  apelido text,
  cnpj text,
  telefone text,
  cidade text,
  uf text,
  matriz boolean default false,
  ativa boolean default false,
  mensalidade numeric(14,4),
  dia_vencimento text,
  Mensalidades text,
  excluida_em timestamptz,
  login_responsavel text,
  rede_id uuid,
  rede_nome text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table sucursais enable row level security;

-- origem: DB.transf
create table transferencias (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  numero integer,
  origem_suc text,
  destino_suc text,
  situacao text,
  itens jsonb default '{}'::jsonb,
  valor_total numeric(14,4),
  observacao text,
  enviada_em timestamptz,
  enviada_por text,
  recebida_em timestamptz,
  recebida_por text,
  divergencia boolean default false,
  data_envio date,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table transferencias enable row level security;

-- origem: DB.turnos
create table turnos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  sucursal_id uuid,
  nome text,
  hora_inicio time,
  hora_fim time,
  ativo boolean default false,
  ordem integer,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table turnos enable row level security;

-- origem: DB.unidExtra
create table unidades_medida (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  sigla text,
  base text,
  fator numeric(14,4),
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table unidades_medida enable row level security;

-- origem: DB.usuarios
create table usuarios_sistema (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  login text,
  senha text,
  ativo boolean default false,
  tudo boolean default false,
  mestre boolean default false,
  sucursais jsonb default '{}'::jsonb,
  permissoes jsonb default '{}'::jsonb,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table usuarios_sistema enable row level security;

-- ---------- chaves estrangeiras (adicionadas depois, evita erro de ordem de criação) ----------
alter table perfis add constraint fk_perfis_empresa foreign key (empresa_id) references empresas(id);
alter table log_alteracoes add constraint fk_log_empresa foreign key (empresa_id) references empresas(id);
alter table log_alteracoes add constraint fk_log_usuario foreign key (usuario_id) references auth.users(id);
alter table acertos add constraint fk_acertos_entregador_id foreign key (entregador_id) references entregadores(id);
alter table acertos add constraint fk_acertos_conta_id foreign key (conta_id) references contas_capital(id);
alter table acertos add constraint fk_acertos_empresa foreign key (empresa_id) references empresas(id);
alter table areas_entrega add constraint fk_areas_entrega_empresa foreign key (empresa_id) references empresas(id);
alter table areas_zonas add constraint fk_areas_zonas_pai foreign key (area_id) references areas_entrega(id) on delete cascade;
alter table areas_zonas add constraint fk_areas_zonas_empresa foreign key (empresa_id) references empresas(id);
alter table baixas_pendentes add constraint fk_baixas_pendentes_empresa foreign key (empresa_id) references empresas(id);
alter table bases_catalogo add constraint fk_bases_catalogo_empresa foreign key (empresa_id) references empresas(id);
alter table caixa_movimentos add constraint fk_caixa_movimentos_pai foreign key (caixa_id) references caixas(id) on delete cascade;
alter table caixa_movimentos add constraint fk_caixa_movimentos_empresa foreign key (empresa_id) references empresas(id);
alter table caixas add constraint fk_caixas_turno_id foreign key (turno_id) references turnos(id);
alter table caixas add constraint fk_caixas_empresa foreign key (empresa_id) references empresas(id);
alter table cancelamentos add constraint fk_cancelamentos_motivo_id foreign key (motivo_id) references motivos_cancelamento(id);
alter table cancelamentos add constraint fk_cancelamentos_empresa foreign key (empresa_id) references empresas(id);
alter table cardapio_config add constraint fk_cardapio_config_sucursal_id foreign key (sucursal_id) references sucursais(id);
alter table cardapio_config add constraint fk_cardapio_config_empresa foreign key (empresa_id) references empresas(id);
alter table categorias add constraint fk_categorias_empresa foreign key (empresa_id) references empresas(id);
alter table categorias_financeiras add constraint fk_categorias_financeiras_empresa foreign key (empresa_id) references empresas(id);
alter table clientes add constraint fk_clientes_empresa foreign key (empresa_id) references empresas(id);
alter table clientes_parceiros add constraint fk_clientes_parceiros_empresa foreign key (empresa_id) references empresas(id);
alter table compras_sem_vinculo add constraint fk_compras_sem_vinculo_empresa foreign key (empresa_id) references empresas(id);
alter table config_loja add constraint fk_config_loja_empresa foreign key (empresa_id) references empresas(id);
alter table config_operacao add constraint fk_config_operacao_empresa foreign key (empresa_id) references empresas(id);
alter table contagens_estoque add constraint fk_contagens_estoque_empresa foreign key (empresa_id) references empresas(id);
alter table contas_capital add constraint fk_contas_capital_empresa foreign key (empresa_id) references empresas(id);
alter table cupom_usos add constraint fk_cupom_usos_cupom_id foreign key (cupom_id) references cupons(id);
alter table cupom_usos add constraint fk_cupom_usos_cliente_id foreign key (cliente_id) references clientes(id);
alter table cupom_usos add constraint fk_cupom_usos_pedido_id foreign key (pedido_id) references pedidos(id);
alter table cupom_usos add constraint fk_cupom_usos_empresa foreign key (empresa_id) references empresas(id);
alter table cupons add constraint fk_cupons_empresa foreign key (empresa_id) references empresas(id);
alter table cupons_fiscais add constraint fk_cupons_fiscais_empresa foreign key (empresa_id) references empresas(id);
alter table entregador_taxas add constraint fk_entregador_taxas_pai foreign key (entregador_id) references entregadores(id) on delete cascade;
alter table entregador_taxas add constraint fk_entregador_taxas_empresa foreign key (empresa_id) references empresas(id);
alter table entregadores add constraint fk_entregadores_empresa foreign key (empresa_id) references empresas(id);
alter table estoque_unidade add constraint fk_estoque_unidade_empresa foreign key (empresa_id) references empresas(id);
alter table fiado_movimentos add constraint fk_fiado_movimentos_cliente_id foreign key (cliente_id) references clientes(id);
alter table fiado_movimentos add constraint fk_fiado_movimentos_pedido_id foreign key (pedido_id) references pedidos(id);
alter table fiado_movimentos add constraint fk_fiado_movimentos_forma_id foreign key (forma_id) references formas_pagamento(id);
alter table fiado_movimentos add constraint fk_fiado_movimentos_conta_id foreign key (conta_id) references contas_capital(id);
alter table fiado_movimentos add constraint fk_fiado_movimentos_empresa foreign key (empresa_id) references empresas(id);
alter table ficha_grupos add constraint fk_ficha_grupos_empresa foreign key (empresa_id) references empresas(id);
alter table ficha_itens add constraint fk_ficha_itens_pai foreign key (ficha_id) references fichas_tecnicas(id) on delete cascade;
alter table ficha_itens add constraint fk_ficha_itens_empresa foreign key (empresa_id) references empresas(id);
alter table fichas_tecnicas add constraint fk_fichas_tecnicas_grupo_id foreign key (grupo_id) references ficha_grupos(id);
alter table fichas_tecnicas add constraint fk_fichas_tecnicas_subcategoria_id foreign key (subcategoria_id) references subcategorias_financeiras(id);
alter table fichas_tecnicas add constraint fk_fichas_tecnicas_destino_id foreign key (destino_id) references insumos(id);
alter table fichas_tecnicas add constraint fk_fichas_tecnicas_empresa foreign key (empresa_id) references empresas(id);
alter table formas_pagamento add constraint fk_formas_pagamento_conta_id foreign key (conta_id) references contas_capital(id);
alter table formas_pagamento add constraint fk_formas_pagamento_empresa foreign key (empresa_id) references empresas(id);
alter table fornecedores add constraint fk_fornecedores_empresa foreign key (empresa_id) references empresas(id);
alter table grupos_ingredientes add constraint fk_grupos_ingredientes_empresa foreign key (empresa_id) references empresas(id);
alter table grupos_opcoes add constraint fk_grupos_opcoes_empresa foreign key (empresa_id) references empresas(id);
alter table insumos add constraint fk_insumos_grupo_id foreign key (grupo_id) references grupos_ingredientes(id);
alter table insumos add constraint fk_insumos_subcategoria_id foreign key (subcategoria_id) references subcategorias_financeiras(id);
alter table insumos add constraint fk_insumos_fornecedor_id foreign key (fornecedor_id) references fornecedores(id);
alter table insumos add constraint fk_insumos_empresa foreign key (empresa_id) references empresas(id);
alter table lancamentos_financeiros add constraint fk_lancamentos_financeiros_conta_id foreign key (conta_id) references contas_capital(id);
alter table lancamentos_financeiros add constraint fk_lancamentos_financeiros_conta_destino_id foreign key (conta_destino_id) references contas_capital(id);
alter table lancamentos_financeiros add constraint fk_lancamentos_financeiros_forma_id foreign key (forma_id) references formas_pagamento(id);
alter table lancamentos_financeiros add constraint fk_lancamentos_financeiros_subcategoria_id foreign key (subcategoria_id) references subcategorias_financeiras(id);
alter table lancamentos_financeiros add constraint fk_lancamentos_financeiros_fornecedor_id foreign key (fornecedor_id) references fornecedores(id);
alter table lancamentos_financeiros add constraint fk_lancamentos_financeiros_empresa foreign key (empresa_id) references empresas(id);
alter table mesa_comandas add constraint fk_mesa_comandas_empresa foreign key (empresa_id) references empresas(id);
alter table mesas add constraint fk_mesas_empresa foreign key (empresa_id) references empresas(id);
alter table modelos_impressao add constraint fk_modelos_impressao_empresa foreign key (empresa_id) references empresas(id);
alter table motivos_cancelamento add constraint fk_motivos_cancelamento_empresa foreign key (empresa_id) references empresas(id);
alter table motivos_movimentacao add constraint fk_motivos_movimentacao_empresa foreign key (empresa_id) references empresas(id);
alter table movimentacoes_estoque add constraint fk_movimentacoes_estoque_motivo_id foreign key (motivo_id) references motivos_movimentacao(id);
alter table movimentacoes_estoque add constraint fk_movimentacoes_estoque_empresa foreign key (empresa_id) references empresas(id);
alter table notas_entrada add constraint fk_notas_entrada_fornecedor_id foreign key (fornecedor_id) references fornecedores(id);
alter table notas_entrada add constraint fk_notas_entrada_empresa foreign key (empresa_id) references empresas(id);
alter table opcoes add constraint fk_opcoes_pai foreign key (grupo_id) references grupos_opcoes(id) on delete cascade;
alter table opcoes add constraint fk_opcoes_empresa foreign key (empresa_id) references empresas(id);
alter table ordens_producao add constraint fk_ordens_producao_empresa foreign key (empresa_id) references empresas(id);
alter table pedido_base_itens add constraint fk_pedido_base_itens_pai foreign key (pedido_id) references pedidos_base(id) on delete cascade;
alter table pedido_base_itens add constraint fk_pedido_base_itens_empresa foreign key (empresa_id) references empresas(id);
alter table pedido_itens add constraint fk_pedido_itens_pai foreign key (pedido_id) references pedidos(id) on delete cascade;
alter table pedido_itens add constraint fk_pedido_itens_produto_id foreign key (produto_id) references produtos(id);
alter table pedido_itens add constraint fk_pedido_itens_empresa foreign key (empresa_id) references empresas(id);
alter table pedido_pagamentos add constraint fk_pedido_pagamentos_pai foreign key (pedido_id) references pedidos(id) on delete cascade;
alter table pedido_pagamentos add constraint fk_pedido_pagamentos_forma_id foreign key (forma_id) references formas_pagamento(id);
alter table pedido_pagamentos add constraint fk_pedido_pagamentos_empresa foreign key (empresa_id) references empresas(id);
alter table pedidos add constraint fk_pedidos_cliente_id foreign key (cliente_id) references clientes(id);
alter table pedidos add constraint fk_pedidos_entregador_id foreign key (entregador_id) references entregadores(id);
alter table pedidos add constraint fk_pedidos_caixa_id foreign key (caixa_id) references caixas(id);
alter table pedidos add constraint fk_pedidos_mesa_id foreign key (mesa_id) references mesas(id);
alter table pedidos add constraint fk_pedidos_empresa foreign key (empresa_id) references empresas(id);
alter table pedidos_base add constraint fk_pedidos_base_empresa foreign key (empresa_id) references empresas(id);
alter table produto_grupos add constraint fk_produto_grupos_produto_id foreign key (produto_id) references produtos(id);
alter table produto_grupos add constraint fk_produto_grupos_grupo_id foreign key (grupo_id) references grupos_opcoes(id);
alter table produto_grupos add constraint fk_produto_grupos_empresa foreign key (empresa_id) references empresas(id);
alter table produtos add constraint fk_produtos_categoria_id foreign key (categoria_id) references categorias(id);
alter table produtos add constraint fk_produtos_ficha_id foreign key (ficha_id) references fichas_tecnicas(id);
alter table produtos add constraint fk_produtos_insumo_id foreign key (insumo_id) references insumos(id);
alter table produtos add constraint fk_produtos_empresa foreign key (empresa_id) references empresas(id);
alter table status_venda add constraint fk_status_venda_empresa foreign key (empresa_id) references empresas(id);
alter table subcategorias_financeiras add constraint fk_subcategorias_financeiras_pai foreign key (categoria_id) references categorias_financeiras(id) on delete cascade;
alter table subcategorias_financeiras add constraint fk_subcategorias_financeiras_empresa foreign key (empresa_id) references empresas(id);
alter table sucursais add constraint fk_sucursais_empresa foreign key (empresa_id) references empresas(id);
alter table transferencias add constraint fk_transferencias_empresa foreign key (empresa_id) references empresas(id);
alter table turnos add constraint fk_turnos_empresa foreign key (empresa_id) references empresas(id);
alter table unidades_medida add constraint fk_unidades_medida_empresa foreign key (empresa_id) references empresas(id);
alter table usuarios_sistema add constraint fk_usuarios_sistema_empresa foreign key (empresa_id) references empresas(id);
