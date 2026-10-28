# Memo para la dirección de Pedalea Delivery

**Pregunta de partida:** ¿dónde se pierde dinero y dónde incumplimos la promesa de entregar en 30 minutos? Analizamos {{ fact_pedidos.filas }} pedidos del parte (del 9 de febrero al 2 de marzo de 2026) y el registro de estados de los pedidos de un día completo.

## Qué hemos visto

- **Una zona cobra poco por lo que recorre.** **{{ pregunta_1.zona[0] }}** solo deja **{{ pregunta_1.ingreso_km[0] }} € por kilómetro**, frente a {{ pregunta_1.ingreso_km[7] }} €/km de {{ pregunta_1.zona[7] }}, la que más deja.
- **Una rider gasta mucha más batería que el resto.** **{{ pregunta_2.rider[0] }}** consume **{{ pregunta_2.wh_km[0] }} Wh por kilómetro**; la siguiente, {{ pregunta_2.rider[1] }}, se queda en {{ pregunta_2.wh_km[1] }} Wh/km.
- **Una bici concentra los problemas.** **{{ pregunta_3.bici[0] }}** acumula **{{ pregunta_3.incidencias_100km[0] }} incidencias por cada 100 km** ({{ pregunta_3.incidencias[0] }} incidencias), cuando la segunda, {{ pregunta_3.bici[1] }}, tiene {{ pregunta_3.incidencias_100km[1] }}.
- **Una zona incumple la promesa de 30 minutos.** En **{{ pregunta_4.zona[0] }}**, el **{{ pregunta_4.pct_incumple[0] }} % de las entregas** ({{ pregunta_4.fuera_de_plazo[0] }} de {{ pregunta_4.entregados[0] }}) llega tarde, con una media de **{{ pregunta_4.minutos_medios[0] }} minutos**. La siguiente zona, {{ pregunta_4.zona[1] }}, solo falla en el {{ pregunta_4.pct_incumple[1] }} %.

## Qué recomendamos

1. **Revisar la tarifa de {{ pregunta_1.zona[0] }}**: cada kilómetro allí se cobra a {{ pregunta_1.ingreso_km[0] }} €, muy por debajo del resto de zonas. Una tarifa mínima por distancia corregiría la diferencia.
2. **Hablar con {{ pregunta_2.rider[0] }}** sobre sus rutas y su forma de conducir: su consumo ({{ pregunta_2.wh_km[0] }} Wh/km) es el más alto con diferencia, y el ahorro de batería es directo.
3. **Retirar {{ pregunta_3.bici[0] }} a revisión**: con {{ pregunta_3.incidencias_100km[0] }} incidencias por cada 100 km no es mala suerte, es la bici.
4. **Reforzar el reparto en {{ pregunta_4.zona[0] }}** (un rider más en las horas punta o reorganizar sus rutas): es la única zona donde la promesa de 30 minutos se rompe de forma habitual, con una media de {{ pregunta_4.minutos_medios[0] }} minutos.

## Qué no sabemos todavía

- **El periodo es corto**: algo más de tres semanas de parte y **un solo día** de registro de estados. Antes de cambiar tarifas o personal conviene confirmar los patrones con más semanas.
- **No sabemos el porqué**: si {{ pregunta_4.zona[0] }} llega tarde por la distancia, por el tráfico o por falta de riders; ni si el consumo de {{ pregunta_2.rider[0] }} se debe a sus rutas o a su conducción.
- **Supuestos y correcciones**: los pedidos cancelados no cuentan para la promesa; algunos pedidos tienen los metros estimados con la mediana de su zona porque venían con valores imposibles, y se eliminaron filas duplicadas del parte.
- **Faltan costes**: no tenemos el precio de la energía ni el coste de cada incidencia, así que aún no podemos pasar los hallazgos 2 y 3 a euros.

## Cómo se ha hecho

Los datos se guardan en un lakehouse de tres capas: **bronce** (lo que llega, sin tocar), **plata** (limpio) y **oro** (las respuestas), construido con dbt y comprobado automáticamente en cada cambio. Al llegar la exportación del 3 de marzo encontramos un **problema de calidad**: la columna `zona` venía con otro nombre (`barrio`) y se perdían todos los pedidos de esa entrega sin que nada fallara a la vista. Lo detectó el test `filas_conservadas`, que comprueba que no se pierde ningún pedido, y se arregló en plata. Desde ahora, además, el test `zonas_en_catalogo` vigila que toda zona del parte exista en el catálogo de zonas: si aparece una zona nueva sin dar de alta, la carga se para antes de llegar a estas cifras. Todas las cifras de este memo se leen del lakehouse: si llega otra remesa, el memo se actualiza solo.