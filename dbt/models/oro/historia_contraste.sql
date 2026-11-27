-- HISTORIA · contraste «sin tratar el giro» frente a «tratado»: % de pedidos por encima de 30 min por zona.
-- Sin tratar: cada pedido se mide de «creado» a su último evento, incluidos los cancelados.
-- Tratado: solo entregados, de «creado» a «entregado» (lo que hace pregunta_4).
with por_pedido as (
    select pedido_id, any_value(zona) as zona,
           min(ts) filter (where estado = 'creado') as creado,
           max(ts)                                   as ultimo
    from {{ ref('stg_eventos') }}
    group by pedido_id
),
sin_tratar as (
    select zona, round(100.0 * avg((date_diff('second', creado, ultimo) / 60.0 > 30)::int), 1) as sin_tratar
    from por_pedido group by zona
),
tratado as (
    select zona, round(100.0 * avg(tarde::int), 1) as tratado
    from {{ ref('historia_tiempos') }} group by zona
)
select zona, sin_tratar, tratado
from sin_tratar join tratado using (zona)
order by tratado desc
