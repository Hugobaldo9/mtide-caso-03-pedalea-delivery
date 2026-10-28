-- PREGUNTA 4 · ¿Qué zona incumple más la promesa de 30 minutos (de «creado» a «entregado»)? ¿Cuánto tarda de media?
-- El giro: el registro es una máquina de estados, así que un pedido ocupa varias filas.
--  1) por_pedido: llevo el registro al nivel PEDIDO, juntando su «creado» y su «entregado» (hora del evento, ts).
--     Los cancelados no tienen «entregado»: no cuentan para la promesa.
--  2) por_zona: llevo los pedidos al nivel ZONA (tiempo medio, cuántos llegan tarde).
--  3) Solo entonces cruzo con el catálogo (una fila por zona) para traer la promesa: así no se multiplican filas.
with por_pedido as (
    select
        pedido_id,
        any_value(zona)                                    as zona,
        min(ts) filter (where estado = 'creado')           as creado,
        min(ts) filter (where estado = 'entregado')        as entregado
    from {{ ref('stg_eventos') }}
    group by pedido_id
),
entregados as (
    select zona, date_diff('second', creado, entregado) / 60.0 as minutos
    from por_pedido
    where creado is not null and entregado is not null
),
por_zona as (
    select zona, count(*) as entregados, avg(minutos) as minutos_medios, max(minutos) as minutos_max,
           list(minutos) as tiempos
    from entregados
    group by zona
)
select
    p.zona,
    round(100.0 * len(list_filter(p.tiempos, t -> t > z.promesa_min)) / p.entregados, 1) as pct_incumple,
    len(list_filter(p.tiempos, t -> t > z.promesa_min))                                  as fuera_de_plazo,
    p.entregados,
    round(p.minutos_medios, 1)                                                            as minutos_medios,
    round(p.minutos_max, 1)                                                               as minutos_max,
    z.promesa_min
from por_zona p
join {{ ref('stg_zonas') }} z using (zona)
order by pct_incumple desc, minutos_medios desc