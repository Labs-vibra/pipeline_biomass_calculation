CREATE TABLE IF NOT EXISTS rf_ext_anp.calculo_biomassa (
    cabi_dat_calculo DATE,
    cabi_num_base_cnpj STRING,
    cabi_txt_razao_social STRING,
    cabi_qtd_necessidade_teorica_b100 FLOAT64,
    cabi_qtd_compra_liq_b100 FLOAT64,
    cabi_qtd_dif_biodiesel FLOAT64,
    cabi_qtd_estoque INT64,
    cabi_qtd_gap_liq_b100 FLOAT64
) PARTITION BY cabi_dat_calculo;