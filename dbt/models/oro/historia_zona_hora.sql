-- HISTORIA · minutos medios de entrega por zona y hora del día (para el mapa de calor).
select zona, hora, round(avg(min_total), 1) as minutos, count(*) as entregas
from {{ ref('historia_tiempos') }}
group by zona, hora
order by zona, hora
