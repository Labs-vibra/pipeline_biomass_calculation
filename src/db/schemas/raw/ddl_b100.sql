CREATE TABLE IF NOT EXISTS rw_ext_anp.venda_b100 (
    data_compra DATE,
    raiz_cnpj_distribuidor STRING,
    razao_social_distribuidor STRING,
    qtd_de_produto_m3 FLOAT64,
    razao_social_produtor STRING,
    cnpj_produtor STRING,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
) PARTITION BY DATE(data_criacao);