# Proyecto P-01 — Análisis de Precios Mayoristas de Frutas y Hortalizas

**Stack:** Python · pandas · NumPy · Matplotlib · Seaborn · Scikit-learn
**Fuente de datos:** [datos.gob.cl](https://datos.gob.cl) — Oficina de Estudios y Políticas Agrarias (ODEPA)
**Producto analizado:** Acelga · Año 2024

---

## Descripción

Análisis exploratorio y predictivo de precios mayoristas de productos frescos transados en los principales mercados del país. El dataset cubre regiones desde Arica y Parinacota hasta Los Lagos, con información de precios, volúmenes y características del producto comercializado.

El proyecto abarca limpieza de datos, estandarización de unidades de medida, feature engineering (one-hot encoding de regiones y codificación numérica de calidad), análisis de preguntas de negocio y modelamiento predictivo mediante regresión lineal con validación cruzada.

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
│   ├── Filtrado del 71.24% de datos expresados en kilogramos
│   ├── Función extraer_kg() con regex para normalizar unidades
│   ├── Separación en df_kg y df_no_kg, con validación de persistencia de datos
│   └── Cálculo de precio por kg
│
├── Feature engineering
│   ├── Codificación numérica de la variable "Calidad"
│   ├── One-hot encoding de regiones
│   └── Selección y renombrado de columnas finales del dataset modelo
│
└── Preguntas de análisis
    ├── P1: Variación del precio/kg de la acelga durante el año
    ├── P2: Distribución por región y correlación volumen–precio
    └── P3: Predicción de precio con regresión lineal + cross-validation
```

---

## Preguntas respondidas

| Pregunta | Resultado |
|---|---|
| ¿Cómo varía el precio de la acelga en el año? | Precio y volumen muestran una relación inversa: en septiembre 2024, una caída del precio coincide con un aumento abrupto del volumen, seguido de recuperación del precio al disminuir el volumen. Patrón consistente con oferta y demanda |
| ¿Qué regiones concentran mayor volumen? | La Región Metropolitana concentra por lejos el mayor volumen comercializado, lo que tiene sentido dado que ahí se encuentra la mayor parte de la población y centrales de abasto como Lo Valledor |
| ¿Existe correlación entre volumen y precio? | Correlación de -0.152 (débil) considerando todos los productos juntos. Al mezclar productos con dinámicas propias de oferta/demanda, la relación se diluye |
| ¿Es posible predecir el precio con regresión lineal? | Sí, con un modelo multivariable: **R² = 0.949**, MAE ≈ 504.91. Validación cruzada (5-fold): R² promedio = 0.936, desviación estándar = 0.032 |

---

## Modelo de regresión lineal

A diferencia de un enfoque univariable, el modelo final incorpora múltiples features construidas durante el feature engineering:

- Calidad del producto (codificada numéricamente)
- Kilogramos comercializados (kg_comercializado)
- Volumen
- Región de origen (one-hot encoding: RM, Arica, Coquimbo, Araucanía, Los Lagos, Valparaíso, Ñuble, Biobío, Maule)

**Resultados (holdout 80/20, random_state=42):**
- R² = 0.949 → el modelo explica el 94.9% de la variabilidad del precio
- MAE = 504.91

**Validación cruzada (5-fold):**
- R² promedio = 0.936
- Desviación estándar = 0.032 → resultados estables, sin señales de sobreajuste

**Importancia de variables (coeficientes):** el factor geográfico y el volumen de mercado dominan la fijación de precios. Pertenecer a la Región de Los Lagos eleva fuertemente el precio, mientras que la Región de Valparaíso tiene un efecto contrario.

---

## Técnicas utilizadas

- Conversión y limpieza de tipos con `pandas` (`str.split`, `pd.to_numeric`, `pd.to_datetime`)
- Máscaras booleanas con `str.contains` para filtrado
- Función personalizada con `re` (regex) para extracción y normalización de unidades
- Validación de integridad de datos post-separación
- Feature engineering: mapeo manual de categorías ordinales (`Calidad`) y `pd.get_dummies` para variables categóricas (`Region`)
- Visualización con `seaborn` y `matplotlib` (gráficos de doble eje, barplots)
- Correlación de Pearson con `Series.corr()`
- Regresión lineal con `sklearn`: `LinearRegression`, `train_test_split`, `mean_absolute_error`, `r2_score`, `cross_val_score`

---

## Cómo ejecutar

1. Instalar dependencias:
   ```bash
   pip install pandas numpy matplotlib seaborn scikit-learn
   ```
2. Descargar el dataset desde [datos.gob.cl](https://datos.gob.cl) (ODEPA — precios mayoristas 2024)
3. Colocar el archivo CSV en el mismo directorio que el notebook con el nombre:
   ```
   precio_mayorista_fruta-hortaliza_2024.csv
   ```
4. Ejecutar `proyecto_01.ipynb` de forma secuencial

---

## Conclusión principal

El precio mayorista de la cualquier producto del dataset responde a una dinámica de oferta y demanda: a lo largo del año se observa una relación inversa entre volumen y precio, y esta misma tendencia (aunque débil, -0.152, al considerar todos los productos) se mantiene al analizar el dataset completo. La Región Metropolitana concentra el mayor volumen comercializado, coherente con su rol como principal centro de consumo y distribución del país. Tomando en cuenta estos factores —volumen y región— como features de un modelo de regresión lineal, junto a calidad y kilogramos comercializados, es posible predecir el precio con alta precisión (R² = 0.949, MAE ≈ 505), con resultados estables bajo validación cruzada (R² promedio = 0.936, std = 0.032). En conjunto, los tres análisis muestran que el precio no depende de un factor aislado, sino de la interacción entre estacionalidad, volumen ofertado y ubicación geográfica del mercado.
