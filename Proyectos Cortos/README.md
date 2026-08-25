# Proyecto Corto 1 - Modelo de Motor de CD

## Información del estudiante

**Nombre:** Ennos Saldaña Caseres  
**Carné:** 2023218432

## Descripción

Este proyecto implementa en MATLAB el modelado de un motor de corriente directa (CD) como un sistema de primer orden.

El sistema utiliza la función de transferencia:

G(s) = KM / (tau*s + 1)

donde los parámetros KM y tau se calculan a partir de:

KM = Kt / (Ra*b + Kt*Kb)

tau = (Ra*J) / (Ra*b + Kt*Kb)

## Parámetros de entrada

El programa solicita los siguientes parámetros:

- Kt: Constante del motor
- Ra: Resistencia de armadura
- b: Coeficiente de fricción
- Kb: Constante de fuerza contraelectromotriz
- J: Momento de inercia

Los valores ingresados deben ser números reales positivos. Se permiten valores decimales.

## Instrucciones de uso

1. Abrir MATLAB.
2. Descargar o clonar este repositorio.
3. Abrir el archivo `ProyectoCorto1.m`.
4. Ejecutar el programa.
5. Ingresar los valores solicitados:
   - Kt
   - Ra
   - b
   - Kb
   - J
6. El programa calcula automáticamente:
   - La ganancia `KM`.
   - La constante de tiempo `tau`.
   - La función de transferencia.
   - La respuesta al escalón unitario.
   - La respuesta en `t = tau`.
   - La respuesta en `t = 5tau`.
   - El error de estado estacionario.
   - El tiempo de asentamiento al 2%.

## Resultados gráficos

La gráfica muestra:

- Curva de respuesta del sistema.
- Valor final esperado en `t = 5tau`.
- Error de estado estacionario cuando es visible.
- Valor de la respuesta en `t = tau`.
- Tiempo de asentamiento al 2%.
- Banda de tolerancia del ±2%.

## Requisitos

- MATLAB
- No requiere Control System Toolbox.
