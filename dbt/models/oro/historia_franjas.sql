-- HISTORIA · Barrio norte antes y después de las 14 h: la cifra del titular.
select
    case when hora < 14 then 'antes de las 14 h' else 'desde las 14 h' end            as franja,
    count(*) filter (where zona = 'Barrio norte')                                      as entregas_bn,
    round(100.0 * avg(tarde::int) filter (where zona = 'Barrio norte'), 1)            as pct_tarde_bn,
    round(avg(min_total) filter (where zona = 'Barrio norte'), 1)                      as minutos_bn,
    round(avg(min_total) filter (where zona <> 'Barrio norte'), 1)                     as minutos_resto
from {{ ref('historia_tiempos') }}
group by franja
order by franja desc
