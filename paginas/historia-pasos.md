# Cómo se construyó la historia

La portada cuenta el destino. Aquí queda el viaje: la decisión que hay detrás, lo que buscamos en los datos y lo que dejamos fuera.

## Paso 1 · De tema a decisión

| Nivel | En Pedalea Delivery | Qué obliga a hacer |
|---|---|---|
| Tema | «Los tiempos de entrega» | Nada: admite cualquier gráfico |
| Pregunta | «¿Qué zona incumple la promesa de 30 minutos, y cuándo?» | Medir cada pedido de «creado» a «entregado» y compararlo por zona y por hora |
| Decisión | «¿Pone Operaciones un rider más en Barrio norte por la tarde a partir del lunes 9 de marzo?» | Quién (el jefe de Operaciones), cuándo (desde el 9 de marzo) y qué (un rider de refuerzo de 14 h a 17 h) |

**La prueba:** después de leer la portada, el jefe de Operaciones refuerza o no Barrio norte por la tarde desde el 9 de marzo.

## Paso 2 · Qué se mueve en los datos

### 2a · El terreno: Pedalea Delivery tal cual

```cifras
{{ historia_terreno.pedidos[0] }} | pedidos en el parte
{{ historia_terreno.riders[0] }} | riders
{{ historia_terreno.zonas[0] }} | zonas de reparto
{{ historia_terreno.entregas_registro[0] }} | entregas en el registro de la app
```

```grafico
titular: Porcentaje de entregas por encima de 30 minutos, por zona
modelo: pregunta_4
barras: zona → pct_incumple
orden: desc
```

Una zona se separa del resto a simple vista: {{ pregunta_4.zona[0] }}, con el {{ pregunta_4.pct_incumple[0] }} %. Las demás están casi siempre por debajo de la promesa.

```grafico
tipo: linea
titular: Pedidos del parte por día
modelo: historia_pedidos_dia
x: fecha
y: pedidos
```

El volumen diario es estable en la primera entrega y baja mucho en los días de la remesa: lo anotamos en «lo que no cuadra».

```grafico
tipo: histograma
titular: Minutos de entrega por pedido, de «creado» a «entregado»
modelo: historia_tiempos
columna: min_total
tramo: 2
```

La entrega típica tarda {{ historia_terreno.minutos_mediana[0] }} minutos (la media es {{ historia_terreno.minutos_medios[0] }}): la mayoría cumple de sobra, pero hay una cola de pedidos por encima de 30 minutos.

### 2b · El disparador: el trayecto de Barrio norte, y por la tarde

Dividir el tiempo total en sus dos tramos enseña dónde está el problema: la recogida tarda lo mismo en todas las zonas, el trayecto no.

```grafico
titular: El trayecto de Barrio norte tarda casi el doble que en el resto de zonas
modelo: historia_tramos
barras: zona → recoger, reparto
leyenda: recogida, trayecto
destacar: Barrio norte
```

```grafico
tipo: calor
titular: Minutos medios de entrega por zona y hora: Barrio norte se enciende por la tarde
modelo: historia_zona_hora
filas: zona
columnas: hora
valor: minutos
destacar: Barrio norte
orden: desc
```

**El hallazgo:** desde las 14 h, Barrio norte llega tarde en el {{ historia_franjas.pct_tarde_bn[0] }} % de sus entregas, con {{ historia_franjas.minutos_bn[0] }} minutos de media, frente a {{ historia_franjas.minutos_resto[0] }} en el resto de zonas. Antes de las 14 h incumple en el {{ historia_franjas.pct_tarde_bn[1] }} %. El retraso está en el trayecto ({{ historia_tramos.reparto[0] }} minutos frente a {{ historia_tramos.reparto[1] }} de la siguiente zona), no en la recogida. Por qué empeora por la tarde es una hipótesis: falta de riders en esa franja o tráfico.

### 2c · Qué lo puede explicar

- **Anomalía:** sí. Barrio norte se separa de las otras siete zonas, y sobre todo a partir de las 14 h.
- **Cambio significativo:** no se puede ver. El registro de la app es de un solo día.
- **Fuerzas del mercado:** posible. El tráfico de la tarde o la distancia de la zona; es una hipótesis. La distancia sola no lo explica: Polígono tiene trayectos más largos y entrega a tiempo.
- **Iniciativas propias:** posible. Cuántos riders se asignan a Barrio norte por la tarde; no tenemos los turnos para comprobarlo.

## Paso 3 · Qué datos entran y cuáles se quedan fuera

| Dato candidato | ¿Pasa el filtro? | Dónde se usa |
|---|---|---|
| % de entregas tarde por zona (pregunta 4) | Sí: señala la zona | Portada, en el titular y en el texto |
| Minutos de entrega por hora, Barrio norte frente al resto | Sí: dice cuándo reforzar | Portada, gráfico principal |
| Tiempo por tramo (recogida y trayecto) | Sí: dice dónde está el problema | Portada, segunda prueba |
| Pedidos por rider en Barrio norte | No: pocos pedidos por rider para concluir nada | Fuera |
| Metros por pedido de cada zona | No: Polígono recorre más y cumple | Fuera, citado en 2c |
| Ingreso por km de Campus (pregunta 1) | No: es otra decisión, la de la tarifa | Fuera, en el memo |

Al tratar el registro, dejamos fuera los pedidos cancelados y medimos cada pedido de «creado» a «entregado». Si no se hiciera, la conclusión aguanta, pero el problema parece más pequeño:

```grafico
titular: Sin tratar el registro, Barrio norte parece incumplir menos de lo que incumple
modelo: historia_contraste
barras: zona → sin_tratar, tratado
leyenda: sin tratar (con cancelados), tratado
```

```grafico
tipo: eje
titular: Mismos datos, dos lecturas: el eje manda
modelo: pregunta_4
barras: zona → minutos_medios
corte: 15
```

Con el eje cortado, Barrio norte parece muchas veces más lento que Campus; en realidad tarda menos del doble. Por eso las barras de la portada empiezan en cero.

> **Alcance.** Registro de estados de la app del 5 de marzo de 2026: {{ historia_terreno.entregas_registro[0] }} entregas medidas, sin los pedidos cancelados. Parte diario del 9 de febrero al 2 de marzo: {{ historia_terreno.pedidos[0] }} pedidos, con la columna «barrio» de la remesa unificada como «zona» y los metros imposibles estimados con la mediana de su zona.

## Las cinco comprobaciones

- **Hay una decisión detrás:** ¿pone Operaciones un rider más en Barrio norte por la tarde desde el 9 de marzo?
- **El titular afirma:** dice qué pasa, con una cifra, y qué hay que hacer.
- **Cada cifra tiene fuente:** todas salen de modelos del oro, con la fuente al pie de cada gráfico.
- **La evidencia es diversa:** tres pruebas en la misma dirección: las horas, los tramos y el mapa de calor.
- **Lo que no cuadra se dice:** un solo día de registro, los cancelados fuera y menos pedidos diarios en la remesa.
