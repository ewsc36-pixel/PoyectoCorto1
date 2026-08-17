clc; 
clear; 
close all; 
 
%% PROYECTO: MODELO DE MOTOR DE CD DE PRIMER ORDEN 
 
disp('=============================================='); 
disp('   MODELO DE MOTOR DE CD - SISTEMA 1ER ORDEN'); 
disp('=============================================='); 
 
%% 1. INGRESO Y VALIDACION DE PARAMETROS

% Kt
while true
    entrada = input('Ingrese Kt: ', 's'); % S GUARDA COMO TEXTO
    Kt = str2double(entrada); % DEVUELVE SI ES UN NUMERO O NO LO ES

    if ~isnan(Kt) && isfinite(Kt) && isreal(Kt) && Kt > 0
        break;
    else
        fprintf('Error: Kt debe ser un numero positivo. Se permiten decimales.\n');
    end
end

% Ra
while true
    entrada = input('Ingrese Ra: ', 's');
    Ra = str2double(entrada);

    if ~isnan(Ra) && isfinite(Ra) && isreal(Ra) && Ra > 0
        break;
    else
        fprintf('Error: Ra debe ser un numero positivo. Se permiten decimales.\n');
    end
end

% b
while true
    entrada = input('Ingrese b: ', 's');
    b = str2double(entrada);

    if ~isnan(b) && isfinite(b) && isreal(b) && b > 0
        break;
    else
        fprintf('Error: b debe ser un numero positivo. Se permiten decimales.\n');
    end
end

% Kb
while true
    entrada = input('Ingrese Kb: ', 's');
    Kb = str2double(entrada);

    if ~isnan(Kb) && isfinite(Kb) && isreal(Kb) && Kb > 0
        break;
    else
        fprintf('Error: Kb debe ser un numero positivo. Se permiten decimales.\n');
    end
end

% J
while true
    entrada = input('Ingrese J: ', 's');
    J = str2double(entrada);

    if ~isnan(J) && isfinite(J) && isreal(J) && J > 0
        break;
    else
        fprintf('Error: J debe ser un numero positivo. Se permiten decimales.\n');
    end
end
 
%% 3. CALCULO DE KM Y TAU 
 
KM = Kt/(Ra*b + Kt*Kb); 
 
tau = (Ra*J)/(Ra*b + Kt*Kb); 
 
%% 4. MOSTRAR RESULTADOS 
 
fprintf('\n==============================================\n'); 
fprintf('             RESULTADOS DEL SISTEMA\n'); 
fprintf('==============================================\n'); 
 
fprintf('Kt  = %.6f\n', Kt); 
fprintf('Ra  = %.6f\n', Ra); 
fprintf('b   = %.6f\n', b); 
fprintf('Kb  = %.6f\n', Kb); 
fprintf('J   = %.6f\n', J); 
 
fprintf('\nGanancia KM:\n'); 
fprintf('KM = %.6f\n', KM); 
 
fprintf('\nConstante de tiempo:\n'); 
fprintf('tau = %.6f s\n', tau); 
 
%% 5. FUNCION DE TRANSFERENCIA 
 
fprintf('\n==============================================\n'); 
fprintf('          FUNCION DE TRANSFERENCIA\n'); 
fprintf('==============================================\n'); 
 
fprintf('G(s) = %.6f / (%.6f s + 1)\n', KM, tau); 
 
%% 6. CALCULOS DE LA RESPUESTA 
 
% Tiempo t = tau 
t_tau = tau; 
 
% Tiempo de asentamiento al 2% 
t_s = 4*tau; 
 
% Tiempo t = 5tau 
t_5tau = 5*tau; 
 
% Respuesta en t = tau 
y_tau = KM*(1 - exp(-t_tau/tau)); 
 
% Respuesta en t = 5tau 
y_5tau = KM*(1 - exp(-t_5tau/tau)); 
 
% Valor final esperado en t = 5tau
y_final = y_5tau; 
 
% Error de estado estacionario aproximado en 5tau
ess = abs(1 - y_5tau); 

% Limites de la banda del 2%
limite_inferior = 0.98*y_final;
limite_superior = 1.02*y_final;
 
%% 7. MOSTRAR VALORES 
 
fprintf('\n==============================================\n'); 
fprintf('          PARAMETROS DE LA RESPUESTA\n'); 
fprintf('==============================================\n'); 
 
fprintf('Valor final esperado (5tau) = %.6f\n', y_final); 
 
fprintf('Respuesta en t = tau = %.6f\n', y_tau); 
 
fprintf('Respuesta en t = 5tau = %.6f\n', y_5tau); 
 
fprintf('Tiempo de asentamiento (2%%) = %.6f s\n', t_s); 
 
fprintf('Error de estado estacionario = %.6f\n', ess); 
 
%% 8. GENERAR RESPUESTA AL ESCALON 
 
t = linspace(0, 5*tau, 1000); 
 
% Respuesta del sistema de primer orden 
y = KM*(1 - exp(-t/tau)); 
 
%% 9. GRAFICA 
 
figure; 
 
plot(t, y, 'LineWidth', 2); 
hold on; 
grid on; 
 
% Valor final esperado en t = 5tau 
plot([0 5*tau], [y_final y_final], '--'); 
 
% Punto en t = tau 
plot(t_tau, y_tau, 'o', ... 
    'MarkerSize', 8, ... 
    'LineWidth', 2); 
 
% Linea vertical t = tau 
plot([t_tau t_tau], [0 y_tau], '--'); 
 
% Punto en t = 5tau 
plot(t_5tau, y_5tau, 'o', ... 
    'MarkerSize', 8, ... 
    'LineWidth', 2); 
 
% Linea vertical t = 5tau 
plot([t_5tau t_5tau], [0 y_5tau], '--'); 
 
% Tiempo de asentamiento 
plot([t_s t_s], [0 y_final], '-.'); 
 
% Banda inferior del 2% 
plot([0 5*tau], [limite_inferior limite_inferior], ':'); 
 
% Banda superior del 2% 
plot([0 5*tau], [limite_superior limite_superior], ':'); 

% ERROR DE ESTADO ESTACIONARIO
% Se muestra entre la referencia unitaria y el valor en 5tau
if ess > 0
    plot([0.5*tau 0.5*tau], [y_5tau 1], '-.', ...
        'LineWidth', 1.5);
end
 
%% 10. ETIQUETAS 
 
text(t_tau, y_tau, ... 
    sprintf('  y(tau) = %.4f', y_tau), ... 
    'VerticalAlignment', 'bottom'); 
 
text(t_5tau, y_5tau, ... 
    sprintf('  y(5tau) = %.4f', y_5tau), ... 
    'VerticalAlignment', 'bottom'); 
 
text(t_s, 0.5*y_final, ... 
    sprintf('  ts = %.4f s', t_s), ... 
    'VerticalAlignment', 'bottom'); 
 
text(0.1, y_final, ... 
    sprintf('  Valor final = %.4f', y_final), ... 
    'VerticalAlignment', 'bottom'); 

% Etiqueta del error de estado estacionario
if ess > 0
    text(0.5*tau, (1 + y_5tau)/2, ...
        sprintf('  e_{ss} = %.4f', ess), ...
        'VerticalAlignment', 'middle');
end
 
%% 11. TITULOS 
 
title('Respuesta al escalon unitario del motor de CD'); 
 
xlabel('Tiempo (s)'); 
ylabel('Respuesta y(t)'); 
 
legend('Respuesta del sistema', ... 
       'Valor final esperado', ... 
       't = tau', ... 
       '', ... 
       't = 5tau', ... 
       '', ... 
       'Tiempo de asentamiento', ... 
       'Banda -2%', ... 
       'Banda +2%', ...
       'Error de estado estacionario', ...
       'Location', 'southeast'); 
 
hold off;