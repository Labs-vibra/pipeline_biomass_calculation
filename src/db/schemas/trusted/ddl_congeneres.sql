CREATE TABLE IF NOT EXISTS td_ext_anp.venda_congeneres (
    cgnrs_dt_venda DATE,
    cgnrs_txt_produto STRING,
    cgnrs_txt_origem STRING,
    cgnrs_txt_destino STRING,
    cgnrs_txt_vendedor STRING,
    cgnrs_txt_comprador STRING,
    cgnrs_qtd_volume_1000m3 FLOAT64
) PARTITION BY cgnrs_dt_venda;