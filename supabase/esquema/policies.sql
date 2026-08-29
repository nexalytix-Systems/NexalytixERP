-- ==========================================================

-- Políticas de RLS — isolamento por empresa

-- ==========================================================


create or replace function minha_empresa()
returns uuid
language sql stable
security definer
set search_path = public
as $$
  select empresa_id from perfis where id = auth.uid()
$$;


create policy "empresa ve so a si mesma" on empresas
  for select using (id = minha_empresa());
create policy "perfis mesma empresa" on perfis
  for select using (empresa_id = minha_empresa());
create policy "perfis atualiza o proprio" on perfis
  for update using (id = auth.uid());
create policy "log leitura mesma empresa" on log_alteracoes
  for select using (empresa_id = minha_empresa());

create policy "acertos mesma empresa" on acertos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "areas_entrega mesma empresa" on areas_entrega
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "areas_zonas mesma empresa" on areas_zonas
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "baixas_pendentes mesma empresa" on baixas_pendentes
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "bases_catalogo mesma empresa" on bases_catalogo
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "caixa_movimentos mesma empresa" on caixa_movimentos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "caixas mesma empresa" on caixas
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "cancelamentos mesma empresa" on cancelamentos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "cardapio_config mesma empresa" on cardapio_config
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "categorias mesma empresa" on categorias
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "categorias_financeiras mesma empresa" on categorias_financeiras
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "clientes mesma empresa" on clientes
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "clientes_parceiros mesma empresa" on clientes_parceiros
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "compras_sem_vinculo mesma empresa" on compras_sem_vinculo
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "config_loja mesma empresa" on config_loja
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "config_operacao mesma empresa" on config_operacao
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "contagens_estoque mesma empresa" on contagens_estoque
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "contas_capital mesma empresa" on contas_capital
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "cupom_usos mesma empresa" on cupom_usos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "cupons mesma empresa" on cupons
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "cupons_fiscais mesma empresa" on cupons_fiscais
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "entregador_taxas mesma empresa" on entregador_taxas
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "entregadores mesma empresa" on entregadores
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "estoque_unidade mesma empresa" on estoque_unidade
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "fiado_movimentos mesma empresa" on fiado_movimentos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "ficha_grupos mesma empresa" on ficha_grupos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "ficha_itens mesma empresa" on ficha_itens
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "fichas_tecnicas mesma empresa" on fichas_tecnicas
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "formas_pagamento mesma empresa" on formas_pagamento
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "fornecedores mesma empresa" on fornecedores
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "grupos_ingredientes mesma empresa" on grupos_ingredientes
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "grupos_opcoes mesma empresa" on grupos_opcoes
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "insumos mesma empresa" on insumos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "lancamentos_financeiros mesma empresa" on lancamentos_financeiros
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "mesa_comandas mesma empresa" on mesa_comandas
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "mesas mesma empresa" on mesas
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "modelos_impressao mesma empresa" on modelos_impressao
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "motivos_cancelamento mesma empresa" on motivos_cancelamento
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "motivos_movimentacao mesma empresa" on motivos_movimentacao
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "movimentacoes_estoque mesma empresa" on movimentacoes_estoque
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "notas_entrada mesma empresa" on notas_entrada
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "opcoes mesma empresa" on opcoes
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "ordens_producao mesma empresa" on ordens_producao
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "pedido_base_itens mesma empresa" on pedido_base_itens
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "pedido_itens mesma empresa" on pedido_itens
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "pedido_pagamentos mesma empresa" on pedido_pagamentos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "pedidos mesma empresa" on pedidos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "pedidos_base mesma empresa" on pedidos_base
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "produto_grupos mesma empresa" on produto_grupos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "produtos mesma empresa" on produtos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "status_venda mesma empresa" on status_venda
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "subcategorias_financeiras mesma empresa" on subcategorias_financeiras
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "sucursais mesma empresa" on sucursais
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "transferencias mesma empresa" on transferencias
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "turnos mesma empresa" on turnos
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "unidades_medida mesma empresa" on unidades_medida
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());

create policy "usuarios_sistema mesma empresa" on usuarios_sistema
  for all using (empresa_id = minha_empresa())
  with check (empresa_id = minha_empresa());
