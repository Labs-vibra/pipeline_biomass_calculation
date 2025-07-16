MERGE td_ext_anp.venda_congeneres AS target
USING (
  SELECT
    periodo AS veco_dat_venda,
    produto AS veco_txt_produto,
    uf_origem AS veco_txt_origem,
    uf_destino AS veco_txt_destino,
    vendedor AS veco_txt_vendedor,
    comprador AS veco_txt_comprador,
    qtd_produto_liquido / 1000000 AS veco_qtd_volume_1000m3,
  FROM
    rw_ext_anp.venda_congeneres
  WHERE
    LOWER(produto) LIKE '%diesel b%'
    AND periodo BETWEEN '{{params.start_date}}' AND '{{params.end_date}}'
) AS source
ON target.veco_dat_venda = source.veco_dat_venda 
   AND target.veco_nom_produto = source.veco_txt_produto
   AND target.veco_txt_origem = source.veco_txt_origem
   AND target.veco_txt_destino = source.veco_txt_destino
   AND target.veco_nom_vendedor = source.veco_txt_vendedor
   AND target.veco_nom_comprador = source.veco_txt_comprador
WHEN MATCHED THEN
  UPDATE SET
    veco_qtd_volume_1000m3 = source.veco_qtd_volume_1000m3
WHEN NOT MATCHED THEN
  INSERT (
    veco_dat_venda,
    veco_nom_produto,
    veco_txt_origem,
    veco_txt_destino,
    veco_nom_vendedor,
    veco_nom_comprador,
    veco_qtd_volume_1000m3
  )
  VALUES (
    source.veco_dat_venda,
    source.veco_txt_produto,
    source.veco_txt_origem,
    source.veco_txt_destino,
    source.veco_txt_vendedor,
    source.veco_txt_comprador,
    source.veco_qtd_volume_1000m3
  );