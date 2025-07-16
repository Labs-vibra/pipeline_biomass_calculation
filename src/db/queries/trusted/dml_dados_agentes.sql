MERGE td_ext_anp.dados_agentes AS target
USING (
  SELECT
	cod_agente_anp,
	raiz_cnpj,
	razao_social,
	cep,
	endereco,
	bairro,
	municipio,
	estado,
	tipo_do_agente,
	data_inicio_validade,
	data_final_validade
  FROM
	rw_ext_anp.dados_agentes
) AS source
ON target.cod_agente_anp = source.cod_agente_anp
   AND target.raiz_cnpj = source.raiz_cnpj
WHEN MATCHED THEN
  UPDATE SET
	razao_social = source.razao_social,
	cep = source.cep,
	endereco = source.endereco,
	bairro = source.bairro,
	municipio = source.municipio,
	estado = source.estado,
	tipo_do_agente = source.tipo_do_agente,
	data_inicio_validade = source.data_inicio_validade,
	data_final_validade = source.data_final_validade
WHEN NOT MATCHED THEN
  INSERT (
	cod_agente_anp,
	raiz_cnpj,
	razao_social,
	cep,
	endereco,
	bairro,
	municipio,
	estado,
	tipo_do_agente,
	data_inicio_validade,
	data_final_validade
  ) VALUES (
	source.cod_agente_anp,
	source.raiz_cnpj,
	source.razao_social,
	source.cep,
	source.endereco,
	source.bairro,
	source.municipio,
	source.estado,
	source.tipo_do_agente,
	source.data_inicio_validade,
	source.data_final_validade
  );