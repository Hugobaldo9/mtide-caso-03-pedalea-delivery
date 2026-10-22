# Caso 03 · Pedalea Delivery — el encargo

> Negocio y datos **ficticios**, creados para la asignatura. Es tu mismo caso de la J3.

## Qué ha pasado desde la J3

En la J3 limpiaste el parte en un cuaderno y contestaste tres preguntas. Pedalea Delivery quiere que el parte se cargue solo cada vez que llega una exportación nueva. Y ha prometido a sus clientes **entregar en 30 minutos**: quiere saber dónde lo incumple, con el registro de estados de cada pedido.

Ahora conviertes aquel cuaderno en un **lakehouse** de verdad, en tu propio repositorio, y publicas un **portal** que
cuenta lo que has hecho. Cómo preparar el repositorio y el ciclo de trabajo de cada bloque: [README.md](README.md).

## Lo que tienes al empezar

- En bronce, el parte de la J3: `lakehouse/bronce/parte/fecha_carga=2026-02-21/`.
- En `dbt/models/plata/stg_parte.sql`, la limpieza que hiciste en la J3, con unos tests básicos (`_plata.yml`, `dbt/tests/`).
- `dbt build` en verde. La capa oro, vacía: la construyes tú.
- En `paginas/`, las cuatro páginas del portal que escribirás, cada una con un guion de lo que debe contar.

**Bronce no se toca nunca**: todo arreglo va en plata.

---

## Bloque 1 · La remesa nueva · rama `remesa`

1. `python herramientas/sistema_simulado.py remesa`: llega una entrega nueva del parte en `bronce/parte/fecha_carga=2026-03-03/` (unos diez días más de pedidos).
2. `dbt build --project-dir dbt --profiles-dir dbt`. La exportación de la remesa la hizo otra persona, con otra versión del programa. Fíjate en qué test se pone rojo y en **cuántas** filas faltan.

   > 🔎 **Pista · mirar dentro antes de arreglar.** `dbt build` te dice *dónde* duele, no *por qué*.
   > Para eso tienes `dbt show`: ejecuta una consulta y te enseña el resultado sin construir nada.
   >
   > ```bash
   > dbt show --project-dir dbt --profiles-dir dbt --select <un_test>
   > dbt show --project-dir dbt --profiles-dir dbt --inline "select ... from {{ ref('<modelo>') }} ..."
   > dbt show --project-dir dbt --profiles-dir dbt --inline "select ... from {{ source('bronce', 'parte') }} ..."
   > ```
   >
   > El primero te enseña las filas que un test rechaza. Los otros dos te dejan preguntar lo que quieras
   > a plata o a bronce tal como llegó. Antes de tocar el SQL, intenta contestar tres preguntas:
   > **¿qué filas?**, **¿desde cuándo?** y **¿venía ya así en bronce?** Bronce guarda cada entrega en su
   > carpeta `fecha_carga=…`, y esa columna te deja comparar una entrega con otra.

3. Arregla `dbt/models/plata/stg_parte.sql` hasta que `dbt build` quede en verde y el problema esté resuelto (no siempre hay un test que lo grite: a veces tienes que escribirlo tú). Deja un comentario en el SQL: **qué** venía mal y **por qué** lo arreglas así.
4. Escribe `paginas/1-remesa.md`.
5. Pull request en tu repositorio, Actions en verde y lo fusionas.

## Bloque 2 · El oro · rama `oro`

Crea en `dbt/models/oro/` estos modelos, **con estos nombres exactos** (el portal y la jornada de Visualización los leen así):

| Modelo | Qué tiene |
|---|---|
| `dim_rider` | una fila por cada valor distinto de `rider` |
| `dim_bici` | una fila por cada valor distinto de `bici` |
| `dim_zona` | una fila por cada valor distinto de `zona` |
| `fact_pedidos` | un pedido por fila: `pedido`, `fecha`, `rider`, `bici`, `zona`, `metros`, `wh_bateria`, `importe_eur`, `con_incidencia` |
| `pregunta_1` | ¿Qué **zona** deja menos ingreso por kilómetro? Una fila por `zona`, con `zona` en la primera columna y `ingreso_km` (€/km), de menor a mayor |
| `pregunta_2` | ¿Qué **rider** gasta más batería por kilómetro? Una fila por `rider`, con `rider` en la primera columna y `wh_km` (Wh/km), de mayor a menor |
| `pregunta_3` | ¿Qué **bici** acumula más incidencias por cada 100 km? Una fila por `bici`, con `bici` en la primera columna y `incidencias_100km` (incidencias por 100 km), de mayor a menor |

En un `_oro.yml`, sus tests: en las dimensiones, `unique` y `not_null`; en el hecho, `unique` en `pedido` y `relationships` con cada dimensión.

Escribe `paginas/2-oro.md`: tu estrella y las tres respuestas. Con la remesa nueva (un 25 % más de datos), ¿siguen saliendo las mismas que en la J3? Pull request, verde, fusionas.

## Bloque 3 · Fuentes nuevas · rama `fuentes`

1. `python herramientas/sistema_simulado.py fuentes`: llegan estos ficheros a bronce y quedan declarados en `dbt/models/plata/_fuentes.yml`.

| Fichero | Qué es | Columnas |
|---|---|---|
| `bronce/zonas/zonas.csv` | catálogo de zonas de reparto, con su código postal y la promesa de entrega en minutos | zona, codigo_postal, promesa_min |
| `bronce/eventos/estados_pedido_2026-03-05.json` | La app de reparto exporta un registro con cada cambio de estado de los pedidos: `creado` → `recogido` → `entregado` (o `cancelado`). | evento_id, pedido_id, zona, rider, estado (creado / recogido / entregado / cancelado), ts |

2. **El giro.** Es una **máquina de estados**: un pedido es varias filas. Para medir el tiempo de entrega tienes que juntar el `creado` con el `entregado` del mismo pedido, y los cancelados no cuentan.
3. Modelos de plata: `stg_zonas` y `stg_eventos` (el registro lo lees con `source('bronce', 'eventos')`).
4. **Test protagonista.** **Toda zona del parte tiene que existir en el catálogo de zonas.** Escríbelo como test (de relaciones o singular). Es el contrato entre el parte y el catálogo: si mañana aparece una zona nueva sin dar de alta, el build lo tiene que parar.
5. **Pregunta 4** (`dbt/models/oro/pregunta_4.sql`): ¿Qué zona **incumple más la promesa de 30 minutos** (de `creado` a `entregado`)? ¿Cuánto tarda de media?
6. Escribe `paginas/3-fuentes.md`. Pull request, verde, fusionas.

## Bloque 4 · El memo · rama `memo`

Escribe `paginas/memo.md`: el memo para la dirección de Pedalea Delivery, con las cuatro respuestas citadas con marcas. La comprobación exige que existan `pregunta_1` a `pregunta_4`. Repasa el portal entero antes de fusionar.

---

## Lo que se entrega

- Tu repositorio en tu cuenta, con los cuatro pull requests fusionados y la última ejecución de `main` en verde.
- Tu portal publicado, con sus cuatro páginas escritas, y tu `dbt-docs`.
- La presentación oral (5 minutos): con tu portal en pantalla, el problema de calidad, tu test protagonista, las cuatro respuestas y tu recomendación.
