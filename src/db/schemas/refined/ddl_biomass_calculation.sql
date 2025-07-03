CREATE TABLE IF NOT EXISTS rf_ext_anp.calculo_biomassa (
    cb_dt_calculo DATE,
    cb_txt_base_cnpj STRING,
    cb_txt_razao_social STRING,
    cb_qtd_necessidade_teorica_b100 FLOAT64,
    cb_qtd_compra_liq_b100 FLOAT64,
    cb_qtd_dif_biodiesel FLOAT64,
    cb_qtd_estoque INT64,
    cb_qtd_gap_liq_b100 FLOAT64
) PARTITION BY tot_dt_balanco;