-- ORO · dimensión bici: una fila por cada bici distinta.
select distinct bici
from {{ ref('stg_parte') }}