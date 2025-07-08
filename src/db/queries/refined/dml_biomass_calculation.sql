WITH
b100_sales AS b (
	SELECT
		insira_aqui_as_colunas_necessarias
	FROM
		td_ext_anp.venda_b100
	WHERE
		veto_dat_venda >= {{start_date}} AND veto_dat_venda <= {{end_date}}
),

total_sales AS t (
	SELECT
		insira_aqui_as_colunas_necessarias
	FROM
		td_ext_anp.venda_total
	WHERE
		veto_dat_venda >= {{start_date}} AND veto_dat_venda <= {{end_date}}
),

venda_congeneres AS v (
	SELECT
		insira_aqui_as_colunas_necessarias
	FROM
		td_ext_anp.venda_congeneres
	WHERE
		veto_dat_venda >= {{start_date}} AND veto_dat_venda <= {{end_date}}
),

biomass_calculation AS bc (
	SELECT
		insira_aqui_as_colunas_necessarias_das_outras_tabelas
)