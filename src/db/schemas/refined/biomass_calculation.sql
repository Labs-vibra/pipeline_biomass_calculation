CREATE TABLE IF NOT EXISTS rf_ext_anp.anp_biomass_calculation (
    id INT64,
    date DATE,
    cnpj STRING,
    company_name STRING,
    theoretical_b100_needs FLOAT64,
    liquid_b100_purchases FLOAT64,
    biodiesel_gap FLOAT64,
    stock_variation INT64,
    liquid_b100_gap FLOAT64
) PARTITION BY date;