CREATE TABLE IF NOT EXISTS td_ext_anp.total_sales (
    date DATE,
    company_name STRING,
    company_base_cnpj STRING,
    producer_name STRING,
    volume_1000m3 FLOAT64,
    product STRING,
    origin_region STRING,
    origin_state STRING,
    destination_region STRING,
    destination_state STRING
) PARTITION BY date;