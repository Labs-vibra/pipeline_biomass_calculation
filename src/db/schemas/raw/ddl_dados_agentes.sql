CREATE TABLE IF NOT EXISTS rw_ext_anp.dados_agentes (
    cod_agente_anp INTEGER,
    raiz_cnpj STRING,
    razao_social STRING,
    cep INTEGER,
    endereco STRING,
    bairro STRING,
    municipio STRING,
    estado STRING,
    tipo_do_agente STRING,
    data_inicio_validade INTEGER,
    data_final_validade FLOAT64,
    data_versao DATE,
    data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);