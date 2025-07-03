CREATE TABLE IF NOT EXISTS td_ext_anp.venda_b100 (
    b100s_dt_compra DATE,
    b100s_txt_cnpj STRING,
    b100s_txt_razao_social STRING,
    b100s_qtd_volume_1000m3 FLOAT64,
    b100s_txt_produtor STRING,
    b100s_txt_produtor_cnpj STRING
) PARTITION BY b100s_dt_compra;