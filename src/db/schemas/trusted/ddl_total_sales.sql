CREATE TABLE IF NOT EXISTS td_ext_anp.venda_total (
    veto_dat_venda DATE,
    veto_txt_razao_social STRING,
    veto_num_base_cnpj STRING,
    veto_nom_produtor STRING,
    veto_qtd_volume_1000m3 FLOAT64,
    veto_nom_produto STRING,
    veto_txt_origem_regiao STRING,
    veto_txt_origem_estado STRING,
    veto_txt_destino_regiao STRING,
    veto_txt_destino_estado STRING
) PARTITION BY veto_dat_venda;