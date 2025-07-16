CREATE TABLE IF NOT EXISTS rw_ext_anp.venda_total (
    data_venda DATE,
    veto_txt_razao_social STRING,
    quantidade_de_produto_mil_m3 FLOAT64,
    descricao_do_produto STRING,
    regiao_origem STRING,
    uf_origem STRING,
    regiao_destinatario STRING,
    uf_destino STRING,
    mercado_destinatario STRING,
    codigo_do_produto INTEGER,
    nome_do_produto STRING,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
) PARTITION BY DATE(data_criacao);