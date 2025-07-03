CREATE TABLE IF NOT EXISTS rw_ext_anp.venda_b100 (
    vb100_dt_compra DATE,
    vb100_txt_cnpj STRING,
    vb100_txt_razao_social STRING,
    vb100_qtd_volume FLOAT64,
    vb100_txt_produtor STRING,
    vb100_txt_produtor_cnpj STRING,
    vb100_dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
) PARTITION BY DATE(vb100_dt_criacao);