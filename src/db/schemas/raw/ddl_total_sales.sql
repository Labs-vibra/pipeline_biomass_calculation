CREATE TABLE IF NOT EXISTS rw_ext_anp.venda_total (
    vtot_dt_venda DATE,
    vtot_txt_razao_social STRING,
    vtot_txt_base_cnpj STRING,
    vtot_txt_nome_produtor STRING,
    vtot_qtd_volume_1000m3 FLOAT64,
    vtot_txt_produto STRING,
    vtot_txt_origem_regiao STRING,
    vtot_txt_origem_estado STRING,
    vtot_txt_destino_regiao STRING,
    vtot_txt_destino_estado STRING
    vtot_dt_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
) PARTITION BY DATE(vtot_dt_criacao);