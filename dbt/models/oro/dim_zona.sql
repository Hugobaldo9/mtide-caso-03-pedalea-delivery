-- ORO · dimensión zona: una fila por cada zona distinta.
select distinct zona
from {{ ref('stg_parte') }}