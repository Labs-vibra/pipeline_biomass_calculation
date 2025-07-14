  MERGE INTO `td_ext_anp.venda_b100` AS t
  USING (
      SELECT
      vb100_dat_compra,
      vb100_num_cnpj,
      vb100_txt_razao_social,
      vb100_qtd_volume / 1000 AS vb100_qtd_volume_1000m3,
      vb100_nom_produtor,
      vb100_num_produtor_cnpj,
      FROM rw_ext_anp.venda_b100
      WHERE vb100_dat_compra BETWEEN '{{params.start_date}}' AND '{{params.end_date}}'
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
