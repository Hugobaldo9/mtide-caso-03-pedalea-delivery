-- PLATA · el parte diario limpio: la limpieza que hiciste en la J3, ahora como modelo dbt.
-- Cada entrega del parte es una carpeta fecha_carga=… en bronce: aquí se leen todas juntas.
with bruto as (
    -- ARREGLO REMESA 2026-03-03: la exportación nueva se hizo con otra versión del programa y la
    -- columna «zona» llega con otro nombre, «barrio». Al leer todas las entregas juntas
    -- (union_by_name), esas filas quedaban con zona vacía (NULL) y el join con mediana_zona las
    -- descartaba sin avisar: se perdían los 111 pedidos de la remesa (lo detectó filas_conservadas).
    -- Lo arreglo aquí, en plata, uniendo las dos columnas en una sola «zona»: bronce no se toca,
    -- y si llega otra entrega con cualquiera de los dos nombres, se sigue leyendo bien.
    select * exclude (zona, barrio),
           coalesce(zona, barrio) as zona,
           parse_filename(filename) as archivo
    from {{ source('bronce', 'parte') }}
),
sin_dup as (
    -- una fila por pedido
    select * from bruto
    qualify row_number() over (partition by pedido order by fecha_carga desc) = 1
),
mediana_zona as (
    select zona, median(metros::integer) as metros_mediana
    from sin_dup
    where metros::integer between 1 and 20000
    group by zona
)
select
    s.pedido,
    s.fecha::date                                              as fecha,
    upper(trim(s.rider))                                         as rider,
    s.bici,
    s.zona,
    case when s.metros::integer between 1 and 20000 then s.metros::integer
         else round(m.metros_mediana)::integer end               as metros,
    not (s.metros::integer between 1 and 20000)                   as metros_corregido,
    s.wh_bateria::double                                              as wh_bateria,
    s.importe_eur::double                                      as importe_eur,
    s.incidencia,
    s.archivo,
    s.fecha_carga
from sin_dup s
join mediana_zona m using (zona)
