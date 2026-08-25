# Sistema de Análisis de Sistemas de Control

**Autor:** Ennos Saldaña Caseres
**Carnet:** 2023218432
**Lenguaje:** MATLAB

## ¿Qué hace el programa?

Este programa permite analizar una función de transferencia a partir de sus **ceros y polos**.

El sistema permite:

* Ingresar los ceros y polos de (G(s)).
* Generar automáticamente el numerador y denominador.
* Mostrar la función de transferencia.
* Generar la ecuación característica.
* Ingresar un valor de ganancia (K).
* Generar la tabla de Routh-Hurwitz.
* Determinar si el sistema es estable o inestable para el valor de (K).
* Generar el gráfico del Lugar de las Raíces (Root Locus).
* Mostrar los polos y ceros en el plano complejo.

---

# ¿Cómo utilizar el programa?

## 1. Abrir el programa

Abra MATLAB y coloque el archivo `.m` del programa en la carpeta de trabajo.

Ejecute el archivo desde MATLAB.

---

## 2. Ingresar los ceros

El programa solicitará:

```text
Ingrese los CEROS de G(s) como vector
```

Debe ingresar los ceros utilizando la sintaxis de vectores de MATLAB.

### Ejemplo

Si los ceros son:

[
-2,;-4
]

ingrese:

```matlab
[-2 -4]
```

Si la función de transferencia **no tiene ceros**, simplemente presione **Enter**.

---

## 3. Ingresar los polos

Después se solicitarán los polos:

```text
Ingrese los POLOS de G(s) como vector
```

Por ejemplo, si los polos son:

[
-1,;-3,;-5
]

ingrese:

```matlab
[-1 -3 -5]
```

Debe ingresar al menos un polo.

---

## 4. Verificar los datos

El programa mostrará los datos introducidos:

```text
DATOS INTRODUCIDOS

Ceros:
    -2
    -4

Polos:
    -1
    -3
    -5
```

Verifique que los valores sean correctos antes de continuar.

---

## 5. Revisar la función de transferencia

El programa calculará automáticamente el numerador y denominador.

Para el ejemplo:

```matlab
Ceros = [-2 -4]
Polos = [-1 -3 -5]
```

se obtiene:

[
N(s)=s^2+6s+8
]

[
D(s)=s^3+9s^2+23s+15
]

Y la función de transferencia:

[
G(s)=\frac{s^2+6s+8}
{s^3+9s^2+23s+15}
]

---

## 6. Ingresar el valor de K

El programa solicitará:

```text
Ingrese el valor de K para Routh (K >= 0):
```

Ingrese un valor real mayor o igual a cero.

### Ejemplo

```text
Ingrese el valor de K para Routh (K >= 0): 2
```

El programa utilizará:

[
K=2
]

para realizar el análisis de estabilidad.

---

## 7. Revisar la ecuación característica

El programa calculará:

[
D(s)+KN(s)=0
]

Para el ejemplo anterior y (K=2):

[
D(s)+2N(s)=0
]

Por lo tanto:

[
s^3+11s^2+35s+31=0
]

---

## 8. Revisar la tabla de Routh-Hurwitz

El programa mostrará automáticamente la tabla de Routh:

```text
TABLA DE ROUTH-HURWITZ
```

También mostrará la primera columna de la tabla.

Esta columna se utiliza para determinar la cantidad de cambios de signo.

### Interpretación

Si aparece:

```text
Cambios de signo = 0
```

el sistema es:

```text
SISTEMA ESTABLE
```

Si aparece uno o más cambios:

```text
Cambios de signo = 1
```

el sistema es:

```text
SISTEMA INESTABLE
```

---

# 9. Revisar el Root Locus

Al finalizar el análisis, MATLAB abrirá una ventana con el **Lugar de las Raíces**.

En la gráfica:

* **`x`** → polos de lazo abierto.
* **`o`** → ceros de lazo abierto.
* Línea horizontal → eje (\sigma).
* Línea vertical → eje (j\omega).
* Puntos del Root Locus → posibles posiciones de los polos de lazo cerrado.

### Plano complejo

El eje horizontal corresponde a:

[
\sigma
]

El eje vertical corresponde a:

[
j\omega
]

Por lo tanto:

```text
              jω
               ↑
               |
       Polos   |   Root Locus
               |
---------------+----------------→ σ
               |
               |
               ↓
```

---

# Ejemplo completo

Supongamos que se tiene:

[
G(s)=
\frac{(s+2)(s+4)}
{(s+1)(s+3)(s+5)}
]

### Paso 1 — Ceros

Ingrese:

```matlab
[-2 -4]
```

### Paso 2 — Polos

Ingrese:

```matlab
[-1 -3 -5]
```

### Paso 3 — K

Ingrese:

```text
2
```

El programa calculará automáticamente todos los resultados.

---

# Importante

### Para ingresar varios valores

Sepárelos mediante espacios:

```matlab
[-1 -3 -5]
```

También puede utilizar punto y coma:

```matlab
[-1; -3; -5]
```

### No utilizar

No escriba los valores separados por comas de esta forma:

```matlab
-1, -3, -5
```

Utilice preferiblemente:

```matlab
[-1 -3 -5]
```

### Ceros

Los ceros son opcionales.

Si no existen ceros, presione **Enter** cuando el programa los solicite.

### Polos

Debe ingresar al menos un polo.

### Ganancia K

El valor de (K) debe ser:

[
K\geq0
]

---

# Resumen del uso

```text
1. Ejecutar el programa
        ↓
2. Ingresar ceros
        ↓
3. Ingresar polos
        ↓
4. Revisar G(s)
        ↓
5. Ingresar K
        ↓
6. Revisar ecuación característica
        ↓
7. Revisar tabla de Routh
        ↓
8. Revisar estabilidad
        ↓
9. Revisar Root Locus
```

**Ennos Saldaña Caseres**
**Carnet: 2023218432**
