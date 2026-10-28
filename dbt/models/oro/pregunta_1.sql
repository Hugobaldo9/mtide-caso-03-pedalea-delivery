-- PREGUNTA 1 · ¿Qué zona deja menos ingreso por kilómetro?
-- Ingreso total de la zona dividido entre sus kilómetros totales (metros / 1000). De menor a mayor.
select
    zona,
    round(sum(importe_eur) / (sum(metros) / 1000.0), 3) as ingreso_km,
    count(*)                                           as pedidos,
    round(sum(metros) / 1000.0, 1)                     as km
from {{ ref('fact_pedidos') }}
group by zona
order by ingreso_km