-- ==========================================================

-- Migração v6: adiciona a coluna ref_local (o id local do

-- aparelho) e a restrição UNIQUE que o UPSERT da sincronização

-- exige (ON CONFLICT). Sem isso, o Postgres rejeita a gravação

-- inteira, em silêncio — provavelmente a causa real de quase

-- tudo que 'não estava salvando'. Seguro rodar mais de uma vez.

-- ==========================================================


do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='acertos' and column_name='ref_local') then
    alter table acertos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_acertos_loja_ref') then
    alter table acertos add constraint uq_acertos_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='areas_entrega' and column_name='ref_local') then
    alter table areas_entrega add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_areas_entrega_loja_ref') then
    alter table areas_entrega add constraint uq_areas_entrega_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='baixas_pendentes' and column_name='ref_local') then
    alter table baixas_pendentes add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_baixas_pendentes_loja_ref') then
    alter table baixas_pendentes add constraint uq_baixas_pendentes_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='bases_catalogo' and column_name='ref_local') then
    alter table bases_catalogo add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_bases_catalogo_loja_ref') then
    alter table bases_catalogo add constraint uq_bases_catalogo_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='caixas' and column_name='ref_local') then
    alter table caixas add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_caixas_loja_ref') then
    alter table caixas add constraint uq_caixas_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='cancelamentos' and column_name='ref_local') then
    alter table cancelamentos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_cancelamentos_loja_ref') then
    alter table cancelamentos add constraint uq_cancelamentos_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='cardapio_config' and column_name='ref_local') then
    alter table cardapio_config add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_cardapio_config_loja_ref') then
    alter table cardapio_config add constraint uq_cardapio_config_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='categorias' and column_name='ref_local') then
    alter table categorias add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_categorias_loja_ref') then
    alter table categorias add constraint uq_categorias_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='categorias_financeiras' and column_name='ref_local') then
    alter table categorias_financeiras add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_categorias_financeiras_loja_ref') then
    alter table categorias_financeiras add constraint uq_categorias_financeiras_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='clientes' and column_name='ref_local') then
    alter table clientes add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_clientes_loja_ref') then
    alter table clientes add constraint uq_clientes_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='clientes_parceiros' and column_name='ref_local') then
    alter table clientes_parceiros add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_clientes_parceiros_loja_ref') then
    alter table clientes_parceiros add constraint uq_clientes_parceiros_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='compras_sem_vinculo' and column_name='ref_local') then
    alter table compras_sem_vinculo add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_compras_sem_vinculo_loja_ref') then
    alter table compras_sem_vinculo add constraint uq_compras_sem_vinculo_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='config_loja' and column_name='ref_local') then
    alter table config_loja add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_config_loja_loja_ref') then
    alter table config_loja add constraint uq_config_loja_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='config_operacao' and column_name='ref_local') then
    alter table config_operacao add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_config_operacao_loja_ref') then
    alter table config_operacao add constraint uq_config_operacao_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='contagens_estoque' and column_name='ref_local') then
    alter table contagens_estoque add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_contagens_estoque_loja_ref') then
    alter table contagens_estoque add constraint uq_contagens_estoque_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='contas_capital' and column_name='ref_local') then
    alter table contas_capital add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_contas_capital_loja_ref') then
    alter table contas_capital add constraint uq_contas_capital_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='cupom_usos' and column_name='ref_local') then
    alter table cupom_usos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_cupom_usos_loja_ref') then
    alter table cupom_usos add constraint uq_cupom_usos_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='cupons' and column_name='ref_local') then
    alter table cupons add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_cupons_loja_ref') then
    alter table cupons add constraint uq_cupons_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='cupons_fiscais' and column_name='ref_local') then
    alter table cupons_fiscais add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_cupons_fiscais_loja_ref') then
    alter table cupons_fiscais add constraint uq_cupons_fiscais_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='entregadores' and column_name='ref_local') then
    alter table entregadores add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_entregadores_loja_ref') then
    alter table entregadores add constraint uq_entregadores_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='estoque_unidade' and column_name='ref_local') then
    alter table estoque_unidade add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_estoque_unidade_loja_ref') then
    alter table estoque_unidade add constraint uq_estoque_unidade_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='fiado_movimentos' and column_name='ref_local') then
    alter table fiado_movimentos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_fiado_movimentos_loja_ref') then
    alter table fiado_movimentos add constraint uq_fiado_movimentos_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='ficha_grupos' and column_name='ref_local') then
    alter table ficha_grupos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_ficha_grupos_loja_ref') then
    alter table ficha_grupos add constraint uq_ficha_grupos_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='fichas_tecnicas' and column_name='ref_local') then
    alter table fichas_tecnicas add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_fichas_tecnicas_loja_ref') then
    alter table fichas_tecnicas add constraint uq_fichas_tecnicas_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='formas_pagamento' and column_name='ref_local') then
    alter table formas_pagamento add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_formas_pagamento_loja_ref') then
    alter table formas_pagamento add constraint uq_formas_pagamento_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='fornecedores' and column_name='ref_local') then
    alter table fornecedores add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_fornecedores_loja_ref') then
    alter table fornecedores add constraint uq_fornecedores_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='grupos_ingredientes' and column_name='ref_local') then
    alter table grupos_ingredientes add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_grupos_ingredientes_loja_ref') then
    alter table grupos_ingredientes add constraint uq_grupos_ingredientes_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='grupos_opcoes' and column_name='ref_local') then
    alter table grupos_opcoes add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_grupos_opcoes_loja_ref') then
    alter table grupos_opcoes add constraint uq_grupos_opcoes_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='insumos' and column_name='ref_local') then
    alter table insumos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_insumos_loja_ref') then
    alter table insumos add constraint uq_insumos_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='lancamentos_financeiros' and column_name='ref_local') then
    alter table lancamentos_financeiros add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_lancamentos_financeiros_loja_ref') then
    alter table lancamentos_financeiros add constraint uq_lancamentos_financeiros_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='mesa_comandas' and column_name='ref_local') then
    alter table mesa_comandas add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_mesa_comandas_loja_ref') then
    alter table mesa_comandas add constraint uq_mesa_comandas_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='mesas' and column_name='ref_local') then
    alter table mesas add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_mesas_loja_ref') then
    alter table mesas add constraint uq_mesas_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='modelos_impressao' and column_name='ref_local') then
    alter table modelos_impressao add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_modelos_impressao_loja_ref') then
    alter table modelos_impressao add constraint uq_modelos_impressao_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='motivos_cancelamento' and column_name='ref_local') then
    alter table motivos_cancelamento add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_motivos_cancelamento_loja_ref') then
    alter table motivos_cancelamento add constraint uq_motivos_cancelamento_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='motivos_movimentacao' and column_name='ref_local') then
    alter table motivos_movimentacao add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_motivos_movimentacao_loja_ref') then
    alter table motivos_movimentacao add constraint uq_motivos_movimentacao_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='movimentacoes_estoque' and column_name='ref_local') then
    alter table movimentacoes_estoque add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_movimentacoes_estoque_loja_ref') then
    alter table movimentacoes_estoque add constraint uq_movimentacoes_estoque_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='notas_entrada' and column_name='ref_local') then
    alter table notas_entrada add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_notas_entrada_loja_ref') then
    alter table notas_entrada add constraint uq_notas_entrada_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='ordens_producao' and column_name='ref_local') then
    alter table ordens_producao add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_ordens_producao_loja_ref') then
    alter table ordens_producao add constraint uq_ordens_producao_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='pedido_base_itens' and column_name='ref_local') then
    alter table pedido_base_itens add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_pedido_base_itens_loja_ref') then
    alter table pedido_base_itens add constraint uq_pedido_base_itens_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='pedidos' and column_name='ref_local') then
    alter table pedidos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_pedidos_loja_ref') then
    alter table pedidos add constraint uq_pedidos_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='pedidos_base' and column_name='ref_local') then
    alter table pedidos_base add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_pedidos_base_loja_ref') then
    alter table pedidos_base add constraint uq_pedidos_base_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='produtos' and column_name='ref_local') then
    alter table produtos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_produtos_loja_ref') then
    alter table produtos add constraint uq_produtos_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='status_venda' and column_name='ref_local') then
    alter table status_venda add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_status_venda_loja_ref') then
    alter table status_venda add constraint uq_status_venda_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='sucursais' and column_name='ref_local') then
    alter table sucursais add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_sucursais_loja_ref') then
    alter table sucursais add constraint uq_sucursais_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='transferencias' and column_name='ref_local') then
    alter table transferencias add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_transferencias_loja_ref') then
    alter table transferencias add constraint uq_transferencias_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='turnos' and column_name='ref_local') then
    alter table turnos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_turnos_loja_ref') then
    alter table turnos add constraint uq_turnos_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='unidades_medida' and column_name='ref_local') then
    alter table unidades_medida add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_unidades_medida_loja_ref') then
    alter table unidades_medida add constraint uq_unidades_medida_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='usuarios_sistema' and column_name='ref_local') then
    alter table usuarios_sistema add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_usuarios_sistema_loja_ref') then
    alter table usuarios_sistema add constraint uq_usuarios_sistema_loja_ref unique (loja_id, ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='areas_zonas' and column_name='ref_local') then
    alter table areas_zonas add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_areas_zonas_ref') then
    alter table areas_zonas add constraint uq_areas_zonas_ref unique (ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='caixa_movimentos' and column_name='ref_local') then
    alter table caixa_movimentos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_caixa_movimentos_ref') then
    alter table caixa_movimentos add constraint uq_caixa_movimentos_ref unique (ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='entregador_taxas' and column_name='ref_local') then
    alter table entregador_taxas add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_entregador_taxas_ref') then
    alter table entregador_taxas add constraint uq_entregador_taxas_ref unique (ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='ficha_itens' and column_name='ref_local') then
    alter table ficha_itens add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_ficha_itens_ref') then
    alter table ficha_itens add constraint uq_ficha_itens_ref unique (ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='opcoes' and column_name='ref_local') then
    alter table opcoes add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_opcoes_ref') then
    alter table opcoes add constraint uq_opcoes_ref unique (ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='pedido_itens' and column_name='ref_local') then
    alter table pedido_itens add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_pedido_itens_ref') then
    alter table pedido_itens add constraint uq_pedido_itens_ref unique (ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='pedido_pagamentos' and column_name='ref_local') then
    alter table pedido_pagamentos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_pedido_pagamentos_ref') then
    alter table pedido_pagamentos add constraint uq_pedido_pagamentos_ref unique (ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='produto_grupos' and column_name='ref_local') then
    alter table produto_grupos add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_produto_grupos_ref') then
    alter table produto_grupos add constraint uq_produto_grupos_ref unique (ref_local);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from information_schema.columns where table_name='subcategorias_financeiras' and column_name='ref_local') then
    alter table subcategorias_financeiras add column ref_local text;
  end if;
  if not exists (select 1 from pg_constraint where conname='uq_subcategorias_financeiras_ref') then
    alter table subcategorias_financeiras add constraint uq_subcategorias_financeiras_ref unique (ref_local);
  end if;
end $$;
