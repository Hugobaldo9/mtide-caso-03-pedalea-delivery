-- wh_bateria tiene que estar en un rango creíble para este negocio (6.5 a 172.8).
select pedido, wh_bateria from {{ ref('stg_parte') }}
where wh_bateria not between 6.5 and 172.8
