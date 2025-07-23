MERGE td_ext_anp.venda_congeneres AS target
USING (
SELECT
    periodo AS veco_dat_venda,
    produto AS veco_txt_produto,
    uf_origem AS veco_txt_origem,
    uf_destino AS veco_txt_destino,
    vendedor AS veco_txt_vendedor,
    comprador AS veco_txt_comprador,
    qtd_produto_liquido / 1000000 AS veco_qtd_volume_1000m3
FROM
    rw_ext_anp.venda_congeneres
WHERE
    LOWER(produto) LIKE '%diesel b%'
    AND periodo BETWEEN '{{params.start_date}}' AND '{{params.end_date}}'
    AND data_criacao = (SELECT MAX(data_criacao) FROM rw_ext_anp.venda_congeneres)
) AS source
ON source.veco_dat_venda = target.veco_dat_venda
AND source.veco_txt_produto = target.veco_nom_produto
AND source.veco_txt_origem = target.veco_txt_origem
AND source.veco_txt_destino = target.veco_txt_destino
AND source.veco_txt_vendedor = target.veco_nom_vendedor
AND source.veco_txt_comprador = target.veco_nom_comprador
WHEN MATCHED THEN
UPDATE SET
    veco_qtd_volume_1000m3 = source.veco_qtd_volume_1000m3
WHEN NOT MATCHED THEN
INSERT (
    veco_dat_venda,
    veco_nom_produto,
    veco_txt_origem,
    veco_txt_destino,
    veco_nom_vendedor,
    veco_nom_comprador,
    veco_qtd_volume_1000m3
)
VALUES (
    source.veco_dat_venda,
    source.veco_txt_produto,
    source.veco_txt_origem,
    source.veco_txt_destino,
    source.veco_txt_vendedor,
    source.veco_txt_comprador,
    source.veco_qtd_volume_1000m3
);