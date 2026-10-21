-- PLATA · el parte diario limpio: la limpieza que hiciste en la J3, ahora como modelo dbt.
-- Cada entrega del parte es una carpeta fecha_carga=… en bronce: aquí se leen todas juntas.
with bruto as (
    select *, parse_filename(filename) as archivo
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
