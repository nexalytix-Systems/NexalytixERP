-- ==========================================================
-- Migração v4: cria whatsapp_pendentes (fila da "Caixa de Entrada
-- da Assistente" — lançamentos confirmados pelo robô de WhatsApp,
-- aguardando aplicação). Seguro rodar mais de uma vez.
-- ==========================================================
create table if not exists whatsapp_pendentes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid not null,
  loja_id uuid,
  situacao text,
  dados jsonb default '{}'::jsonb,
  aplicado_em timestamptz,
  aplicado_por text,
  erro text,
  criado_em timestamptz not null default now(),
  atualizado_em timestamptz not null default now()
);
alter table whatsapp_pendentes enable row level security;

do $$ begin
  if not exists (select 1 from pg_constraint where conname='fk_whatsapp_pendentes_empresa') then
    alter table whatsapp_pendentes add constraint fk_whatsapp_pendentes_empresa
      foreign key (empresa_id) references empresas(id);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='whatsapp_pendentes') then
    create policy "whatsapp_pendentes mesma empresa" on whatsapp_pendentes for all
      using (empresa_id = minha_empresa()) with check (empresa_id = minha_empresa());
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_trigger where tgname='trg_versao_whatsapp_pendentes') then
    create trigger trg_versao_whatsapp_pendentes after insert or update or delete
      on whatsapp_pendentes for each row execute function bump_loja_versao();
  end if;
end $$;
