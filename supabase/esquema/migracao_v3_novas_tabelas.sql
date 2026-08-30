-- ==========================================================
-- Migração v3: cria loja_versao, pedidos_online, menu_layout;
-- corrige caixas (aberto_em/fechado_em); liga o gatilho de
-- versão em toda tabela com loja_id. Seguro rodar mais de uma vez.
-- ==========================================================

-- 1) loja_versao
create table if not exists loja_versao (
  loja_id uuid primary key,
  empresa_id uuid not null,
  versao integer not null default 0
);
alter table loja_versao enable row level security;
do $$ begin
  if not exists (select 1 from pg_constraint where conname='fk_loja_versao_empresa') then
    alter table loja_versao add constraint fk_loja_versao_empresa foreign key (empresa_id) references empresas(id);
  end if;
end $$;
do $$ begin
  if not exists (select 1 from pg_policies where tablename='loja_versao') then
    create policy "loja_versao mesma empresa" on loja_versao for all
      using (empresa_id = minha_empresa()) with check (empresa_id = minha_empresa());
  end if;
end $$;

-- 2) pedidos_online
create table if not exists pedidos_online (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  loja_id uuid,
  numero integer,
  situacao text,
  tipo text,
  cliente_nome text,
  cliente_tel text,
  subtotal numeric(14,4),
  taxa numeric(14,4),
  total numeric(14,4),
  forma_pagamento text,
  troco_para numeric(14,4),
  observacao text,
  endereco jsonb default '{}'::jsonb,
  zona text,
  cidade text,
  mesa_numero integer,
  itens jsonb default '{}'::jsonb,
  pedido_id uuid,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table pedidos_online enable row level security;
do $$ begin
  if not exists (select 1 from pg_constraint where conname='fk_pedidos_online_empresa') then
    alter table pedidos_online add constraint fk_pedidos_online_empresa foreign key (empresa_id) references empresas(id);
  end if;
  if not exists (select 1 from pg_constraint where conname='fk_pedidos_online_pedido') then
    alter table pedidos_online add constraint fk_pedidos_online_pedido foreign key (pedido_id) references pedidos(id);
  end if;
end $$;
do $$ begin
  if not exists (select 1 from pg_policies where tablename='pedidos_online') then
    create policy "pedidos_online mesma empresa" on pedidos_online for all
      using (empresa_id = minha_empresa()) with check (empresa_id = minha_empresa());
  end if;
end $$;

-- 3) menu_layout (linha única global da plataforma)
create table if not exists menu_layout (
  id integer primary key,
  mods jsonb default '{}'::jsonb,
  itens jsonb default '{}'::jsonb,
  atualizado_em timestamptz not null default now()
);
alter table menu_layout enable row level security;
insert into menu_layout(id) values (1) on conflict do nothing;
do $$ begin
  if not exists (select 1 from pg_policies where tablename='menu_layout') then
    create policy "menu_layout leitura geral" on menu_layout for select using (auth.uid() is not null);
  end if;
end $$;

-- 4) caixas: aberto_em / fechado_em
do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='caixas' and column_name='aberto_em') then
    alter table caixas add column aberto_em timestamptz not null default now();
  end if;
  if not exists (select 1 from information_schema.columns where table_name='caixas' and column_name='fechado_em') then
    alter table caixas add column fechado_em timestamptz;
  end if;
end $$;

-- 5) função + gatilho de versão por loja, em toda tabela com loja_id
create or replace function bump_loja_versao() returns trigger
language plpgsql as $$
declare
  v_loja uuid;
  v_empresa uuid;
begin
  v_loja := coalesce(new.loja_id, old.loja_id);
  v_empresa := coalesce(new.empresa_id, old.empresa_id);
  if v_loja is not null then
    insert into loja_versao(loja_id, empresa_id, versao)
    values (v_loja, v_empresa, 1)
    on conflict (loja_id) do update set versao = loja_versao.versao + 1;
  end if;
  return coalesce(new, old);
end;
$$;

do $$
declare r record;
begin
  for r in
    select table_name from information_schema.columns
    where table_schema='public' and column_name='loja_id'
      and table_name not in ('empresas','perfis','log_alteracoes','loja_versao')
  loop
    if not exists (
      select 1 from pg_trigger where tgname = 'trg_versao_'||r.table_name
    ) then
      execute format('create trigger trg_versao_%I after insert or update or delete on %I for each row execute function bump_loja_versao()', r.table_name, r.table_name);
      raise notice 'gatilho criado: %', r.table_name;
    end if;
  end loop;
end $$;
