CREATE TABLE IF NOT EXISTS rw_ext_anp.congeneres_sales (
    date DATE,
    product STRING,
    `from` STRING,
    destination STRING,
    seller STRING,
    buyer STRING,
    volume_m3 FLOAT64,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
) PARTITION BY DATE(created_at);
