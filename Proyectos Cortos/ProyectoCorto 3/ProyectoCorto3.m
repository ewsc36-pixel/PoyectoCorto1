clc;
clear;
close all;


%% =========================================================
%                  PROYECTO CORTO #3
%            DISEÑO INTERACTIVO DE POLOS
%
% NO REQUIERE CONTROL SYSTEM TOOLBOX
%
% El programa:
%
% 1. Recibe ceros y polos.
% 2. Verifica que sean numeros.
% 3. Construye N(s) y D(s).
% 4. Construye G(s).
% 5. Extrae la ecuacion caracteristica.
% 6. Calcula el Root Locus manualmente.
% 7. Permite arrastrar polos.
% 8. Permite agregar polos.
% 9. Permite eliminar polos.
% 10. Mantiene pares conjugados.
% 11. Genera nueva ecuacion caracteristica.
% 12. Calcula el compensador C(s).
% 13. Reconstruye el sistema compensado.
% 14. Compara respuestas al escalon.
%
%% =========================================================


fprintf('============================================\n');
fprintf('           PROYECTO CORTO #3\n');
fprintf('      DISEÑO INTERACTIVO DE POLOS\n');
fprintf('============================================\n\n');


%% =========================================================
% 1. INGRESO DE CEROS
% =========================================================

valido = false;


while valido == false

    entrada = input( ...
        ['Ingrese los CEROS de G(s) como vector ' ...
         '(ejemplo [-2 -4]): '], ...
        's');


    % -----------------------------------------------------
    % Revisar letras no permitidas.
    %
    % Se permiten:
    %
    % i, j -> numeros complejos
    % e    -> notacion cientifica
    %
    % Ejemplo:
    %
    % [-1+2i -1-2i]
    % -----------------------------------------------------

    letrasInvalidas = regexp( ...
        entrada, ...
        '[a-df-hk-zA-DF-HK-Z]', ...
        'once');


    if ~isempty(letrasInvalidas)

        fprintf('\nERROR: Debe ingresar solamente numeros.\n');

        fprintf('Ejemplo valido: [-2 -4]\n');

        fprintf('Si no existen ceros use: []\n\n');

        continue;

    end


    % -----------------------------------------------------
    % Permitir planta sin ceros
    % -----------------------------------------------------

    if isempty(strtrim(entrada)) || ...
       strcmp(strtrim(entrada),'[]')

        ceros = [];

        valido = true;

        continue;

    end


    % -----------------------------------------------------
    % Convertir entrada
    % -----------------------------------------------------

    ceros = str2num(entrada); %#ok<ST2NM>


    if isempty(ceros)

        fprintf('\nERROR: Entrada no valida.\n');

        fprintf('Debe ingresar solamente numeros.\n');

        fprintf('Ejemplo valido: [-2 -4]\n\n');


    elseif isnumeric(ceros) && ...
           isvector(ceros) && ...
           all(isfinite(ceros))

        valido = true;


    else

        fprintf('\nERROR: Debe ingresar un vector numerico.\n');

        fprintf('Ejemplo valido: [-2 -4]\n\n');

    end

end


%% =========================================================
% 2. INGRESO DE POLOS
% =========================================================

valido = false;


while valido == false

    entrada = input( ...
        ['Ingrese los POLOS de G(s) como vector ' ...
         '(ejemplo [-1 -3 -5]): '], ...
        's');


    % -----------------------------------------------------
    % Revisar letras
    % -----------------------------------------------------

    letrasInvalidas = regexp( ...
        entrada, ...
        '[a-df-hk-zA-DF-HK-Z]', ...
        'once');


    if ~isempty(letrasInvalidas)

        fprintf('\nERROR: Debe ingresar solamente numeros.\n');

        fprintf('Ejemplo valido: [-1 -3 -5]\n\n');

        continue;

    end


    % -----------------------------------------------------
    % No se permiten polos vacios
    % -----------------------------------------------------

    if isempty(strtrim(entrada))

        fprintf('\nERROR: Debe ingresar al menos un polo.\n\n');

        continue;

    end


    polos = str2num(entrada); %#ok<ST2NM>


    if isnumeric(polos) && ...
       isvector(polos) && ...
       ~isempty(polos) && ...
       all(isfinite(polos))

        valido = true;


    else

        fprintf('\nERROR: Debe ingresar solamente numeros.\n');

        fprintf('Debe ingresar al menos un polo.\n');

        fprintf('Ejemplo valido: [-1 -3 -5]\n\n');

    end

end


%% =========================================================
% 3. CONVERTIR A VECTOR COLUMNA
% =========================================================

ceros = ceros(:);

polos = polos(:);


%% =========================================================
% 4. NORMALIZAR NUMEROS COMPLEJOS
% =========================================================
%
% Si MATLAB genera algo como:
%
%       -3 + 1e-13j
%
% realmente debe considerarse:
%
%       -3
%
%% =========================================================

ceros = normalizarRaices(ceros);

polos = normalizarRaices(polos);


%% =========================================================
% 5. VERIFICAR PARES CONJUGADOS EN ENTRADA
% =========================================================

if ~verificarConjugados(polos)

    fprintf('\nERROR:\n');

    fprintf(['Los polos complejos deben ingresarse ' ...
             'en pares conjugados.\n']);

    fprintf('\nEjemplo:\n');

    fprintf('[-1+2i -1-2i -5]\n\n');

    return;

end


if ~verificarConjugados(ceros)

    fprintf('\nERROR:\n');

    fprintf(['Los ceros complejos deben ingresarse ' ...
             'en pares conjugados.\n']);

    return;

end


%% =========================================================
% 6. VERIFICAR SISTEMA PROPIO
% =========================================================

if length(ceros) > length(polos)

    fprintf('\nERROR:\n');

    fprintf(['La cantidad de ceros no puede ser mayor ' ...
             'que la cantidad de polos.\n']);

    return;

end


%% =========================================================
% 7. MOSTRAR DATOS
% =========================================================

fprintf('\n============================================\n');

fprintf('DATOS INTRODUCIDOS\n');

fprintf('============================================\n');


fprintf('\nCeros:\n');


if isempty(ceros)

    fprintf('La planta no posee ceros.\n');

else

    disp(ceros);

end


fprintf('\nPolos:\n');

disp(polos);


%% =========================================================
% 8. CONSTRUIR NUMERADOR N(s)
% =========================================================
%
% Para cada cero:
%
%       z
%
% se forma:
%
%       (s-z)
%
% Ejemplo:
%
% z = -2
%
%       (s+2)
%
%% =========================================================

num = 1;


for i = 1:length(ceros)

    num = conv( ...
        num, ...
        [1 -ceros(i)]);

end


num = limpiarCoeficientes(num);


%% =========================================================
% 9. CONSTRUIR DENOMINADOR D(s)
% =========================================================

den = 1;


for i = 1:length(polos)

    den = conv( ...
        den, ...
        [1 -polos(i)]);

end


den = limpiarCoeficientes(den);


%% =========================================================
% 10. MOSTRAR NUMERADOR
% =========================================================

fprintf('\n============================================\n');

fprintf('NUMERADOR N(s)\n');

fprintf('============================================\n');


fprintf('\nN(s) = ');

mostrarPolinomio(num);


%% =========================================================
% 11. MOSTRAR DENOMINADOR
% =========================================================

fprintf('\n============================================\n');

fprintf('DENOMINADOR D(s)\n');

fprintf('============================================\n');


fprintf('\nD(s) = ');

mostrarPolinomio(den);


%% =========================================================
% 12. MOSTRAR G(s)
% =========================================================

fprintf('\n============================================\n');

fprintf('FUNCION DE TRANSFERENCIA G(s)\n');

fprintf('============================================\n');


fprintf('\nNumerador:\n');

mostrarPolinomio(num);


fprintf('\nDenominador:\n');

mostrarPolinomio(den);


fprintf('\nPor lo tanto:\n\n');

fprintf('              N(s)\n');

fprintf('G(s) = --------------------\n');

fprintf('              D(s)\n\n');


%% =========================================================
% 13. ECUACION CARACTERISTICA
% =========================================================
%
% Para realimentacion unitaria:
%
%       1 + K*G(s) = 0
%
% Si:
%
%              N(s)
% G(s) = ----------------
%              D(s)
%
% entonces:
%
%       D(s) + K*N(s) = 0
%
%% =========================================================

fprintf('\n============================================\n');

fprintf('ECUACION CARACTERISTICA\n');

fprintf('============================================\n');


fprintf('\n1 + K*G(s) = 0\n');

fprintf('\nD(s) + K*N(s) = 0\n');


%% =========================================================
% 14. ALINEAR POLINOMIOS
% =========================================================

longitud = max( ...
    length(den), ...
    length(num));


den_alineado = [ ...
    zeros(1,longitud-length(den)) ...
    den];


num_alineado = [ ...
    zeros(1,longitud-length(num)) ...
    num];


%% =========================================================
% 15. MOSTRAR ECUACION CARACTERISTICA GENERAL
% =========================================================

fprintf('\nEcuacion caracteristica general:\n\n');


mostrarCaracteristica( ...
    den_alineado, ...
    num_alineado);


%% =========================================================
% 16. CALCULAR ROOT LOCUS EXACTAMENTE
% =========================================================
%
% No se utiliza una cuadricula aproximada.
%
% Para muchos valores reales de K:
%
%       D(s) + K*N(s) = 0
%
% calculamos directamente sus raices mediante:
%
%       roots()
%
% Por lo tanto los puntos pertenecen realmente
% al lugar de las raices.
%
%% =========================================================

fprintf('\n============================================\n');

fprintf('CALCULANDO ROOT LOCUS\n');

fprintf('============================================\n');


% ---------------------------------------------------------
% Valores de K
%
% Se utilizan muchos valores para obtener una curva suave.
% ---------------------------------------------------------

Kvalores = unique([ ...
    0 ...
    logspace(-5,3,3500)]);


numeroRamas = length(den)-1;


RL = zeros( ...
    numeroRamas, ...
    length(Kvalores));


%% =========================================================
% 17. PRIMER PUNTO K = 0
% =========================================================

coefK = ...
    den_alineado + ...
    Kvalores(1)*num_alineado;


raicesActuales = roots(coefK);


raicesActuales = ...
    normalizarRaices(raicesActuales);


% Orden inicial

[~,orden] = sort(real(raicesActuales));


RL(:,1) = ...
    raicesActuales(orden);


%% =========================================================
% 18. CALCULAR TODAS LAS RAMAS
% =========================================================

for k = 2:length(Kvalores)

    Kactual = Kvalores(k);


    coefK = ...
        den_alineado + ...
        Kactual*num_alineado;


    nuevasRaices = roots(coefK);


    nuevasRaices = ...
        normalizarRaices(nuevasRaices);


    % -----------------------------------------------------
    % Mantener continuidad de las ramas
    %
    % Se asocia cada nueva raiz con la raiz anterior
    % mas cercana.
    % -----------------------------------------------------

    nuevasRaices = ...
        ordenarRaicesPorCercania( ...
            RL(:,k-1), ...
            nuevasRaices);


    RL(:,k) = nuevasRaices;

end


fprintf('\nRoot Locus calculado correctamente.\n');


%% =========================================================
% 19. CALCULAR POLOS PARA K = 1
% =========================================================

K_inicial = 1;


coef_inicial = ...
    den_alineado + ...
    K_inicial*num_alineado;


polosIniciales = roots(coef_inicial);


polosIniciales = ...
    normalizarRaices(polosIniciales);


fprintf('\nPolos de lazo cerrado para K = 1:\n\n');

disp(polosIniciales);


%% =========================================================
% 20. CREAR GRAFICA ROOT LOCUS
% =========================================================

fig = figure( ...
    'Name', ...
    'Proyecto Corto #3 - Root Locus Interactivo', ...
    'NumberTitle','off');


ax = axes( ...
    'Parent',fig);


hold(ax,'on');

grid(ax,'on');

box(ax,'on');


%% =========================================================
% 21. GRAFICAR RAMAS
% =========================================================

for rama = 1:numeroRamas

    plot( ...
        ax, ...
        real(RL(rama,:)), ...
        imag(RL(rama,:)), ...
        'LineWidth',1.4, ...
        'HitTest','off');

end


%% =========================================================
% 22. EJE REAL
% =========================================================

plot( ...
    ax, ...
    [-30 10], ...
    [0 0], ...
    'b-', ...
    'LineWidth',1.2, ...
    'HitTest','off');


%% =========================================================
% 23. EJE IMAGINARIO
% =========================================================

plot( ...
    ax, ...
    [0 0], ...
    [-20 20], ...
    'r-', ...
    'LineWidth',1.2, ...
    'HitTest','off');


%% =========================================================
% 24. POLOS DE LAZO ABIERTO
% =========================================================

plot( ...
    ax, ...
    real(polos), ...
    imag(polos), ...
    'kx', ...
    'MarkerSize',12, ...
    'LineWidth',2.5, ...
    'HitTest','off');


%% =========================================================
% 25. CEROS DE LAZO ABIERTO
% =========================================================

if ~isempty(ceros)

    plot( ...
        ax, ...
        real(ceros), ...
        imag(ceros), ...
        'ko', ...
        'MarkerSize',11, ...
        'LineWidth',2.5, ...
        'HitTest','off');

end


%% =========================================================
% 26. CONFIGURAR GRAFICA
% =========================================================

xlabel(ax,'\sigma');

ylabel(ax,'j\omega');


title( ...
    ax, ...
    { ...
    'Lugar de las Raices - Root Locus'; ...
    'X rojas = polos seleccionables'});


xlim(ax,[-30 10]);

ylim(ax,[-20 20]);


%% =========================================================
% 27. GUARDAR INFORMACION
% =========================================================

datos.ax = ax;

datos.RL = RL;

datos.Kvalores = Kvalores;

datos.polosSeleccionados = ...
    polosIniciales(:);

datos.indiceArrastrado = [];

datos.finalizado = false;


guidata(fig,datos);


%% =========================================================
% 28. DIBUJAR POLOS EDITABLES
% =========================================================

dibujarPolosEditables(fig);


%% =========================================================
% 29. INSTRUCCIONES
% =========================================================

annotation( ...
    fig, ...
    'textbox', ...
    [0.68 0.65 0.29 0.29], ...
    'String',{ ...
    'CONTROLES:', ...
    '', ...
    'Arrastrar X roja:', ...
    'Mover polo sobre Root Locus.', ...
    '', ...
    'Clic izquierdo:', ...
    'Agregar polo.', ...
    '', ...
    'Clic derecho en X roja:', ...
    'Eliminar polo.', ...
    '', ...
    'ENTER:', ...
    'Finalizar seleccion.'}, ...
    'BackgroundColor','white', ...
    'FitBoxToText','on');


%% =========================================================
% 30. CALLBACKS
% =========================================================

set( ...
    fig, ...
    'WindowButtonDownFcn', ...
    @clicFigura);


set( ...
    fig, ...
    'WindowKeyPressFcn', ...
    @presionarTecla);


fprintf('\n============================================\n');

fprintf('SELECCION INTERACTIVA DE POLOS\n');

fprintf('============================================\n');


fprintf('\nEn la ventana del Root Locus puede:\n\n');

fprintf('1. Arrastrar una X roja para mover un polo.\n');

fprintf('2. Clic izquierdo para agregar un polo.\n');

fprintf('3. Clic derecho sobre X roja para eliminarla.\n');

fprintf('4. Presionar ENTER para finalizar.\n\n');


fprintf(['IMPORTANTE: Los polos complejos se manejan ' ...
         'automaticamente con su conjugado.\n\n']);


%% =========================================================
% 31. ESPERAR AL USUARIO
% =========================================================

uiwait(fig);


%% =========================================================
% 32. VERIFICAR VENTANA
% =========================================================

if ~ishandle(fig)

    fprintf('\nLa ventana fue cerrada.\n');

    return;

end


%% =========================================================
% 33. OBTENER POLOS SELECCIONADOS
% =========================================================

datos = guidata(fig);


nuevosPolos = ...
    datos.polosSeleccionados(:);


%% =========================================================
% 34. NORMALIZAR POLOS
% =========================================================

nuevosPolos = ...
    normalizarRaices(nuevosPolos);


%% =========================================================
% 35. GARANTIZAR PARES CONJUGADOS
% =========================================================

nuevosPolos = ...
    completarConjugados(nuevosPolos);


nuevosPolos = ...
    normalizarRaices(nuevosPolos);


fprintf('\n============================================\n');

fprintf('POLOS SELECCIONADOS\n');

fprintf('============================================\n\n');


for i = 1:length(nuevosPolos)

    p = nuevosPolos(i);


    if abs(imag(p)) < 1e-9

        fprintf( ...
            'Polo %d = %.6f\n', ...
            i, ...
            real(p));

    else

        fprintf( ...
            'Polo %d = %.6f %+.6fj\n', ...
            i, ...
            real(p), ...
            imag(p));

    end

end


%% =========================================================
% 36. VERIFICAR POLOS
% =========================================================

if isempty(nuevosPolos)

    fprintf('\nERROR: Debe existir al menos un polo.\n');

    return;

end


if ~verificarConjugados(nuevosPolos)

    fprintf('\nERROR INTERNO:\n');

    fprintf('No fue posible formar pares conjugados.\n');

    return;

end


%% =========================================================
% 37. NUEVA ECUACION CARACTERISTICA
% =========================================================

coef_nuevo = 1;


for i = 1:length(nuevosPolos)

    coef_nuevo = conv( ...
        coef_nuevo, ...
        [1 -nuevosPolos(i)]);

end


coef_nuevo = ...
    limpiarCoeficientes(coef_nuevo);


fprintf('\n============================================\n');

fprintf('NUEVA ECUACION CARACTERISTICA\n');

fprintf('============================================\n\n');


mostrarPolinomio(coef_nuevo);


fprintf('\nForma:\n\n');

fprintf('P_d(s) = 0\n');


%% =========================================================
% 38. VERIFICAR QUE LOS COEFICIENTES SEAN REALES
% =========================================================

if max(abs(imag(coef_nuevo))) > 1e-7

    fprintf('\nERROR:\n');

    fprintf(['La ecuacion caracteristica contiene ' ...
             'coeficientes complejos.\n']);

    return;

end


coef_nuevo = real(coef_nuevo);


%% =========================================================
% 39. SISTEMA DESEADO
% =========================================================
%
% Se construye:
%
%                 Kd
% Td(s) = --------------------
%                 Pd(s)
%
%
% Elegimos:
%
%       Kd = Pd(0)
%
% para:
%
%       Td(0) = 1
%
%% =========================================================

if abs(coef_nuevo(end)) > 1e-10

    Kd = coef_nuevo(end);

else

    Kd = 1;

    fprintf('\nADVERTENCIA:\n');

    fprintf(['Existe un polo en el origen. ' ...
             'Se utilizara Kd = 1.\n']);

end


num_deseado = Kd;

den_deseado = coef_nuevo;


fprintf('\n============================================\n');

fprintf('FUNCION DE TRANSFERENCIA DESEADA\n');

fprintf('============================================\n');


fprintf('\nNumerador:\n');

mostrarPolinomio(num_deseado);


fprintf('\nDenominador:\n');

mostrarPolinomio(den_deseado);


fprintf('\nGanancia DC deseada = ');

fprintf('%.6f\n', ...
    num_deseado / den_deseado(end));


%% =========================================================
% 40. CALCULAR COMPENSADOR C(s)
% =========================================================
%
% Para realimentacion unitaria:
%
%                  C(s)G(s)
% T(s) = -------------------------------
%               1 + C(s)G(s)
%
%
% Queremos:
%
%               Kd
% Td(s) = ----------------
%               Pd(s)
%
%
% Despejando:
%
%                Td(s)
% C(s) = -------------------------
%          G(s)[1-Td(s)]
%
%
% Como:
%
%              N(s)
% G(s) = ----------------
%              D(s)
%
%
% se obtiene:
%
%                 Kd*D(s)
% C(s) = -------------------------------
%          N(s)[Pd(s)-Kd]
%
%% =========================================================


%% =========================================================
% 41. Pd(s) - Kd
% =========================================================

Pd_menos_Kd = den_deseado;


Pd_menos_Kd(end) = ...
    Pd_menos_Kd(end) - Kd;


Pd_menos_Kd = ...
    limpiarCoeficientes(Pd_menos_Kd);


%% =========================================================
% 42. NUMERADOR Y DENOMINADOR DE C(s)
% =========================================================

num_comp = ...
    Kd*den;


den_comp = ...
    conv( ...
        num, ...
        Pd_menos_Kd);


num_comp = ...
    limpiarCoeficientes(num_comp);


den_comp = ...
    limpiarCoeficientes(den_comp);


%% =========================================================
% 43. MOSTRAR COMPENSADOR
% =========================================================

fprintf('\n============================================\n');

fprintf('COMPENSADOR C(s)\n');

fprintf('============================================\n');


fprintf('\nNumerador del compensador:\n');

mostrarPolinomio(num_comp);


fprintf('\nDenominador del compensador:\n');

mostrarPolinomio(den_comp);


fprintf('\nPor lo tanto:\n\n');

fprintf('              Nc(s)\n');

fprintf('C(s) = ----------------------\n');

fprintf('              Dc(s)\n');


%% =========================================================
% 44. VERIFICAR SISTEMA COMPENSADO
% =========================================================
%
% L(s) = C(s)G(s)
%
%                  Nc(s)N(s)
% L(s) = --------------------------------
%                  Dc(s)D(s)
%
%% =========================================================

num_L = ...
    conv( ...
        num_comp, ...
        num);


den_L = ...
    conv( ...
        den_comp, ...
        den);


num_L = ...
    limpiarCoeficientes(num_L);


den_L = ...
    limpiarCoeficientes(den_L);


%% =========================================================
% 45. LAZO CERRADO COMPENSADO
% =========================================================
%
%                    L(s)
% Tcomp(s) = -------------------
%                  1 + L(s)
%
%% =========================================================

den_comp_cerrado = ...
    sumarPolinomios( ...
        den_L, ...
        num_L);


num_comp_cerrado = ...
    num_L;


%% =========================================================
% 46. CANCELAR FACTORES COMUNES
% =========================================================

[num_comp_cerrado, ...
 den_comp_cerrado] = ...
    simplificarTransferencia( ...
        num_comp_cerrado, ...
        den_comp_cerrado);


num_comp_cerrado = ...
    limpiarCoeficientes(num_comp_cerrado);


den_comp_cerrado = ...
    limpiarCoeficientes(den_comp_cerrado);


%% =========================================================
% 47. MOSTRAR SISTEMA COMPENSADO
% =========================================================

fprintf('\n============================================\n');

fprintf('SISTEMA COMPENSADO EN LAZO CERRADO\n');

fprintf('============================================\n');


fprintf('\nNumerador:\n');

mostrarPolinomio(num_comp_cerrado);


fprintf('\nDenominador:\n');

mostrarPolinomio(den_comp_cerrado);


%% =========================================================
% 48. POLOS DEL SISTEMA COMPENSADO
% =========================================================

polosCompensados = ...
    roots(den_comp_cerrado);


polosCompensados = ...
    normalizarRaices(polosCompensados);


fprintf('\nPolos reales obtenidos del sistema compensado:\n\n');

disp(polosCompensados);


%% =========================================================
% 49. POLOS DESEADOS VS OBTENIDOS
% =========================================================

fprintf('\n============================================\n');

fprintf('VERIFICACION DE POLOS\n');

fprintf('============================================\n');


fprintf('\nPolos deseados:\n');

disp(sortRaices(nuevosPolos));


fprintf('\nPolos obtenidos:\n');

disp(sortRaices(polosCompensados));


%% =========================================================
% 50. SISTEMA ORIGINAL EN LAZO CERRADO
% =========================================================
%
% Para K = 1:
%
%                    N(s)
% T(s) = -----------------------------
%                  D(s)+N(s)
%
%% =========================================================

num_original_cerrado = num;


den_original_cerrado = ...
    sumarPolinomios( ...
        den, ...
        num);


%% =========================================================
% 51. ELEGIR TIEMPO DE SIMULACION
% =========================================================

todosPolos = [ ...
    roots(den_original_cerrado); ...
    nuevosPolos(:)];


tFinal = ...
    elegirTiempoSimulacion( ...
        todosPolos);


t = linspace( ...
    0, ...
    tFinal, ...
    1600);


%% =========================================================
% 52. RESPUESTA ORIGINAL
% =========================================================

[y_original,valido_original] = ...
    respuestaEscalonManual( ...
        num_original_cerrado, ...
        den_original_cerrado, ...
        t);


%% =========================================================
% 53. RESPUESTA COMPENSADA
% =========================================================

[y_compensada,valido_compensado] = ...
    respuestaEscalonManual( ...
        num_comp_cerrado, ...
        den_comp_cerrado, ...
        t);


%% =========================================================
% 54. GRAFICA ORIGINAL VS COMPENSADA
% =========================================================

if valido_original && valido_compensado

    figure( ...
        'Name', ...
        'Respuesta Original vs Compensada', ...
        'NumberTitle','off');


    plot( ...
        t, ...
        y_original, ...
        'LineWidth',1.8);


    hold on;


    plot( ...
        t, ...
        y_compensada, ...
        'LineWidth',1.8);


    grid on;

    box on;


    xlabel('Tiempo (s)');

    ylabel('Amplitud');


    title('Respuesta al escalon');


    legend( ...
        'Sistema original', ...
        'Sistema compensado', ...
        'Location','best');


else

    fprintf('\nADVERTENCIA:\n');

    fprintf(['No fue posible calcular alguna de las ' ...
             'respuestas al escalon.\n']);

end


%% =========================================================
% 55. RESPUESTA DE LA PLANTA G(s)
% =========================================================

[y_planta,valido_planta] = ...
    respuestaEscalonManual( ...
        num, ...
        den, ...
        t);


%% =========================================================
% 56. RESPUESTA DEL COMPENSADOR C(s)
% =========================================================

[y_controlador,valido_controlador] = ...
    respuestaEscalonManual( ...
        num_comp, ...
        den_comp, ...
        t);


%% =========================================================
% 57. MOSTRAR RESPUESTA PLANTA Y COMPENSADOR
% =========================================================

if valido_planta && valido_controlador

    figure( ...
        'Name', ...
        'Respuesta Planta y Compensador', ...
        'NumberTitle','off');


    plot( ...
        t, ...
        y_planta, ...
        'LineWidth',1.7);


    hold on;


    plot( ...
        t, ...
        y_controlador, ...
        'LineWidth',1.7);


    grid on;

    box on;


    xlabel('Tiempo (s)');

    ylabel('Amplitud');


    title('Respuesta de la planta y del compensador');


    legend( ...
        'Planta G(s)', ...
        'Compensador C(s)', ...
        'Location','best');

end


%% =========================================================
% 58. VALORES FINALES
% =========================================================

fprintf('\n============================================\n');

fprintf('VALORES DE ESTADO ESTACIONARIO\n');

fprintf('============================================\n');


if abs(den_original_cerrado(end)) > 1e-12

    valorFinalOriginal = ...
        num_original_cerrado(end) / ...
        den_original_cerrado(end);


    fprintf( ...
        '\nSistema original: %.6f\n', ...
        valorFinalOriginal);

end


if abs(den_comp_cerrado(end)) > 1e-12

    valorFinalCompensado = ...
        num_comp_cerrado(end) / ...
        den_comp_cerrado(end);


    fprintf( ...
        'Sistema compensado: %.6f\n', ...
        valorFinalCompensado);

end


%% =========================================================
% 59. RESUMEN FINAL
% =========================================================

fprintf('\n============================================\n');

fprintf('RESUMEN FINAL\n');

fprintf('============================================\n');


fprintf('\n1. Planta original:\n\n');


fprintf('N(s) = ');

mostrarPolinomio(num);


fprintf('D(s) = ');

mostrarPolinomio(den);


fprintf('\n2. Funcion de transferencia:\n');

fprintf('\nG(s) = N(s) / D(s)\n');


fprintf('\n3. Ecuacion caracteristica general:\n\n');


mostrarCaracteristica( ...
    den_alineado, ...
    num_alineado);


fprintf('\n4. Nueva ecuacion caracteristica:\n\n');

mostrarPolinomio(coef_nuevo);


fprintf('\n5. Compensador:\n');


fprintf('\nNumerador C(s):\n');

mostrarPolinomio(num_comp);


fprintf('\nDenominador C(s):\n');

mostrarPolinomio(den_comp);


fprintf('\n6. Sistema compensado:\n');


fprintf('\nNumerador:\n');

mostrarPolinomio(num_comp_cerrado);


fprintf('\nDenominador:\n');

mostrarPolinomio(den_comp_cerrado);


fprintf('\n============================================\n');

fprintf('PROYECTO FINALIZADO\n');

fprintf('============================================\n');



%% =========================================================
%%                  FUNCIONES LOCALES
%% =========================================================


%% =========================================================
% FUNCION: MOSTRAR POLINOMIO
% =========================================================

function mostrarPolinomio(coef)

    coef = limpiarCoeficientes(coef);


    grado = length(coef)-1;


    primero = true;


    for i = 1:length(coef)

        valor = coef(i);


        potencia = grado-(i-1);


        if abs(valor) < 1e-10

            continue;

        end


        % -------------------------------------------------
        % Si deberia ser real
        % -------------------------------------------------

        if abs(imag(valor)) < 1e-9

            valor = real(valor);


            % ---------------------------------------------
            % SIGNO
            % ---------------------------------------------

            if primero

                if valor < 0

                    fprintf('-');

                end


            else

                if valor >= 0

                    fprintf(' + ');

                else

                    fprintf(' - ');

                end

            end


            valorAbsoluto = abs(valor);


            % ---------------------------------------------
            % TERMINO CONSTANTE
            % ---------------------------------------------

            if potencia == 0

                fprintf( ...
                    '%.6g', ...
                    valorAbsoluto);


            % ---------------------------------------------
            % TERMINO s
            % ---------------------------------------------

            elseif potencia == 1

                if abs(valorAbsoluto-1) < 1e-10

                    fprintf('s');

                else

                    fprintf( ...
                        '%.6g*s', ...
                        valorAbsoluto);

                end


            % ---------------------------------------------
            % TERMINO s^n
            % ---------------------------------------------

            else

                if abs(valorAbsoluto-1) < 1e-10

                    fprintf( ...
                        's^%d', ...
                        potencia);

                else

                    fprintf( ...
                        '%.6g*s^%d', ...
                        valorAbsoluto, ...
                        potencia);

                end

            end


        else

            % ---------------------------------------------
            % Solamente deberia llegar aqui si realmente
            % existen coeficientes complejos.
            % ---------------------------------------------

            if ~primero

                fprintf(' + ');

            end


            fprintf( ...
                '(%.6g%+.6gj)', ...
                real(valor), ...
                imag(valor));


            if potencia == 1

                fprintf('*s');

            elseif potencia > 1

                fprintf( ...
                    '*s^%d', ...
                    potencia);

            end

        end


        primero = false;

    end


    if primero

        fprintf('0');

    end


    fprintf('\n');

end


%% =========================================================
% FUNCION: ECUACION CARACTERISTICA
% =========================================================

function mostrarCaracteristica(den,num)

    grado = length(den)-1;


    primero = true;


    for i = 1:length(den)

        d = den(i);

        n = num(i);


        potencia = grado-(i-1);


        if abs(d)<1e-12 && abs(n)<1e-12

            continue;

        end


        % -------------------------------------------------
        % SIGNO ENTRE TERMINOS
        % -------------------------------------------------

        if ~primero

            fprintf(' + ');

        end


        primero = false;


        % -------------------------------------------------
        % COEFICIENTE
        % -------------------------------------------------

        if abs(d)>1e-12 && ...
           abs(n)>1e-12

            % Ejemplo:
            %
            % (9 + K)
            %
            % en lugar de:
            %
            % (9 + 1*K)

            if abs(n-1)<1e-12

                fprintf( ...
                    '(%.6g + K)', ...
                    d);

            else

                fprintf( ...
                    '(%.6g + %.6g*K)', ...
                    d, ...
                    n);

            end


        elseif abs(d)>1e-12

            fprintf( ...
                '%.6g', ...
                d);


        else

            if abs(n-1)<1e-12

                fprintf('K');

            else

                fprintf( ...
                    '%.6g*K', ...
                    n);

            end

        end


        % -------------------------------------------------
        % VARIABLE
        % -------------------------------------------------

        if potencia == 1

            fprintf('*s');


        elseif potencia > 1

            fprintf( ...
                '*s^%d', ...
                potencia);

        end

    end


    fprintf(' = 0\n');

end


%% =========================================================
% FUNCION: ORDENAR RAICES
% =========================================================

function nuevas = ...
    ordenarRaicesPorCercania(anteriores,nuevas)


    anteriores = anteriores(:);

    nuevas = nuevas(:);


    n = length(anteriores);


    ordenadas = zeros(n,1);


    disponible = true(n,1);


    for i = 1:n

        distancias = ...
            abs(nuevas-anteriores(i));


        distancias(~disponible) = inf;


        [~,indice] = ...
            min(distancias);


        ordenadas(i) = ...
            nuevas(indice);


        disponible(indice) = false;

    end


    nuevas = ordenadas;

end


%% =========================================================
% FUNCION: NORMALIZAR RAICES
% =========================================================

function raices = normalizarRaices(raices)

    toleranciaReal = 1e-8;


    for i = 1:length(raices)

        if abs(imag(raices(i))) < toleranciaReal

            raices(i) = real(raices(i));

        end

    end

end


%% =========================================================
% FUNCION: COMPLETAR CONJUGADOS
% =========================================================

function polos = completarConjugados(polos)

    polos = polos(:);


    polos = normalizarRaices(polos);


    tolerancia = 1e-6;


    i = 1;


    while i <= length(polos)

        p = polos(i);


        if abs(imag(p)) > tolerancia

            conjugado = conj(p);


            existe = ...
                any(abs(polos-conjugado)<tolerancia);


            if ~existe

                polos(end+1,1) = conjugado;


                fprintf( ...
                    ['\nSe agrego automaticamente el ' ...
                     'polo conjugado:\n']);


                fprintf( ...
                    '%.6f %+.6fj\n', ...
                    real(conjugado), ...
                    imag(conjugado));

            end

        end


        i = i+1;

    end


    polos = normalizarRaices(polos);

end


%% =========================================================
% FUNCION: VERIFICAR CONJUGADOS
% =========================================================

function valido = verificarConjugados(polos)

    valido = true;


    if isempty(polos)

        return;

    end


    tolerancia = 1e-6;


    polos = normalizarRaices(polos);


    for i = 1:length(polos)

        p = polos(i);


        if abs(imag(p)) > tolerancia

            existe = ...
                any( ...
                    abs(polos-conj(p)) ...
                    < tolerancia);


            if ~existe

                valido = false;

                return;

            end

        end

    end

end


%% =========================================================
% FUNCION: DIBUJAR POLOS EDITABLES
% =========================================================

function dibujarPolosEditables(fig)

    datos = guidata(fig);


    ax = datos.ax;


    anteriores = findobj( ...
        ax, ...
        'Tag','PoloEditable');


    delete(anteriores);


    polos = ...
        datos.polosSeleccionados;


    for i = 1:length(polos)

        h = plot( ...
            ax, ...
            real(polos(i)), ...
            imag(polos(i)), ...
            'rx', ...
            'MarkerSize',14, ...
            'LineWidth',3, ...
            'Tag','PoloEditable');


        h.UserData = i;


        h.ButtonDownFcn = ...
            @seleccionarPolo;

    end

end


%% =========================================================
% FUNCION: SELECCIONAR POLO
% =========================================================

function seleccionarPolo(h,~)

    fig = ancestor( ...
        h, ...
        'figure');


    datos = guidata(fig);


    indice = h.UserData;


    tipo = ...
        get(fig,'SelectionType');


    poloActual = ...
        datos.polosSeleccionados(indice);


    % -----------------------------------------------------
    % CLIC DERECHO
    %
    % Eliminar polo.
    %
    % Si es complejo se elimina tambien su conjugado.
    % -----------------------------------------------------

    if strcmp(tipo,'alt')

        indicesEliminar = indice;


        if abs(imag(poloActual)) > 1e-6

            indiceConjugado = find( ...
                abs( ...
                    datos.polosSeleccionados - ...
                    conj(poloActual)) ...
                    < 1e-6);


            indicesEliminar = ...
                unique([ ...
                    indice ...
                    indiceConjugado(:).']);

        end


        datos.polosSeleccionados( ...
            indicesEliminar) = [];


        guidata(fig,datos);


        dibujarPolosEditables(fig);


        return;

    end


    % -----------------------------------------------------
    % CLIC IZQUIERDO
    %
    % Comenzar arrastre.
    % -----------------------------------------------------

    datos.indiceArrastrado = indice;


    guidata(fig,datos);


    set( ...
        fig, ...
        'WindowButtonMotionFcn', ...
        @moverPolo);


    set( ...
        fig, ...
        'WindowButtonUpFcn', ...
        @soltarPolo);

end


%% =========================================================
% FUNCION: MOVER POLO
% =========================================================

function moverPolo(fig,~)

    datos = guidata(fig);


    indice = ...
        datos.indiceArrastrado;


    if isempty(indice)

        return;

    end


    puntoMouse = ...
        datos.ax.CurrentPoint;


    mouse = ...
        puntoMouse(1,1) + ...
        1i*puntoMouse(1,2);


    % -----------------------------------------------------
    % Buscar el punto REAL del Root Locus mas cercano.
    %
    % Ya no se utiliza la cuadricula aproximada.
    % -----------------------------------------------------

    puntoNuevo = ...
        buscarPuntoRootLocus( ...
            datos.RL, ...
            mouse);


    puntoNuevo = ...
        normalizarRaices(puntoNuevo);


    poloAnterior = ...
        datos.polosSeleccionados(indice);


    % -----------------------------------------------------
    % Si el polo anterior era complejo, localizar
    % su conjugado.
    % -----------------------------------------------------

    indiceConjugado = [];


    if abs(imag(poloAnterior)) > 1e-6

        candidatos = find( ...
            abs( ...
                datos.polosSeleccionados - ...
                conj(poloAnterior)) ...
                < 1e-6);


        candidatos( ...
            candidatos == indice) = [];


        if ~isempty(candidatos)

            indiceConjugado = ...
                candidatos(1);

        end

    end


    % -----------------------------------------------------
    % Actualizar polo principal
    % -----------------------------------------------------

    datos.polosSeleccionados(indice) = ...
        puntoNuevo;


    % -----------------------------------------------------
    % Si el nuevo polo es complejo:
    %
    % mover/agregar automaticamente conjugado.
    % -----------------------------------------------------

    if abs(imag(puntoNuevo)) > 1e-6

        if ~isempty(indiceConjugado)

            datos.polosSeleccionados( ...
                indiceConjugado) = ...
                conj(puntoNuevo);

        else

            datos.polosSeleccionados( ...
                end+1) = ...
                conj(puntoNuevo);

        end


    else

        % -------------------------------------------------
        % Si el polo ahora es real y anteriormente tenia
        % conjugado, se mantiene como polo real repetido.
        % -------------------------------------------------

        if ~isempty(indiceConjugado)

            datos.polosSeleccionados( ...
                indiceConjugado) = ...
                puntoNuevo;

        end

    end


    datos.polosSeleccionados = ...
        normalizarRaices( ...
            datos.polosSeleccionados);


    guidata(fig,datos);


    dibujarPolosEditables(fig);

end


%% =========================================================
% FUNCION: SOLTAR POLO
% =========================================================

function soltarPolo(fig,~)

    datos = guidata(fig);


    datos.indiceArrastrado = [];


    guidata(fig,datos);


    set( ...
        fig, ...
        'WindowButtonMotionFcn','');


    set( ...
        fig, ...
        'WindowButtonUpFcn','');

end


%% =========================================================
% FUNCION: CLIC EN FIGURA
% =========================================================

function clicFigura(fig,~)

    objeto = hittest(fig);


    try

        etiqueta = get( ...
            objeto, ...
            'Tag');

    catch

        etiqueta = '';

    end


    % -----------------------------------------------------
    % Si hizo clic en polo existente, no agregar otro.
    % -----------------------------------------------------

    if strcmp( ...
            etiqueta, ...
            'PoloEditable')

        return;

    end


    % -----------------------------------------------------
    % Solo clic izquierdo
    % -----------------------------------------------------

    tipo = ...
        get(fig,'SelectionType');


    if ~strcmp(tipo,'normal')

        return;

    end


    datos = guidata(fig);


    puntoMouse = ...
        datos.ax.CurrentPoint;


    x = puntoMouse(1,1);

    y = puntoMouse(1,2);


    limitesX = ...
        xlim(datos.ax);


    limitesY = ...
        ylim(datos.ax);


    % -----------------------------------------------------
    % Verificar que el clic sea dentro del plano
    % -----------------------------------------------------

    if x < limitesX(1) || ...
       x > limitesX(2)

        return;

    end


    if y < limitesY(1) || ...
       y > limitesY(2)

        return;

    end


    mouse = x + 1i*y;


    % -----------------------------------------------------
    % Encontrar punto verdadero del Root Locus
    % -----------------------------------------------------

    nuevoPolo = ...
        buscarPuntoRootLocus( ...
            datos.RL, ...
            mouse);


    nuevoPolo = ...
        normalizarRaices(nuevoPolo);


    % -----------------------------------------------------
    % Agregar polo
    % -----------------------------------------------------

    datos.polosSeleccionados(end+1) = ...
        nuevoPolo;


    % -----------------------------------------------------
    % Si es complejo:
    %
    % agregar automaticamente conjugado.
    % -----------------------------------------------------

    if abs(imag(nuevoPolo)) > 1e-6

        conjugado = conj(nuevoPolo);


        existe = any( ...
            abs( ...
                datos.polosSeleccionados - ...
                conjugado) ...
                < 1e-6);


        if ~existe

            datos.polosSeleccionados(end+1) = ...
                conjugado;

        end

    end


    datos.polosSeleccionados = ...
        normalizarRaices( ...
            datos.polosSeleccionados);


    guidata(fig,datos);


    dibujarPolosEditables(fig);

end


%% =========================================================
% FUNCION: BUSCAR PUNTO ROOT LOCUS
% =========================================================

function punto = ...
    buscarPuntoRootLocus(RL,puntoMouse)


    todosPuntos = RL(:);


    todosPuntos = ...
        todosPuntos( ...
            isfinite(real(todosPuntos)) & ...
            isfinite(imag(todosPuntos)));


    distancias = ...
        abs(todosPuntos-puntoMouse);


    [~,indice] = ...
        min(distancias);


    punto = ...
        todosPuntos(indice);


    punto = ...
        normalizarRaices(punto);

end


%% =========================================================
% FUNCION: ENTER
% =========================================================

function presionarTecla(fig,event)

    if strcmp(event.Key,'return')

        datos = guidata(fig);


        if isempty( ...
                datos.polosSeleccionados)

            fprintf( ...
                '\nERROR: Debe existir al menos un polo.\n');

            return;

        end


        datos.polosSeleccionados = ...
            normalizarRaices( ...
                datos.polosSeleccionados);


        datos.polosSeleccionados = ...
            completarConjugados( ...
                datos.polosSeleccionados);


        guidata(fig,datos);


        uiresume(fig);

    end

end


%% =========================================================
% FUNCION: LIMPIAR COEFICIENTES
% =========================================================

function coef = limpiarCoeficientes(coef)

    tolerancia = 1e-8;


    coef(abs(coef)<tolerancia) = 0;


    % -----------------------------------------------------
    % Convertir pequeños residuos imaginarios a cero
    % -----------------------------------------------------

    if max(abs(imag(coef))) < tolerancia

        coef = real(coef);

    end


    % -----------------------------------------------------
    % Eliminar ceros iniciales
    % -----------------------------------------------------

    while length(coef)>1 && ...
          abs(coef(1))<tolerancia

        coef(1) = [];

    end

end


%% =========================================================
% FUNCION: SUMAR POLINOMIOS
% =========================================================

function resultado = ...
    sumarPolinomios(A,B)


    A = A(:).';

    B = B(:).';


    longitud = ...
        max(length(A),length(B));


    A = [ ...
        zeros(1,longitud-length(A)) ...
        A];


    B = [ ...
        zeros(1,longitud-length(B)) ...
        B];


    resultado = A+B;


    resultado = ...
        limpiarCoeficientes(resultado);

end


%% =========================================================
% FUNCION: SIMPLIFICAR TRANSFERENCIA
% =========================================================

function [numNuevo,denNuevo] = ...
    simplificarTransferencia(num,den)


    num = ...
        limpiarCoeficientes(num);


    den = ...
        limpiarCoeficientes(den);


    % -----------------------------------------------------
    % Si no existen raices suficientes no simplificar
    % -----------------------------------------------------

    if length(num)<=1 || ...
       length(den)<=1

        numNuevo = num;

        denNuevo = den;

        return;

    end


    ganancia = ...
        num(1)/den(1);


    ceros = roots(num);

    polos = roots(den);


    usados = ...
        false(size(polos));


    conservarCeros = ...
        true(size(ceros));


    tolerancia = 1e-4;


    % -----------------------------------------------------
    % Buscar ceros y polos comunes
    % -----------------------------------------------------

    for i = 1:length(ceros)

        distancias = ...
            abs(polos-ceros(i));


        distancias(usados) = inf;


        [distanciaMinima,j] = ...
            min(distancias);


        if distanciaMinima < tolerancia

            conservarCeros(i) = false;

            usados(j) = true;

        end

    end


    cerosRestantes = ...
        ceros(conservarCeros);


    polosRestantes = ...
        polos(~usados);


    % -----------------------------------------------------
    % Reconstruir numerador
    % -----------------------------------------------------

    if isempty(cerosRestantes)

        numNuevo = ganancia;

    else

        numNuevo = ...
            ganancia*poly(cerosRestantes);

    end


    % -----------------------------------------------------
    % Reconstruir denominador monico
    % -----------------------------------------------------

    if isempty(polosRestantes)

        denNuevo = 1;

    else

        denNuevo = ...
            poly(polosRestantes);

    end


    numNuevo = ...
        limpiarCoeficientes(numNuevo);


    denNuevo = ...
        limpiarCoeficientes(denNuevo);

end


%% =========================================================
% FUNCION: ORDENAR RAICES PARA MOSTRAR
% =========================================================

function salida = sortRaices(entrada)

    entrada = entrada(:);


    matriz = [ ...
        real(entrada) ...
        imag(entrada)];


    [~,indices] = ...
        sortrows(matriz,[1 2]);


    salida = entrada(indices);

end


%% =========================================================
% FUNCION: TIEMPO DE SIMULACION
% =========================================================

function tiempo = ...
    elegirTiempoSimulacion(polos)


    polos = polos(:);


    % -----------------------------------------------------
    % Solo mirar polos estables para estimar tiempo
    % -----------------------------------------------------

    magnitudesReales = ...
        abs(real(polos));


    magnitudesReales = ...
        magnitudesReales( ...
            magnitudesReales > 1e-3);


    if isempty(magnitudesReales)

        tiempo = 15;

        return;

    end


    poloDominante = ...
        min(magnitudesReales);


    tiempo = ...
        7/poloDominante;


    if tiempo < 5

        tiempo = 5;

    end


    if tiempo > 40

        tiempo = 40;

    end

end


%% =========================================================
% FUNCION: RESPUESTA AL ESCALON SIN TOOLBOX
% =========================================================

function [y,valido] = ...
    respuestaEscalonManual(num,den,t)


    valido = true;


    num = ...
        limpiarCoeficientes(num);


    den = ...
        limpiarCoeficientes(den);


    gradoNumerador = ...
        length(num)-1;


    gradoDenominador = ...
        length(den)-1;


    % -----------------------------------------------------
    % Sistema impropio
    % -----------------------------------------------------

    if gradoNumerador > gradoDenominador

        y = [];

        valido = false;

        return;

    end


    % -----------------------------------------------------
    % Sistema constante
    % -----------------------------------------------------

    if gradoDenominador == 0

        y = ...
            (num(1)/den(1))* ...
            ones(size(t));

        return;

    end


    % -----------------------------------------------------
    % Normalizar denominador
    % -----------------------------------------------------

    num = num/den(1);

    den = den/den(1);


    n = gradoDenominador;


    % -----------------------------------------------------
    % Completar numerador
    % -----------------------------------------------------

    num = [ ...
        zeros(1,n+1-length(num)) ...
        num];


    % -----------------------------------------------------
    % Denominador:
    %
    % s^n + a1*s^(n-1) + ... + an
    % -----------------------------------------------------

    a = den(2:end);


    % -----------------------------------------------------
    % Numerador:
    %
    % b0*s^n + b1*s^(n-1) + ... + bn
    % -----------------------------------------------------

    b0 = num(1);


    restoNumerador = ...
        num(2:end);


    %% =====================================================
    % FORMA CANONICA
    % =====================================================

    A = zeros(n,n);


    A(1,:) = -a;


    if n > 1

        A(2:n,1:n-1) = eye(n-1);

    end


    B = zeros(n,1);


    B(1) = 1;


    C = ...
        restoNumerador - ...
        b0*a;


    D = b0;


    %% =====================================================
    % CONDICIONES INICIALES
    % =====================================================

    x0 = zeros(n,1);


    %% =====================================================
    % ENTRADA ESCALON UNITARIO
    %
    % u(t) = 1
    %
    % dx/dt = A*x + B
    % =====================================================

    funcionEstado = ...
        @(tt,x) A*x+B;


    try

        [tout,xEstados] = ...
            ode45( ...
                funcionEstado, ...
                t, ...
                x0);


        salida = ...
            xEstados*C.' + D;


        y = interp1( ...
            tout, ...
            salida, ...
            t, ...
            'linear');


        y = real(y);


    catch

        y = [];

        valido = false;

    end

end