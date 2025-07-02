

CREATE TABLE IF NOT EXISTS `named-embassy-456813-f3`.rw_ext_anp.total_sales (
    date DATE,
    month INT64,
    company_name STRING,
    company_base_cnpj STRING,
    producer_name STRING,
    volume_1000m3 FLOAT64,
    product STRING,
    origin_region STRING,
    origin_state STRING,
    destination_region STRING,
    destination_state STRING,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
) PARTITION BY DATE(created_at);