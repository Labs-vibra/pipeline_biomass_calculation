MERGE INTO `td_ext_anp.venda_b100` AS t
  USING (
      SELECT
      data_compra AS vb100_dat_compra,
      raiz_cnpj_distribuidor AS vb100_num_cnpj,
      razao_social_distribuidor AS vb100_txt_razao_social,
      qtd_de_produto_m3 / 1000 AS vb100_qtd_volume_1000m3,
      razao_social_produtor AS vb100_nom_produtor,
      cnpj_produtor AS vb100_num_produtor_cnpj,
      FROM rw_ext_anp.venda_b100
      WHERE data_compra BETWEEN '2023-01-01' AND '2025-12-31'
  ) AS s
  ON
    t.vb100_dat_compra = s.vb100_dat_compra AND
    t.vb100_num_cnpj = s.vb100_num_cnpj AND
    t.vb100_txt_razao_social = s.vb100_txt_razao_social AND
    t.vb100_nom_produtor = s.vb100_nom_produtor AND
    t.vb100_num_produtor_cnpj = s.vb100_num_produtor_cnpj

  WHEN MATCHED THEN
    UPDATE SET
      vb100_qtd_volume_1000m3 = s.vb100_qtd_volume_1000m3

  WHEN NOT MATCHED THEN INSERT (
      vb100_dat_compra, vb100_num_cnpj,
      vb100_txt_razao_social,
      vb100_qtd_volume_1000m3,
      vb100_nom_produtor,
      vb100_num_produtor_cnpj
    )
    VALUES (
      s.vb100_dat_compra,
      s.vb100_num_cnpj,
      s.vb100_txt_razao_social,
      s.vb100_qtd_volume_1000m3,
      s.vb100_nom_produtor,
      s.vb100_num_produtor_cnpj
    );