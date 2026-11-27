-- HISTORIA · un pedido entregado por fila, con sus tiempos por tramo (del registro de estados).
-- recoger = de «creado» a «recogido»; reparto = de «recogido» a «entregado»; total = de «creado» a «entregado».
-- Los cancelados no tienen «entregado» y no entran (no cuentan para la promesa).
with por_pedido as (
    select
        pedido_id,
        any_value(zona)                                 as zona,
        any_value(rider)                                as rider,
        min(ts) filter (where estado = 'creado')        as creado,
        min(ts) filter (where estado = 'recogido')      as recogido,
        min(ts) filter (where estado = 'entregado')     as entregado
    from {{ ref('stg_eventos') }}
    group by pedido_id
)
select
    pedido_id,
    zona,
    rider,
    hour(creado)                                              as hora,
    round(date_diff('second', creado, recogido) / 60.0, 1)    as min_recoger,
    round(date_diff('second', recogido, entregado) / 60.0, 1) as min_reparto,
    round(date_diff('second', creado, entregado) / 60.0, 1)   as min_total,
    date_diff('second', creado, entregado) / 60.0 > 30        as tarde
from por_pedido
where creado is not null and entregado is not null
