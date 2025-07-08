MERGE td_ext_anp.venda_total AS target
USING (
  SELECT
    veto_dat_venda,
    veto_txt_razao_social,
    veto_txt_produto,
    SUM(veto_qtd_volume_1000m3) AS veto_qtd_volume_1000m3,
    veto_txt_mercado_destino,
    veto_txt_destino_estado,
	veto_txt_origem_regiao,
    veto_txt_origem_estado,
	veto_txt_destino_regiao,
    veto_txt_nome_produto,
    veto_txt_codigo_produto,
  FROM
    rw_ext_anp.venda_total
  WHERE
    veto_txt_produto LIKE '%DIESEL B%'
    AND NOT (
      LOWER(veto_txt_produto) LIKE '%diesel b15%'
      OR LOWER(veto_txt_produto) LIKE '%diesel b2%'
    )
    AND veto_dat_venda >= {{start_date}} AND veto_dat_venda <= {{end_date}}
	-- AND veto_dat_venda >= "2024-01-01" AND veto_dat_venda <= "2024-12-01"
	GROUP BY
	veto_dat_venda,
	veto_txt_razao_social,
	veto_txt_produto,
	veto_txt_mercado_destino,
	veto_txt_destino_estado,
	veto_txt_origem_regiao,
	veto_txt_origem_estado,
	veto_txt_destino_regiao,
	veto_txt_nome_produto,
	veto_txt_codigo_produto
) AS source
ON target.veto_dat_venda = source.veto_dat_venda 
   AND target.veto_txt_razao_social = source.veto_txt_razao_social 
   AND target.veto_txt_produto = source.veto_txt_produto
   AND target.veto_txt_mercado_destino = source.veto_txt_mercado_destino
   AND target.veto_txt_destino_estado = source.veto_txt_destino_estado
   AND target.veto_txt_origem_estado = source.veto_txt_origem_estado
WHEN MATCHED THEN
  UPDATE SET
    veto_qtd_volume_1000m3 = source.veto_qtd_volume_1000m3
WHEN NOT MATCHED THEN
  INSERT (
    veto_dat_venda,
    veto_txt_razao_social,
    veto_txt_produto,
    veto_qtd_volume_1000m3,
    veto_txt_mercado_destino,
    veto_txt_destino_estado,
    veto_txt_origem_regiao,
    veto_txt_origem_estado,
    veto_txt_destino_regiao,
    veto_txt_nome_produto,
    veto_txt_codigo_produto
  )
  VALUES (
    source.veto_dat_venda,
    source.veto_txt_razao_social,
    source.veto_txt_produto,
    source.veto_qtd_volume_1000m3,
    source.veto_txt_mercado_destino,
    source.veto_txt_destino_estado,
    source.veto_txt_origem_regiao,
    source.veto_txt_origem_estado,
    source.veto_txt_destino_regiao,
    source.veto_txt_nome_produto,
    source.veto_txt_codigo_produto
  );