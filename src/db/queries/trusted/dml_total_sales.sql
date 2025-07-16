MERGE td_ext_anp.venda_total AS target
USING (
  SELECT
    data_venda AS veto_dat_venda,
    agente_regulado AS veto_txt_razao_social,
    descricao_do_produto AS veto_txt_produto,
    SUM(quantidade_de_produto_mil_m3) AS veto_qtd_volume_1000m3,
    mercado_destinatario AS veto_txt_mercado_destino,
    uf_destino AS veto_txt_destino_estado,
    regiao_origem AS veto_txt_origem_regiao,
    uf_origem AS veto_txt_origem_estado,
    regiao_destinatario AS veto_txt_destino_regiao,
    nome_do_produto AS veto_txt_nome_produto,
    codigo_do_produto AS veto_txt_codigo_produto,
  FROM
    rw_ext_anp.venda_total
  WHERE
    descricao_do_produto LIKE '%DIESEL B%'
    AND NOT (
      LOWER(descricao_do_produto) LIKE '%diesel b15%'
      OR LOWER(descricao_do_produto) LIKE '%diesel b2%'
      OR LOWER(descricao_do_produto) LIKE '%energia elétrica%'
      OR LOWER(descricao_do_produto) LIKE '%rodoviário%'
    )
    AND data_venda >= '{{params.start_date}}'
    AND data_venda <= '{{params.end_date}}'
    GROUP BY
    data_venda,
    agente_regulado,
    descricao_do_produto,
    mercado_destinatario,
    uf_destino,
    regiao_origem,
    uf_origem,
    regiao_destinatario,
    nome_do_produto,
    codigo_do_produto
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