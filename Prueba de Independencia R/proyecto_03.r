# ==============================================================================
# EJERCICIO: RELACION ENTRE SEXO Y EDAD EN TIENDA DE ROPA
# ==============================================================================
# Se quiere saber si existe relación entre el sexo y la edad de los clientes.
# Nivel de significación: 1% (alpha = 0.01)
#
#               | Hombre | Mujer |
# --------------|--------|-------|
# Menos de 25   |   60   |   50  |
# Mas de 25     |   80   |   10  |
# ==============================================================================

# OBSERVACIONES
# Hipotesis de independencia 
# H0: No existe relacion entre sexo y edad 
# H1: Existe relacion entre sexo y edad

# Chi-cuadrado es la herramienta reina para buscar relaciones entre variables cualitativas (nos nos sirven pruebas t o ANOVA)
# ademas los datos son conteos de frecuencia, no mediciones continuas. Chi-cuadrado es el camino correcto

# Basicamente buscamos demostrar la dependencia o independencia de dos variables Sexo y edad.
# La tabla observada O son los datos reales recolectados de la tienda
# La tabla E son los datos ideales, esperados en un mundo perfecto

# El Estadístico de prueba Chi-Cuadrado es una formula que mide la diferencia entre los datos observados y esperados

# VT (valor critico) es el limite de la frontera. Busca en la tabla estadistica del chi-cuadrado el valor que 
# marca el limite del nivel de confianza (alpha= 0.01)

# VP (Probavilidad de error) calcula cuanta area de la curva queda a la derecha de tu estadistico calculado.
# osea, es la probabilidad de que los resultados que obtenidos sean obra del azar.

# Si vp<0.01 -> Las variables si estan relacionadas

# --- 1. Definición de la Función ---

Prueba_ind = function(O, NS) {
  # Dimensiones y totales
  I = nrow(O)      # Número de filas
  J = ncol(O)      # Número de columnas
  n = sum(O)       # Tamaño de la muestra
  
  # Inicialización de vectores para sumas marginales
  TF = numeric(I)  # Totales por fila
  TC = numeric(J)  # Totales por columna
  E  = O           # Matriz para frecuencias esperadas
  
  # Cálculo de sumas marginales
  for(i in 1:I) TF[i] = sum(O[i,]) 
  for(j in 1:J) TC[j] = sum(O[,j]) 
  
  # Cálculo de la Matriz Esperada (E)
  for(i in 1:I) {
    for(j in 1:J) {
      E[i,j] = (TF[i] * TC[j]) / n
    }
  }
  
  # Cálculo del Estadístico Chi-Cuadrado
  Diff = (O - E)^2 / E
  Est  = sum(Diff)
  
  # Grados de libertad
  gl = (I - 1) * (J - 1)
  
  # Valores Críticos y P-valor
  VT = qchisq(1 - NS, gl) # Valor Crítico de Tabla
  VP = 1 - pchisq(Est, gl) # Valor P
  
  # Decisión estadística
  if (Est > VT) {
    cond = "Rechazo hipotesis de independencia (Existe relación)"
  } else {
    cond = "No rechazo hipotesis de independencia (No existe relación)"
  }
  
  # Preparar salida
  salida = list(
    "Tabla observada" = O,
    "Tabla esperada" = E,
    "Estadistico de prueba" = Est,
    "Valor limite (Crítico)" =VT,
    "Decision" = cond,
    "Valor-p" = format.pval(VP) # Es muy pequeñp
  )
  
  return(salida)
}

# --- 2. Preparación de Datos ---

# Construimos la matriz O (datos observados)
# 60, 50 -> Fila 1
# 80, 10 -> Fila 2
O_datos <- matrix(c(60, 50, 
                    80, 10), 
                  ncol = 2, 
                  byrow = TRUE,
                  dimnames = list(Edad = c("< 25", "> 25"),
                                  Sexo = c("Hombre", "Mujer")))

# Definimos el Nivel de Significación
nivel_significancia <- 0.01

# --- 3. Ejecución y Resultados ---

resultado <- Prueba_ind(O_datos, nivel_significancia)

# Mostrar resultados en consola
print(resultado)






#como el valor-p <0.01 es otra razon para rechazar la hipotesis nula
# Ademas, el estadistico de prueba es 27.80 un valor grando comparado con la frontera de 6.63 (valor limite o critico)
# Como estadistico de prueba> Valor limite -> Se rechaza la hipotesis nula