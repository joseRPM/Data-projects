# Proyecto P-03 — Prueba de Independencia Chi-Cuadrado en R

**Stack:** R  
**Área:** Estadística inferencial  
**Tema:** Relación entre sexo y edad en clientes de una tienda de ropa

---

## Descripción

Implementación from scratch de una prueba de independencia Chi-Cuadrado en R, sin usar funciones de test integradas. El objetivo es determinar si existe una relación estadísticamente significativa entre el sexo y el rango etario de los clientes, a un nivel de significación del 1% (α = 0.01).
Este mini proyecto tiene como finalidad demostrar manejo de R así como de algunos conceptos de estadistica.

---

## Planteamiento

|              | Hombre | Mujer |
|--------------|--------|-------|
| Menos de 25  | 60     | 50    |
| Más de 25    | 80     | 10    |

**H₀:** No existe relación entre sexo y edad (variables independientes)  
**H₁:** Existe relación entre sexo y edad  
**α = 0.01**

---

## ¿Por qué Chi-Cuadrado?

Los datos son conteos de frecuencia, no mediciones continuas, y las variables son cualitativas (sexo y rango etario). En ese contexto Chi-Cuadrado es la prueba adecuada — las pruebas t o ANOVA no aplican porque requieren variables numéricas continuas.

---

## Lógica de la función `Prueba_ind()`

La función recibe la tabla observada `O` y el nivel de significación `NS`, y ejecuta el siguiente flujo:

1. Calcula los totales marginales por fila y columna
2. Construye la tabla esperada `E` — la distribución que existiría si las variables fueran completamente independientes
3. Calcula el estadístico Chi-Cuadrado: `Σ (O - E)² / E`
4. Determina los grados de libertad: `(filas - 1) × (columnas - 1)`
5. Obtiene el valor crítico (`qchisq`) y el valor-p (`pchisq`)
6. Emite la decisión estadística comparando el estadístico con el valor límite

---

## Resultados

| Métrica | Valor |
|---|---|
| Estadístico de prueba | 27.80 |
| Valor crítico (α = 0.01, gl = 1) | 6.63 |
| Valor-p | < 0.01 |
| Decisión | **Rechazo H₀** |

El estadístico de prueba (27.80) supera ampliamente el valor crítico (6.63), y el valor-p es menor que el nivel de significación. Ambos criterios conducen a la misma conclusión: **existe una relación estadísticamente significativa entre el sexo y el rango etario de los clientes**.

---

## Cómo ejecutar

1. Abrir `proyecto_03.r` en RStudio o cualquier entorno R
2. Ejecutar el script completo
3. Los resultados se imprimen en consola: tabla observada, tabla esperada, estadístico, valor crítico, valor-p y decisión

No se requieren librerías externas — el script usa únicamente R base.