CREATE TABLE IF NOT EXISTS rw_ext_anp.venda_b100 (
    vb100_dat_compra DATE,
    vb100_num_cnpj STRING,
    vb100_txt_razao_social STRING,
    vb100_qtd_volume FLOAT64,
    vb100_nom_produtor STRING,
    vb100_num_produtor_cnpj STRING,
    vb100_dat_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
) PARTITION BY DATE(vb100_dat_criacao);