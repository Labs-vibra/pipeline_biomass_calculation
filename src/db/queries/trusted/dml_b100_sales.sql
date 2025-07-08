MERGE INTO `td_ext_anp.venda_b100` AS t
USING (
    SELECT
    DATE(vb100_dt_compra) AS vb100_dt_compra,
    vb100_txt_cnpj,
    vb100_txt_razao_social,
    vb100_qtd_volume / 1000 AS vb100_qtd_volume_1000m3,
    vb100_txt_produtor,
    vb100_txt_produtor_cnpj,
    FROM rw_ext_anp.venda_b100
    WHERE vb100_dt_compra BETWEEN DATE('{{start_date}}') AND DATE('{{end_date}}')
) AS s
ON
  t.vb100_dt_compra = s.vb100_dt_compra AND
  t.vb100_txt_cnpj = s.vb100_txt_cnpj AND
  t.vb100_txt_razao_social = s.vb100_txt_razao_social AND
  t.vb100_txt_produtor = s.vb100_txt_produtor AND
  t.vb100_txt_produtor_cnpj = s.vb100_txt_produtor_cnpj

WHEN MATCHED THEN
  UPDATE SET
    vb100_qtd_volume_1000m3 = s.vb100_qtd_volume_1000m3

WHEN NOT MATCHED THEN INSERT (
    vb100_dt_compra, vb100_txt_cnpj,
    vb100_txt_razao_social,
    vb100_qtd_volume_1000m3,
    vb100_txt_produtor,
    vb100_txt_produtor_cnpj
  )
  VALUES (
    s.vb100_dt_compra,
    s.vb100_txt_cnpj,
    s.vb100_txt_razao_social,
    s.vb100_qtd_volume_1000m3,
    s.vb100_txt_produtor,
    s.vb100_txt_produtor_cnpj
  );
