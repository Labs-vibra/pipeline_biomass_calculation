CREATE OR REPLACE TABLE td_ext_biomass_calculation.td_ext_anp_total_sales
PARTITION BY DATE(date)
AS
SELECT
	DATE(date) AS date,
	company_name,
  	product,
  	CAST(REPLACE(volume_1000m3, ',', '.') AS FLOAT64) AS volume_1000m3,
  	target_market,
  	destination_state,
  	origin_region,
  	origin_state,
  	destination_region,
  	product_name,
  	EXTRACT(MONTH FROM DATE(date)) AS month
FROM
	rw_ext_biomass_calculation.rw_ext_anp_total_sales
WHERE
  	product LIKE '%DIESEL B%'
  	AND NOT (
    	LOWER(product) LIKE '%diesel b20%'
    	OR LOWER(product) LIKE '%diesel b15%'
    	OR LOWER(product) LIKE '%diesel b2%'
  	)
  	AND date >= {{start_date}} AND date <= {{end_date}}
