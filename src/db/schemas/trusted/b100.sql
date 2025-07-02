CREATE TABLE IF NOT EXISTS td_ext_anp.b100_sales (
    date DATE,
    company_base_cnpj STRING,
    company_name STRING,
    volume_1000m3 FLOAT64,
    producer_name STRING,
    producer_cnpj STRING
) PARTITION BY date;