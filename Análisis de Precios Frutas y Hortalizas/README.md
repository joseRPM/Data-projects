# Proyecto P-01 — Análisis de Precios Mayoristas de Frutas y Hortalizas

**Stack:** Python · pandas · NumPy · Matplotlib · Seaborn · Plotly · Scikit-learn  
**Fuente de datos:** [datos.gob.cl](https://datos.gob.cl) — Oficina de Estudios y Políticas Agrarias (ODEPA)  
**Producto analizado:** Acelga · Año 2024

---

## Descripción

Análisis exploratorio y predictivo de precios mayoristas de productos frescos transados en los principales mercados del país. El dataset cubre regiones desde Arica y Parinacota hasta Los Lagos, con información de precios, volúmenes y características del producto comercializado.

El proyecto abarca limpieza de datos, estandarización de unidades de medida, análisis de preguntas de negocio y modelamiento predictivo mediante regresión lineal.
IMPORTANTE el modelo aplicado en este proyecto esta en proceso de cambio, elección de mejores features, un modelo mas complejo y construcción de graficos con información mas util (incluso la aplicación de tecnicas como cross-validation).

---

## Estructura del proyecto

```
proyecto_01.ipynb
│
├── Exploración inicial
│   ├── Carga del dataset CSV
│   ├── Revisión de tipos de datos y estructura
│   └── Conversión de precios (string → decimal) y fechas (string → datetime)
│
├── Estandarización de precios
│   ├── Identificación de 149 unidades de medida distintas
│   ├── Filtrado del 72.24% de datos expresados en kilogramos
│   ├── Función extraer_kg() con regex para normalizar unidades
│   ├── Separación en df_kg y df_no_kg
│   └── Validación de persistencia de datos
│
└── Preguntas de análisis
    ├── P1: Variación del precio/kg de la acelga durante el año
    ├── P2: Distribución por región y correlación volumen–precio
    └── P3: Predicción de precio con regresión lineal (en proceso de elegir un mejor modelo, features, ect.)
```

---

## Preguntas respondidas

| Pregunta | Resultado |
|---|---|
| ¿Cómo varía el precio de la acelga en el año? | Precios estables en la primera mitad. Aumento y mayor dispersión entre agosto y diciembre, posiblemente por baja en la oferta |
| ¿Qué regiones concentran mayor volumen? | Maule destaca en volumen individual. Coquimbo acumula múltiples registros de alto volumen |
| ¿Existe correlación entre volumen y precio? | Correlación negativa moderada de **-0.51**: a mayor oferta, menor precio por kg |
| ¿Es posible predecir el precio con regresión lineal? | No con precisión. MAE ≈ $150 (~23% del precio promedio). R² bajo en todos los modelos |

---

## Modelos de regresión lineal

Se evaluaron tres modelos con dos enfoques de partición de datos:

| Modelo | Variables | Resultado |
|---|---|---|
| Modelo 1 | Solo tiempo (día del año) | R² bajo, poca capacidad explicativa |
| Modelo 2 | Solo volumen | Mejor relación individual con el precio |
| Modelo 3 | Tiempo + volumen | Mejora marginal respecto a los anteriores |

**Partición aleatoria** (`train_test_split`): MAE ≈ $150, R² bajo pero positivo.  
**Partición temporal** (80% pasado / 20% futuro): R² negativo — el modelo no generaliza hacia datos futuros y predice peor que usar el promedio directamente.

**Conclusión:** La regresión lineal con estas variables no es suficiente. El precio está influenciado por factores no capturados: calidad, origen, condiciones climáticas, logística. Se requieren variables adicionales o modelos más complejos (series de tiempo, árboles de decisión).

---

## Técnicas utilizadas

- Conversión y limpieza de tipos con `pandas` (`str.split`, `pd.to_numeric`, `pd.to_datetime`)
- Máscaras booleanas con `str.contains` para filtrado
- Función personalizada con `re` (regex) para extracción y normalización de unidades
- Validación de integridad de datos post-separación
- Visualización con `plotly.express` (de forma experimental), `seaborn` y `matplotlib`
- Correlación de Pearson con `DataFrame.corr()`
- Regresión lineal con `sklearn`: `LinearRegression`, `train_test_split`, `mean_absolute_error`, `r2_score`
- Partición temporal manual con `sort_values`

---

## Cómo ejecutar

1. Instalar dependencias:
   ```bash
   pip install pandas numpy matplotlib seaborn plotly scikit-learn
   ```
2. Descargar el dataset desde [datos.gob.cl](https://datos.gob.cl) (ODEPA — precios mayoristas 2024)
3. Colocar el archivo CSV en el mismo directorio que el notebook con el nombre:
   ```
   precio_mayorista_fruta-hortaliza_2024.csv
   ```
4. Ejecutar `proyecto_01.ipynb` de forma secuencial

---

## Conclusión principal

La regresión lineal simple no logra predecir con precisión el precio mayorista de la acelga. La correlación negativa moderada entre volumen y precio es consistente con la lógica básica de oferta y demanda, pero el precio está determinado por múltiples factores no recogidos en el dataset. Un análisis más robusto requeriría incorporar variables como región, origen del producto, condiciones estacionales o modelos de series de tiempo.