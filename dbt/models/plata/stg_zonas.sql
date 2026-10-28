-- PLATA · catálogo de zonas de reparto: una fila por zona, con su código postal y la promesa de entrega.
select
    trim(zona)                   as zona,
    codigo_postal::varchar       as codigo_postal,
    promesa_min::integer         as promesa_min
from {{ source('bronce', 'zonas') }}
