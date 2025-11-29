
-- 1) Não entrega: Contagem de pedidos por status
SELECT
    ord_stt AS status_pedido,
    COUNT(DISTINCT "SRK_ord") AS total_pedidos
FROM
    DW.DIM_ORD
GROUP BY
    ord_stt
ORDER BY
    total_pedidos DESC;


-- 2) Estoque: Total de vendas por mês
SELECT
    dim_dat.mes AS mes,
    COUNT(fat."SRK_ord_its") AS total_vendas,
    SUM(fat.val) AS receita_total
FROM 
    DW.FAT_ITS_ORD AS fat
JOIN 
    DW.DIM_DAT AS dim_dat 
    ON fat."SRK_dat_ord" = dim_dat."SRK_dat"
GROUP BY 
    dim_dat.mes
ORDER BY 
    dim_dat.mes;


-- 3) BCG: Top categorias por receita
SELECT
    dim_prd.prd_cat_nam AS categoria_produto,
    COUNT(fat."SRK_ord_its") AS total_vendas,
    SUM(fat.val) AS receita_total
FROM
    DW.FAT_ITS_ORD AS fat
JOIN
    DW.DIM_PRD AS dim_prd 
    ON fat."SRK_prd" = dim_prd."SRK_prd"
WHERE
    dim_prd.prd_cat_nam IS NOT NULL
GROUP BY
    dim_prd.prd_cat_nam
ORDER BY
    receita_total DESC;


-- 4) Funnel: Contagem de pedidos cancelados
SELECT
    COUNT(DISTINCT "SRK_ord") AS total_pedidos_cancelados,
    SUM(val_tot_pay) AS valor_perdido
FROM
    DW.DIM_ORD
WHERE
    ord_stt = 'canceled';


-- 5) UF destino: Tempo médio de entrega por estado
SELECT
    cli_sta AS estado_cliente,
    AVG(tem_de_env_dia) AS tempo_medio_entrega_dias,
    COUNT(DISTINCT "SRK_ord") AS total_pedidos
FROM
    DW.DIM_ORD
WHERE
    cli_sta IS NOT NULL
    AND tem_de_env_dia IS NOT NULL
GROUP BY
    cli_sta
ORDER BY
    tempo_medio_entrega_dias DESC;


-- 6) Receita total por estado do cliente
SELECT
    dim_ord.cli_sta AS estado_cliente,
    COUNT(fat."SRK_ord_its") AS total_itens_vendidos,
    SUM(fat.val) AS receita_total
FROM
    DW.FAT_ITS_ORD AS fat
JOIN
    DW.DIM_ORD AS dim_ord 
    ON fat."SRK_ord" = dim_ord."SRK_ord"
WHERE
    dim_ord.cli_sta IS NOT NULL
GROUP BY
    dim_ord.cli_sta
ORDER BY
    receita_total DESC;


-- 7) Receita total por estado do vendedor
SELECT
    dim_vnd.vnd_sta AS estado_vendedor,
    COUNT(fat."SRK_ord_its") AS total_vendas,
    SUM(fat.val) AS receita_total
FROM
    DW.FAT_ITS_ORD AS fat
JOIN
    DW.DIM_VND AS dim_vnd 
    ON fat."SRK_vnd" = dim_vnd."SRK_vnd"
WHERE
    dim_vnd.vnd_sta IS NOT NULL
GROUP BY
    dim_vnd.vnd_sta
ORDER BY
    receita_total DESC;


-- 8) Score médio de avaliação por categoria
SELECT
    dim_prd.prd_cat_nam AS categoria_produto,
    AVG(dim_ord.rev_sco) AS score_medio,
    COUNT(DISTINCT dim_ord."SRK_ord") AS total_avaliacoes
FROM
    DW.FAT_ITS_ORD AS fat
JOIN
    DW.DIM_PRD AS dim_prd 
    ON fat."SRK_prd" = dim_prd."SRK_prd"
JOIN
    DW.DIM_ORD AS dim_ord 
    ON fat."SRK_ord" = dim_ord."SRK_ord"
WHERE
    dim_prd.prd_cat_nam IS NOT NULL
    AND dim_ord.rev_sco IS NOT NULL
GROUP BY
    dim_prd.prd_cat_nam
ORDER BY
    score_medio DESC;


-- 9) Métodos de pagamento mais utilizados
SELECT
    pri_pay_typ AS tipo_pagamento,
    COUNT(DISTINCT "SRK_ord") AS total_pedidos,
    SUM(val_tot_pay) AS valor_total_pago
FROM
    DW.DIM_ORD
WHERE
    pri_pay_typ IS NOT NULL
GROUP BY
    pri_pay_typ
ORDER BY
    total_pedidos DESC;


-- 10) Total de vendas por ano
SELECT
    dim_dat.ano AS ano,
    COUNT(fat."SRK_ord_its") AS total_vendas,
    SUM(fat.val) AS receita_total,
    SUM(fat.frt_val) AS receita_frete
FROM 
    DW.FAT_ITS_ORD AS fat
JOIN 
    DW.DIM_DAT AS dim_dat 
    ON fat."SRK_dat_ord" = dim_dat."SRK_dat"
WHERE 
    dim_dat.ano IS NOT NULL
GROUP BY 
    dim_dat.ano
ORDER BY 
    dim_dat.ano;