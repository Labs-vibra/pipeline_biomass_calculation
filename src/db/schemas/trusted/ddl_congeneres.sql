CREATE TABLE IF NOT EXISTS td_ext_anp.venda_congeneres (
    veco_dat_venda DATE,
    veco_nom_produto STRING,
    veco_txt_origem STRING,
    veco_txt_destino STRING,
    veco_nom_vendedor STRING,
    veco_nom_comprador STRING,
    veco_qtd_volume_1000m3 FLOAT64
) PARTITION BY veco_dat_venda;