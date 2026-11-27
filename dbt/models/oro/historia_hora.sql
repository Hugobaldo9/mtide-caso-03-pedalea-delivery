-- HISTORIA · minutos medios de entrega por hora del día: Barrio norte frente al resto de zonas.
select
    hora,
    round(avg(min_total) filter (where zona = 'Barrio norte'), 1)  as barrio_norte,
    round(avg(min_total) filter (where zona <> 'Barrio norte'), 1) as resto_zonas
from {{ ref('historia_tiempos') }}
group by hora
order by hora
