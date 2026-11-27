-- HISTORIA · el terreno en una fila: cifras de contexto del parte y del registro de estados.
select
    (select count(*) from {{ ref('fact_pedidos') }})                         as pedidos,
    (select count(distinct rider) from {{ ref('fact_pedidos') }})            as riders,
    (select count(distinct zona) from {{ ref('fact_pedidos') }})             as zonas,
    (select round(sum(importe_eur), 0) from {{ ref('fact_pedidos') }})       as facturacion,
    (select count(*) from {{ ref('historia_tiempos') }})                     as entregas_registro,
    (select round(avg(min_total), 1) from {{ ref('historia_tiempos') }})     as minutos_medios,
    (select round(median(min_total), 1) from {{ ref('historia_tiempos') }})  as minutos_mediana,
    (select round(100.0 * avg(tarde::int), 1) from {{ ref('historia_tiempos') }}) as pct_tarde_total
