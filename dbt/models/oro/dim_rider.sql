-- ORO · dimensión rider: una fila por cada rider distinto (ya normalizado en plata con upper(trim())).
select distinct rider
from {{ ref('stg_parte') }}