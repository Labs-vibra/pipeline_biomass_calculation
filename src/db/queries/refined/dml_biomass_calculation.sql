WITH
b100_sales AS b (
	SELECT
		vb100_dat_compra,
		vb100_txt_razao_social,
		vb100_qtd_volume_1000m3
	FROM
		td_ext_anp.venda_b100
	WHERE
		vb100_dat_compra >= {{params.start_date}} AND vb100_dat_compra <= {{params.end_date}}
),

total_sales AS t (
	SELECT
		veto_dat_venda,
		veto_txt_razao_social,
		veto_qtd_volume_1000m3,
		
	FROM
		td_ext_anp.venda_total
	WHERE
		veto_dat_venda >= {{params.start_date}} AND veto_dat_venda <= {{params.end_date}}
),

venda_congeneres AS v (
	SELECT
		veco_dat_venda,
	FROM
		td_ext_anp.venda_congeneres
	WHERE
		veto_dat_venda >= {{params.start_date}} AND veto_dat_venda <= {{params.end_date}}
),

biomass_calculation AS bc (
	SELECT
		insira_aqui_as_colunas_necessarias_das_outras_tabelas
)