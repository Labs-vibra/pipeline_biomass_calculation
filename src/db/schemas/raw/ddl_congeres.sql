CREATE TABLE IF NOT EXISTS rw_ext_anp.venda_congeneres (
    veco_dat_venda DATE,
    veco_txt_produto STRING,
    veco_txt_origem STRING,
    veco_txt_destino STRING,
    veco_txt_vendedor STRING,
    veco_txt_comprador STRING,
    veco_qtd_volume_1000m3 FLOAT64,
    veco_dat_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
) PARTITION BY DATE(veco_dat_criacao);
