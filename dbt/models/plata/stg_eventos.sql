-- PLATA · registro de estados de los pedidos (máquina de estados: creado → recogido → entregado / cancelado).
-- Un pedido ocupa varias filas, una por cada cambio de estado. Aquí solo se limpia y se tipa:
--  · un evento_id es único: si el emisor reenviara un evento («al menos una vez»), me quedo con una sola copia;
--  · ts es la hora del evento, la que vale para medir tiempos (no el orden en que aparecen las líneas).
select
    evento_id,
    pedido_id,
    trim(zona)               as zona,
    upper(trim(rider))       as rider,
    lower(trim(estado))      as estado,
    ts::timestamp            as ts
from {{ source('bronce', 'eventos') }}
qualify row_number() over (partition by evento_id order by ts) = 1