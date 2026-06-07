#  Proyecto P-02 — Análisis de Vinos del Mundo

**Stack:** MySQL · Power BI  
**Base de datos:** `vino`  
**Dataset:** 304 registros · 15 países · múltiples catadores

---

## Descripción

Análisis SQL de un dataset de vinos internacionales orientado a responder preguntas de negocio 

El proyecto cubre limpieza de datos, análisis exploratorio, consultas analíticas con CTEs y funciones de ventana, normalización del esquema, y visualización en Power BI conectado directamente a MySQL.

---

## Estructura del proyecto

```
proyecto_01.sql
│
├── Limpieza de datos
│   ├── Conversión de campos vacíos → NULL
│   ├── Transformación de tipos (price: TEXT → DECIMAL)
│   └── Validación con REGEXP
│
├── Análisis exploratorio
│   ├── Total de registros y países participantes
│   ├── Distribución de vinos por país
│   ├── Rango de precios (min: $9 · max: $215 · promedio: $32)
│   └── Rango de puntajes (85 – 92 puntos)
│
├── Análisis de preguntas
│   ├── País con mejores vinos (promedio + desviación estándar)
│   ├── Segmentación por terciles de precio (NTILE)
│   ├── Búsqueda de "gemas ocultas" (quintil superior calidad/precio)
│   └── Correlación precio–calidad por país
│
└── Modelamiento de datos
    ├── Tabla catadores (normalización)
    ├── Tabla vinos (con FOREIGN KEY → catadores)
    └── Configuración de usuario de solo lectura para Power BI
```

---

## Preguntas respondidas

| Pregunta | Resultado |
|---|---|
| ¿Qué país tiene los mejores vinos? | **Austria** · promedio 90.6 pts · std 1.74 |
| ¿Precio alto implica más calidad en Austria? | Sí, los terciles más caros tienen mejor puntaje promedio |
| ¿Qué tan dispersos son precio y puntaje entre los segmentos de Austria? | std promedio de puntajes: **1.7** · std precio entre segmentos: **4.42** |
| ¿Existen buenos vinos fuera de Austria? | Sí. El mejor índice calidad/precio es un vino francés (ID 127, Alsace One, 91 pts · $13) |

---

## Técnicas SQL utilizadas

- `UPDATE` con `TRIM()` y conversión de vacíos a `NULL`
- `ALTER TABLE` para cambio de tipo de dato
- `GROUP BY` + funciones de agregación (`AVG`, `STDDEV`, `COUNT`)
- **CTEs encadenadas** (`WITH ... AS`) para consultas multi-paso
- **Funciones de ventana**: `NTILE()`, `ROW_NUMBER()` con `OVER()`
- **Correlación de Pearson** calculada manualmente en SQL
- `JOIN` entre tablas normalizadas
- `FOREIGN KEY` con `REFERENCES`
- Subconsultas escalares dentro de CTEs

---

## Modelo de datos (normalizado)

```
catadores
├── id           INT PK AUTO_INCREMENT
├── taster_name  VARCHAR(50)
└── taster_twitter_handle VARCHAR(250)

vinos
├── id           INT PK AUTO_INCREMENT
├── country      VARCHAR(50)
├── designation  VARCHAR(255)
├── price        DECIMAL(10,2)
├── points       INT
└── taster_id    INT FK → catadores(id)
```

---

## Dashboard Power BI

El dashboard se conecta a MySQL mediante un usuario de solo lectura (`powerbi_user`) y presenta:

- **Suma de vinos distintos y precio promedio por país** — gráfico de barras agrupadas
- **Puntaje promedio por tercil en Austria** — análisis del país ganador por segmento de precio
- **Puntaje promedio por país** — ranking comparativo general
- **Índice calidad/precio, puntaje y precio por vino** — tabla de mejores opciones globales

---

## Cómo ejecutar

1. Crear la base de datos: `CREATE DATABASE vino;`
2. Importar el CSV del dataset como tabla `dataset_vinos`
3. Ejecutar `proyecto_02.sql` en orden secuencial
4. (Opcional) Crear el usuario de Power BI:
   ```sql
   CREATE USER 'powerbi_user'@'localhost' IDENTIFIED BY 'tu_contraseña';
   GRANT SELECT ON vino.* TO 'powerbi_user'@'localhost';
   FLUSH PRIVILEGES;
   ```
5. Conectar Power BI Desktop a MySQL usando ese usuario

---

## Conclusión principal

Austria lidera en puntaje promedio, pero **no es necesariamente la mejor opción en términos de valor**. Existen vinos de top 20% de calidad en Francia, Chile y Sudáfrica con índices calidad/precio mejores. El análisis demuestra que precio alto no garantiza calidad proporcionalmente mayor en todos los mercados.