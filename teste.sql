DECLARE MANDATORY_BIODIESEL_UNTIL_MAR_23 FLOAT64 DEFAULT 0.10;
DECLARE MANDATORY_BIODIESEL_UNTIL_FEB_24 FLOAT64 DEFAULT 0.12; 
DECLARE MANDATORY_BIODIESEL_UNTIL_DEC_25 FLOAT64 DEFAULT 0.14;

WITH
venda_b100 AS (
	SELECT
		vb100_dt_compra AS dat,
		vb100_txt_razao_social AS razao_social,
		SUM(vb100_qtd_volume_1000m3) AS volume_1000m3
	FROM
		td_ext_anp.venda_b100
	WHERE
		vb100_dt_compra >= '2023-01-01'
		AND vb100_dt_compra <= '2023-12-01'
	GROUP BY
		vb100_dt_compra,
		vb100_txt_razao_social
),

venda_total AS (
	SELECT
		veto_dat_venda AS dat,
		veto_txt_razao_social AS razao_social,
		SUM(veto_qtd_volume_1000m3) AS volume_1000m3
	FROM
		td_ext_anp.venda_total
	WHERE
		veto_dat_venda >= '2023-01-01'
		AND veto_dat_venda <= '2023-12-01'
	GROUP BY
		veto_dat_venda,
		veto_txt_razao_social
),

b100_venda_congenere AS (
	SELECT
		veco_dat_venda AS dat,
		veco_nom_vendedor AS razao_social,
		SUM(veco_qtd_volume_1000m3) AS volume_1000m3
	FROM
		td_ext_anp.venda_congeneres
	WHERE
		veco_dat_venda >= '2023-01-01'
		AND veco_dat_venda <= '2023-12-01'
		AND veco_nom_produto = 'BIODIESEL B100'
	GROUP BY
		veco_dat_venda,
		veco_nom_vendedor
),

b100_compra_congenere AS (
	SELECT
		veco_dat_venda AS dat,
		veco_nom_comprador AS razao_social,
		SUM(veco_qtd_volume_1000m3) AS volume_1000m3
	FROM
		td_ext_anp.venda_congeneres
	WHERE
		veco_dat_venda >= '2023-01-01'
		AND veco_dat_venda <= '2023-12-01'
		AND veco_nom_produto = 'BIODIESEL B100'
	GROUP BY
		veco_dat_venda,
		veco_nom_comprador	
),

dieselb_venda_congenere AS (
	SELECT
		veco_dat_venda AS dat,
		veco_nom_vendedor AS razao_social,
		SUM(veco_qtd_volume_1000m3) AS volume_1000m3
	FROM
		td_ext_anp.venda_congeneres
	WHERE
		veco_dat_venda >= '2023-01-01'
		AND veco_dat_venda <= '2023-12-01'
		AND veco_nom_produto <> 'BIODIESEL B100'
	GROUP BY
		veco_dat_venda,
		veco_nom_vendedor
),

dieselb_compra_congenere AS (
	SELECT
		veco_dat_venda as dat,
		veco_nom_comprador AS razao_social,
		SUM(veco_qtd_volume_1000m3) AS volume_1000m3,
	FROM
		td_ext_anp.venda_congeneres
	WHERE
		veco_dat_venda >= '2023-01-01'
		AND veco_dat_venda <= '2023-12-01'
		AND veco_nom_produto <> 'BIODIESEL B100'
	GROUP BY
		veco_dat_venda,
		veco_nom_comprador
),

todas_datas_empresas AS (
	SELECT DISTINCT
		dat,
		razao_social,
	FROM (
    SELECT dat, razao_social FROM venda_b100
    UNION DISTINCT
    SELECT dat, razao_social FROM venda_total
    UNION DISTINCT
    SELECT dat, razao_social FROM b100_venda_congenere
    UNION DISTINCT
    SELECT dat, razao_social FROM b100_compra_congenere
    UNION DISTINCT
    SELECT dat, razao_social FROM dieselb_venda_congenere
    UNION DISTINCT
    SELECT dat, razao_social FROM dieselb_compra_congenere
  )
),

dados_consolidados AS (
	SELECT
		tde.dat,
		tde.razao_social,
		COALESCE(vb.volume_1000m3, 0) AS b100_venda_volume_1000m3,
		COALESCE(vt.volume_1000m3, 0) AS venda_total_volume_1000m3,
		COALESCE(bvc.volume_1000m3, 0) AS b100_venda_congenere_volume_1000m3,
		COALESCE(bcc.volume_1000m3, 0) AS b100_compra_congenere_volume_1000m3,
		COALESCE(dvc.volume_1000m3, 0) AS dieselb_venda_congenere_volume_1000m3,
		COALESCE(dcc.volume_1000m3, 0) AS dieselb_compra_congenere_volume_1000m3
	FROM
		todas_datas_empresas tde
	LEFT JOIN venda_b100 vb ON tde.dat = vb.dat AND tde.razao_social = vb.razao_social
	LEFT JOIN venda_total vt ON tde.dat = vt.dat AND tde.razao_social = vt.razao_social
	LEFT JOIN b100_venda_congenere bvc ON tde.dat = bvc.dat AND tde.razao_social = bvc.razao_social
	LEFT JOIN b100_compra_congenere bcc ON tde.dat = bcc.dat AND tde.razao_social = bcc.razao_social
	LEFT JOIN dieselb_venda_congenere dvc ON tde.dat = dvc.dat AND tde.razao_social = dvc.razao_social
	LEFT JOIN dieselb_compra_congenere dcc ON tde.dat = dcc.dat AND tde.razao_social = dcc.razao_social
),

necessidade_teorica_b100 AS (
	SELECT
	dat,
	razao_social,
	(venda_total_volume_1000m3 + dieselb_compra_congenere_volume_1000m3 - dieselb_venda_congenere_volume_1000m3) * 
    CASE 
      WHEN EXTRACT(YEAR FROM dat) = 2023 AND EXTRACT(MONTH FROM dat) <= 3 
        THEN MANDATORY_BIODIESEL_UNTIL_MAR_23
      WHEN EXTRACT(YEAR FROM dat) = 2023 AND EXTRACT(MONTH FROM dat) > 3 
        THEN MANDATORY_BIODIESEL_UNTIL_FEB_24
      WHEN EXTRACT(YEAR FROM dat) = 2024 AND EXTRACT(MONTH FROM dat) <= 2 
        THEN MANDATORY_BIODIESEL_UNTIL_FEB_24
      WHEN EXTRACT(YEAR FROM dat) = 2024 AND EXTRACT(MONTH FROM dat) > 2 
        THEN MANDATORY_BIODIESEL_UNTIL_DEC_25
      ELSE MANDATORY_BIODIESEL_UNTIL_DEC_25
    END AS necessidade_teorica_b100,
    
  	FROM
		dados_consolidados
),

compra_liquida_b100 AS (
	SELECT
		dat,
		razao_social,
		(b100_venda_volume_1000m3 + b100_compra_congenere_volume_1000m3 - b100_venda_congenere_volume_1000m3) AS compra_liquida_b100
	FROM
		dados_consolidados
)

SELECT
	clb.dat,
	clb.razao_social,
	clb.compra_liquida_b100,
	ntb.necessidade_teorica_b100,
	(ntb.necessidade_teorica_b100 - clb.compra_liquida_b100) AS gap_biodiesel,
	0 AS variacao_estoque,
	(ntb.necessidade_teorica_b100 - clb.compra_liquida_b100) + 0 AS gap_liquido
FROM 
	compra_liquida_b100 clb
JOIN
	necessidade_teorica_b100 ntb ON clb.dat = ntb.dat AND clb.razao_social = ntb.razao_social