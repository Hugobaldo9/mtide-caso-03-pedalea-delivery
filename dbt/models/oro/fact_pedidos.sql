-- ORO · hecho: un pedido por fila (el grano), con sus claves hacia las dimensiones y sus medidas.
select
    pedido,
    fecha,
    rider,
    bici,
    zona,
    metros,
    wh_bateria,
    importe_eur,
    incidencia is not null as con_incidencia   -- incidencia es texto: aquí la convierto en sí/no
from {{ ref('stg_parte') }}