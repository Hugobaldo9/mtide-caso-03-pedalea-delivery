-- PREGUNTA 3 · ¿Qué bici acumula más incidencias por cada 100 km?
-- Pedidos con incidencia × 100 / kilómetros recorridos por la bici. De mayor a menor.
select
    bici,
    round(100.0 * count(*) filter (where con_incidencia) / (sum(metros) / 1000.0), 2) as incidencias_100km,
    count(*) filter (where con_incidencia)                                           as incidencias,
    count(*)                                                                         as pedidos,
    round(sum(metros) / 1000.0, 1)                                                   as km
from {{ ref('fact_pedidos') }}
group by bici
order by incidencias_100km desc