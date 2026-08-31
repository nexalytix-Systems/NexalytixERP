-- ==========================================================
-- Migração v7: cria a tabela de planos de mensalidade e liga
-- ela à tabela sucursais. Seguro rodar mais de uma vez.
-- ==========================================================

create table if not exists planos_franquia (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  nome text,
  valor numeric(14,4),
  criterio_tipo text,
  criterio_limite integer,
  ativo boolean default false,
  ordem integer,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now(),
  ref_local text
);
alter table planos_franquia enable row level security;

do $$ begin
  if not exists (select 1 from pg_constraint where conname='fk_planos_franquia_empresa') then
    alter table planos_franquia add constraint fk_planos_franquia_empresa
      foreign key (empresa_id) references empresas(id);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_constraint where conname='uq_planos_franquia_ref') then
    alter table planos_franquia add constraint uq_planos_franquia_ref unique (ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='planos_franquia') then
    create policy "planos_franquia mesma empresa" on planos_franquia for all
      using (empresa_id = minha_empresa()) with check (empresa_id = minha_empresa());
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_trigger where tgname='trg_empresa_id_planos_franquia') then
    create trigger trg_empresa_id_planos_franquia before insert on planos_franquia
      for each row execute function preencher_empresa_id();
  end if;
end $$;

-- SEM gatilho de versão aqui: planos_franquia não tem loja_id (é da
-- empresa inteira, não por loja) — o gatilho bump_loja_versao() tentaria
-- ler NEW.loja_id e quebraria a gravação.

-- liga sucursais ao plano escolhido
do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='sucursais' and column_name='plano_id') then
    alter table sucursais add column plano_id uuid;
  end if;
  if not exists (select 1 from pg_constraint where conname='fk_sucursais_plano_id') then
    alter table sucursais add constraint fk_sucursais_plano_id foreign key (plano_id) references planos_franquia(id);
  end if;
end $$;
