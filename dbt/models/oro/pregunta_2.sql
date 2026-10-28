-- PREGUNTA 2 · ¿Qué rider gasta más batería por kilómetro?
-- Wh totales del rider divididos entre sus kilómetros totales. De mayor a menor.
select
    rider,
    round(sum(wh_bateria) / (sum(metros) / 1000.0), 2) as wh_km,
    count(*)                                          as pedidos,
    round(sum(metros) / 1000.0, 1)                    as km
from {{ ref('fact_pedidos') }}
group by rider
order by wh_km desc