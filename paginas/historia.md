# Barrio norte llega tarde en el {{ historia_franjas.pct_tarde_bn[0] }} % de sus entregas desde las 14 h: hay que reforzar su reparto de tarde

Barrio norte es la única zona que rompe la promesa de 30 minutos, y lo hace sobre todo por la tarde: desde las 14 h tarda {{ historia_franjas.minutos_bn[0] }} minutos de media, frente a {{ historia_franjas.minutos_resto[0] }} en el resto de zonas. El retraso está en el trayecto, no en la recogida. Proponemos que Operaciones ponga un rider de refuerzo en Barrio norte de 14 h a 17 h a partir del lunes 9 de marzo.

```grafico
tipo: linea
titular: Desde las 14 h, Barrio norte se dispara por encima de la promesa; el resto de zonas, no
modelo: historia_hora
x: hora
y: barrio_norte, resto_zonas
leyenda: Barrio norte, resto de zonas
referencia: 30 · promesa de 30 min
destacar: 14
```

```grafico
titular: El problema está en el trayecto: Barrio norte tarda casi el doble que el resto
modelo: historia_tramos
barras: zona → recoger, reparto
leyenda: recogida, trayecto
destacar: Barrio norte
```

## Qué proponemos

1. **Un rider de refuerzo en Barrio norte de 14 h a 17 h** (jefe de Operaciones, a partir del lunes 9 de marzo).
2. **Medir de nuevo durante dos semanas** con el registro de la app y comprobar que el porcentaje de entregas tarde por la tarde baja por debajo del 10 % (equipo de datos, antes del 23 de marzo).

## Qué no sabemos todavía

- El registro de la app es de **un solo día**: {{ historia_terreno.entregas_registro[0] }} entregas, y solo {{ historia_franjas.entregas_bn[0] }} de Barrio norte por la tarde.
- **Por qué** el trayecto es más lento por la tarde: falta de riders o tráfico es una hipótesis; no tenemos los turnos ni datos de tráfico.
- Los pedidos cancelados no cuentan para la promesa; si se contaran, el porcentaje sería algo menor.

## La misma historia para cada audiencia

- **Comité de dirección (5 segundos):** «Barrio norte llega tarde en el {{ historia_franjas.pct_tarde_bn[0] }} % de sus entregas por la tarde».
- **Jefe de Operaciones (1 minuto):** «Desde las 14 h, Barrio norte tarda {{ historia_franjas.minutos_bn[0] }} minutos de media». Acción 1: un rider de refuerzo de 14 h a 17 h desde el 9 de marzo. Acción 2: medir dos semanas y revisar.
- **Equipo de datos (5 minutos):** «Tiempo de entrega por zona y hora, 5 de marzo de 2026»: registro de estados de la app, de «creado» a «entregado», sin cancelados, {{ historia_terreno.entregas_registro[0] }} entregas.
