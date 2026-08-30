-- ==========================================================
-- Migração v5: preenche empresa_id automaticamente em toda
-- gravação, direto da sessão de quem está logado — porque o
-- index.html nunca manda empresa_id (só loja_id), e sem isso
-- toda escrita era rejeitada pela política de RLS em silêncio.
-- Seguro rodar mais de uma vez.
-- ==========================================================

create or replace function preencher_empresa_id() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  v_empresa uuid;
begin
  if new.empresa_id is null then
    select empresa_id into v_empresa from perfis where id = auth.uid();
    new.empresa_id := v_empresa;
  end if;
  return new;
end;
$$;

do $$
declare r record;
begin
  for r in
    select table_name from information_schema.columns
    where table_schema='public' and column_name='empresa_id'
      and table_name not in ('empresas')
  loop
    if not exists (
      select 1 from pg_trigger where tgname = 'trg_empresa_id_'||r.table_name
    ) then
      execute format(
        'create trigger trg_empresa_id_%I before insert on %I for each row execute function preencher_empresa_id()',
        r.table_name, r.table_name
      );
      raise notice 'gatilho criado: %', r.table_name;
    end if;
  end loop;
end $$;
