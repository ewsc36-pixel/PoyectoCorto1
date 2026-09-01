# Proyecto Corto 3 - Diseño Interactivo de Polos

**Nombre:** Ennos Saldaña Caseres  
**Carnet:** 2023218432  

---

## Descripción

Este programa fue desarrollado en MATLAB para realizar el diseño interactivo de polos de un sistema de control.

El programa permite ingresar los ceros y polos de una función de transferencia, construir la función de transferencia G(s), obtener su ecuación característica y generar el Lugar de las Raíces (Root Locus).

Posteriormente, el usuario puede modificar la ubicación de los polos de manera interactiva para obtener una nueva ecuación característica y calcular el compensador C(s).

El programa realiza los cálculos sin utilizar Control System Toolbox.

---

## Cómo ejecutar el programa

1. Abrir MATLAB.
2. Abrir el archivo `ProyectoCorto3.m`.
3. Presionar el botón **Run** para ejecutar el programa.
4. El programa solicitará los ceros de la función de transferencia.

Ejemplo:

    Ingrese los CEROS de G(s) como vector (ejemplo [-2 -4]): [-2 -4]

También se puede escribir:

    -2 -4

Si la planta no posee ceros, ingresar:

    []

5. Después, el programa solicitará los polos.

Ejemplo:

    Ingrese los POLOS de G(s) como vector (ejemplo [-1 -3 -5]): [-1 -3 -5]

También se puede escribir:

    -1 -3 -5

6. El programa verifica que los datos introducidos sean numéricos. Si la entrada no es válida, se muestra un mensaje de error.

---

## Ejemplo de entrada

Para utilizar:

    Ceros = [-2 -4]
    Polos = [-1 -3 -5]

el programa construye:

    N(s) = s^2 + 6*s + 8

    D(s) = s^3 + 9*s^2 + 23*s + 15

Por lo tanto:

             N(s)
    G(s) = --------
             D(s)

El programa también obtiene la ecuación característica para realimentación unitaria:

    1 + K*G(s) = 0

por lo que:

    D(s) + K*N(s) = 0

---

# Uso de la ventana Root Locus

Después de realizar los cálculos iniciales se abre una ventana con el Lugar de las Raíces.

En esta gráfica aparecen diferentes símbolos que permiten identificar los elementos del sistema.

## X negras - Polos originales

Las **X negras** representan los polos originales de la planta G(s).

Por ejemplo, si se ingresan:

    Polos = [-1 -3 -5]

las X negras aparecen en:

    -1
    -3
    -5

Estos polos sirven como referencia para observar dónde se encontraban originalmente los polos de la planta.

Las X negras **no se pueden mover**.

---

## Círculos negros - Ceros originales

Los **círculos negros** representan los ceros originales de la planta G(s).

Por ejemplo, si se ingresan:

    Ceros = [-2 -4]

los círculos negros aparecen en:

    -2
    -4

Estos puntos también sirven como referencia para construir y visualizar el Lugar de las Raíces.

Los círculos negros **no se pueden mover**.

---

## X rojas - Polos seleccionables

Las **X rojas** representan los polos que el usuario puede utilizar para definir la nueva distribución de polos del sistema.

A diferencia de las X negras, las X rojas son interactivas.

El usuario puede:

### Mover un polo

Mantener presionada una **X roja** y arrastrarla.

El polo se moverá siguiendo el Lugar de las Raíces.

### Agregar un polo

Hacer **clic izquierdo** sobre el gráfico.

El programa agregará una nueva X roja en el punto correspondiente del Root Locus.

### Eliminar un polo

Hacer **clic derecho sobre una X roja**.

El polo seleccionado será eliminado.

### Finalizar la selección

Cuando se haya terminado de colocar los polos en las posiciones deseadas, presionar:

    ENTER

El programa continuará automáticamente con los cálculos.

---

## Resumen de símbolos

| Símbolo | Significado | ¿Se puede modificar? |
|---|---|---|
| X negra | Polo original de la planta G(s) | No |
| O negra | Cero original de la planta G(s) | No |
| X roja | Polo seleccionado para el diseño | Sí |

---

## Polos complejos

El programa permite trabajar con polos complejos.

Los polos complejos deben aparecer en pares conjugados.

Por ejemplo:

    [-1+2i -1-2i -5]

Durante la selección interactiva, el programa maneja automáticamente los pares conjugados.

Si se mueve o agrega un polo complejo, su correspondiente conjugado es considerado automáticamente.

---

# Resultados generados

Una vez que el usuario presiona **ENTER**, el programa utiliza los polos seleccionados para continuar con el diseño.

El programa muestra:

- Los polos seleccionados.
- La nueva ecuación característica.
- La función de transferencia deseada.
- El compensador C(s).
- El sistema compensado en lazo cerrado.
- Los polos deseados y los polos obtenidos.
- La respuesta al escalón del sistema original.
- La respuesta al escalón del sistema compensado.
- La respuesta de la planta G(s).
- La respuesta del compensador C(s).
- Los valores de estado estacionario.
- Un resumen final de los resultados.

---

## Gráfica Original vs Compensada

El programa genera una gráfica denominada:

    Respuesta Original vs Compensada

Esta gráfica permite comparar la respuesta al escalón del sistema original con la respuesta obtenida después de aplicar el compensador.

Esto permite observar el efecto producido por la nueva ubicación de los polos.

---

## Gráfica Planta y Compensador

También se genera una gráfica denominada:

    Respuesta Planta y Compensador

En esta gráfica se muestran por separado:

- Planta G(s)
- Compensador C(s)

Esto permite visualizar la respuesta correspondiente a cada uno de estos elementos.

---

## Consideraciones importantes

- Los polos no pueden dejarse completamente vacíos.
- Los ceros pueden dejarse vacíos utilizando `[]`.
- Los datos introducidos deben ser numéricos.
- Los polos y ceros complejos deben utilizar pares conjugados.
- La cantidad de ceros no puede ser mayor que la cantidad de polos.
- Las X negras y los círculos negros son referencias del sistema original.
- Las X rojas corresponden a los polos que pueden ser modificados por el usuario.
- Se debe presionar **ENTER** para finalizar la selección de polos y continuar con los cálculos.

---

## Autor

**Ennos Saldaña Caseres**  
**Carnet: 2023218432**
