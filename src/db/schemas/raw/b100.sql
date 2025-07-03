CREATE TABLE IF NOT EXISTS rw_ext_anp.rw_ext_anp_b100_sales (
    date DATE,
    company_base_cnpj STRING,
    company_name STRING,
    volume_m3 FLOAT64,
    producer_name STRING,
    producer_cnpj STRING,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
) PARTITION BY DATE(created_at);