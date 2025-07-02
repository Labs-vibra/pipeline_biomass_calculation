CREATE TABLE IF NOT EXISTS td_ext_anp.td_ext_anp_congeneres_sales (
    date DATE,
    product STRING,
    `from` STRING,
    destination STRING,
    seller STRING,
    buyer STRING,
    volume_1000m3 FLOAT64
) PARTITION BY date;