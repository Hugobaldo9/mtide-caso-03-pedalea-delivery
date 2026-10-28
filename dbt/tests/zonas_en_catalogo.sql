-- TEST PROTAGONISTA · contrato entre el parte y el catálogo de zonas.
-- Regla de negocio: toda zona que aparece en el parte tiene que existir en el catálogo de zonas
-- (zonas.csv), porque de ahí sale la promesa de entrega. Si mañana aparece una zona nueva sin dar
-- de alta, este test devuelve esas zonas y el build se para antes de llegar a las respuestas.
select p.zona, count(*) as pedidos
from {{ ref('stg_parte') }} p
left join {{ ref('stg_zonas') }} z using (zona)
where z.zona is null
group by p.zona