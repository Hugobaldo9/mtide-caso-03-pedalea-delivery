-- HISTORIA · dónde se va el tiempo en cada zona: minutos medios de recogida y de reparto.
select
    zona,
    round(avg(min_recoger), 1) as recoger,
    round(avg(min_reparto), 1) as reparto,
    round(avg(min_total), 1)   as total
from {{ ref('historia_tiempos') }}
group by zona
order by reparto desc
