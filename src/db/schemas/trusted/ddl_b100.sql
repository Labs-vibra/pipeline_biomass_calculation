CREATE TABLE IF NOT EXISTS td_ext_anp.venda_b100 (
    vb100_dat_compra DATE,
    vb100_num_cnpj STRING,
    vb100_txt_razao_social STRING,
    vb100_qtd_volume_1000m3 FLOAT64,
    vb100_nom_produtor STRING,
    vb100_num_produtor_cnpj STRING
) PARTITION BY vb100_dat_compra;