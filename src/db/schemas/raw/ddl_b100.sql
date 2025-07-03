CREATE TABLE IF NOT EXISTS rw_ext_anp.venda_b100 (
    b100s_dt_compra DATE,
    b100s_txt_cnpj STRING,
    b100s_txt_razao_social STRING,
    b100s_qtd_volume FLOAT64,
    b100s_txt_produtor STRING,
    b100s_txt_produtor_cnpj STRING,
    b100s_dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
) PARTITION BY DATE(b100s_dt_criacao);