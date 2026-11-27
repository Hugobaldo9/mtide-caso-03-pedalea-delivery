-- HISTORIA · pedidos del parte por día (terreno: cuánto trabajo hay cada día).
select fecha, count(*) as pedidos
from {{ ref('fact_pedidos') }}
group by fecha
order by fecha
