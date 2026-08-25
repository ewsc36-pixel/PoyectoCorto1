clc;
clear;
close all;


%% =========================================================
% 1. INGRESO DE CEROS
% =========================================================

valido = false;

while valido == false

    entrada = input(['Ingrese los CEROS de G(s) como vector ' ...
                     '(ejemplo [-2 -4]): '], 's');

    ceros = str2num(entrada); %#ok<ST2NM>

    if isempty(ceros)

        % Se permite que no existan ceros.

        valido = true;

    elseif isnumeric(ceros) && isvector(ceros)

        valido = true;

    else

        fprintf('\nERROR: Debe ingresar solamente numeros.\n');
        fprintf('Ejemplo valido: [-2 -4]\n\n');

    end

end


%% =========================================================
% 2. INGRESO DE POLOS
% =========================================================

valido = false;

while valido == false

    entrada = input(['Ingrese los POLOS de G(s) como vector ' ...
                     '(ejemplo [-1 -3 -5]): '], 's');

    polos = str2num(entrada); %#ok<ST2NM>

    if isnumeric(polos) && isvector(polos) && ~isempty(polos)

        valido = true;

    else

        fprintf('\nERROR: Debe ingresar solamente numeros.\n');
        fprintf('Debe ingresar al menos un polo.\n');
        fprintf('Ejemplo valido: [-1 -3 -5]\n\n');

    end

end


%% =========================================================
% 3. CONVERTIR A VECTORES COLUMNA
% =========================================================

ceros = ceros(:);
polos = polos(:);


%% =========================================================
% 4. MOSTRAR DATOS
% =========================================================

fprintf('\n============================================\n');
fprintf('DATOS INTRODUCIDOS\n');
fprintf('============================================\n');

fprintf('\nCeros:\n');
disp(ceros);

fprintf('Polos:\n');
disp(polos);


%% =========================================================
% 5. CONSTRUIR NUMERADOR N(s)
% =========================================================

% Si tenemos un cero z:
%
%       factor = (s-z)
%
% Ejemplo:
%
% z = -2
%
%       s-(-2) = s+2
%
% Para:
%
% ceros = [-2 -4]
%
% N(s) = (s+2)(s+4)
%
% N(s) = s^2 + 6s + 8

num = 1;

for i = 1:length(ceros)

    num = conv(num,[1 -ceros(i)]);

end


%% =========================================================
% 6. CONSTRUIR DENOMINADOR D(s)
% =========================================================

% Si tenemos un polo p:
%
%       factor = (s-p)
%
% Para:
%
% polos = [-1 -3 -5]
%
% D(s) = (s+1)(s+3)(s+5)
%
% D(s) = s^3 + 9s^2 + 23s + 15

den = 1;

for i = 1:length(polos)

    den = conv(den,[1 -polos(i)]);

end


%% =========================================================
% 7. MOSTRAR NUMERADOR
% =========================================================

fprintf('\n============================================\n');
fprintf('NUMERADOR N(s)\n');
fprintf('============================================\n');

fprintf('\nN(s) = ');

mostrarPolinomio(num);


%% =========================================================
% 8. MOSTRAR DENOMINADOR
% =========================================================

fprintf('\n============================================\n');
fprintf('DENOMINADOR D(s)\n');
fprintf('============================================\n');

fprintf('\nD(s) = ');

mostrarPolinomio(den);


%% =========================================================
% 9. MOSTRAR FUNCION DE TRANSFERENCIA
% =========================================================

fprintf('\n============================================\n');
fprintf('FUNCION DE TRANSFERENCIA G(s)\n');
fprintf('============================================\n');

fprintf('\n             N(s)\n');
fprintf('G(s) = ----------------\n');
fprintf('             D(s)\n\n');

fprintf('             ');

mostrarPolinomio(num);

fprintf('G(s) = -------------------------------\n');

fprintf('             ');

mostrarPolinomio(den);


%% =========================================================
% 10. ECUACION CARACTERISTICA
% =========================================================

fprintf('\n============================================\n');
fprintf('ECUACION CARACTERISTICA\n');
fprintf('============================================\n');

% MATEMATICA:
%
% La funcion de transferencia es:
%
%             N(s)
% G(s) = -------------
%             D(s)
%
% Para lazo cerrado:
%
%       1 + K*G(s) = 0
%
% Sustituimos G(s):
%
%       1 + K*N(s)/D(s) = 0
%
% Multiplicamos por D(s):
%
%       D(s) + K*N(s) = 0
%
% Esta es la ECUACION CARACTERISTICA.


fprintf('\n1 + K*G(s) = 0\n');

fprintf('\nD(s) + K*N(s) = 0\n');


%% =========================================================
% 11. IGUALAR LONGITUD DE LOS POLINOMIOS
% =========================================================
%Zero () agrega ceros a la matriz de N o D dependiendo de la diferencia
% Ejemplo:
%
% D(s) = s^3 + 9s^2 + 23s + 15
%
% D = [1 9 23 15]
%
%
% N(s) = s^2 + 6s + 8
%
% N = [1 6 8]
%
%
% Para poder sumar:
%
% D = [1 9 23 15]
%
% N = [0 1 6 8]
%
%
% Entonces:
%
% D + K*N
%
% = [1 9 23 15]
% + K[0 1 6 8]
%
% = [1 9+K 23+6K 15+8K]


diferencia = length(den) - length(num);

if diferencia > 0

    num_alineado = [zeros(1,diferencia) num];

elseif diferencia < 0

    den = [zeros(1,-diferencia) den];

    num_alineado = num;

else

    num_alineado = num;

end


%% =========================================================
% 12. MOSTRAR ECUACION CARACTERISTICA
% =========================================================

fprintf('\nEcuacion caracteristica:\n\n');

mostrarCaracteristica(den,num_alineado);


%% =========================================================
% 13. SOLICITAR K
% =========================================================

valido = false;

while valido == false

    entrada = input(['\nIngrese el valor de K para Routh ' ...
                     '(K >= 0): '],'s');

    K = str2double(entrada);

    if ~isnan(K) && isreal(K) && K >= 0

        valido = true;

    else

        fprintf('\nERROR: K debe ser un numero real mayor o igual a 0.\n');

    end

end


%% =========================================================
% 14. ECUACION CARACTERISTICA PARA K
% =========================================================

% Matematicamente:
%
%       D(s) + K*N(s)
%
% Se calcula como:
%
%       coeficientes = D + K*N

coef = den + K*num_alineado;


fprintf('\n============================================\n');
fprintf('ECUACION CARACTERISTICA PARA K = %.4f\n',K);
fprintf('============================================\n');

fprintf('\n');

mostrarPolinomio(coef);


fprintf('\nCoeficientes:\n');

disp(coef);


%% =========================================================
% 15. TABLA DE ROUTH-HURWITZ
% =========================================================

% Si:
%
% P(s) = a_n*s^n + a_(n-1)*s^(n-1) + ...
%
% la primera fila contiene:
%
% a_n, a_(n-2), a_(n-4), ...
%
% segunda fila:
%
% a_(n-1), a_(n-3), a_(n-5), ...
%ceil() significa redondear hacia arriba.
% Las siguientes filas se calculan usando la formula
% de Routh-Hurwitz.


grado = length(coef)-1;

filas = grado+1;

columnas = ceil((grado+1)/2);

R = zeros(filas,columnas);


%% Primera fila
%R() FILA 1Empieza en la posición 1, avanza de 2 en 2 y llega hasta el final.
R(1,1:length(coef(1:2:end))) = ...
    coef(1:2:end);


%% Segunda fila
%COEF Empieza en la posición 2 y avanza de 2 en 2.
if length(coef) >= 2

    R(2,1:length(coef(2:2:end))) = ...
        coef(2:2:end);

end


%% =========================================================
% 16. CALCULAR RESTO DE TABLA
% =========================================================

for i = 3:filas

    for j = 1:columnas-1

        % Evitar division entre cero.

        if abs(R(i-1,1)) < 1e-12

            R(i-1,1) = 1e-12;

        end


        % Formula de Routh:
        %
        % R(i,j) =
        %
        % [R(i-1,1)*R(i-2,j+1)
        % -
        % R(i-2,1)*R(i-1,j+1)]
        %
        % /
        %
        % R(i-1,1)

        R(i,j) = ...
            ((R(i-1,1)*R(i-2,j+1)) ...
            -(R(i-2,1)*R(i-1,j+1))) ...
            / R(i-1,1);

    end

end


%% =========================================================
% 17. MOSTRAR TABLA DE ROUTH
% =========================================================

fprintf('\n============================================\n');
fprintf('TABLA DE ROUTH-HURWITZ\n');
fprintf('============================================\n');

disp(R);


%% =========================================================
% 18. PRIMERA COLUMNA
% =========================================================

primera_columna = R(:,1);

fprintf('\n============================================\n');
fprintf('PRIMERA COLUMNA DE ROUTH\n');
fprintf('============================================\n');

disp(primera_columna);


%% =========================================================
% 19. CAMBIOS DE SIGNO
% =========================================================

% Routh-Hurwitz:
%
% 0 cambios de signo:
%       Sistema estable
%
% 1 o mas cambios:
%       Sistema inestable
%
% El numero de cambios corresponde al numero
% de polos en el semiplano derecho.


cambios = 0;

for i = 1:length(primera_columna)-1

    if primera_columna(i)*primera_columna(i+1) < 0

        cambios = cambios+1;

    end

end


fprintf('\nCambios de signo = %d\n',cambios);


%% =========================================================
% 20. RESULTADO DE ESTABILIDAD
% =========================================================

fprintf('\n============================================\n');
fprintf('RESULTADO DE ESTABILIDAD\n');
fprintf('============================================\n');


if cambios == 0

    fprintf('\nSISTEMA ESTABLE\n');

    fprintf('Para K = %.4f no existen cambios de signo.\n',K);

else

    fprintf('\nSISTEMA INESTABLE\n');

    fprintf('Para K = %.4f existen %d cambios de signo.\n', ...
            K,cambios);

end


%% =========================================================
% 21. ROOT LOCUS
% =========================================================

% El Root Locus muestra como se mueven los polos
% de lazo cerrado cuando K varia.
%
% Partimos de:
%
%       D(s) + K*N(s) = 0
%
% Despejamos K:
%
%       K*N(s) = -D(s)
%
%       K = -D(s)/N(s)
%
%
% Un punto pertenece al Root Locus si K:
%
%       1. Es real
%       2. Es positivo
%
%
% Usamos:
%
%       s = sigma + j*omega
%
% Por eso:
%
% eje horizontal = sigma
% eje vertical   = j*omega


%% =========================================================
% 22. CREAR PLANO COMPLEJO
% =========================================================

x = linspace(-15,5,700);

y = linspace(-15,15,700);

[X,Y] = meshgrid(x,y);

S = X + 1i*Y;


%% =========================================================
% 23. EVALUAR D(s)
% =========================================================

D_eval = zeros(size(S));

for i = 1:length(den)

    potencia = length(den)-i;

    D_eval = D_eval + den(i)*S.^potencia;

end


%% =========================================================
% 24. EVALUAR N(s)
% =========================================================

N_eval = zeros(size(S));

for i = 1:length(num)

    potencia = length(num)-i;

    N_eval = N_eval + num(i)*S.^potencia;

end


%% =========================================================
% 25. CALCULAR K
% =========================================================

K_grid = -D_eval./N_eval;


%% =========================================================
% 26. SELECCIONAR ROOT LOCUS
% =========================================================

condicion = abs(imag(K_grid)) < 0.05;

condicion = condicion & real(K_grid) >= 0;


%% =========================================================
% 27. GRAFICA DEL ROOT LOCUS
% =========================================================

figure;

plot(real(S(condicion)), ...
     imag(S(condicion)), ...
     '.', ...
     'MarkerSize',3);

hold on;


%% =========================================================
% 28. EJE REAL sigma
% =========================================================

% Eje horizontal:
%
%       sigma = Re(s)


plot([-15 5],[0 0], ...
     'b-', ...
     'LineWidth',1.5);


%% =========================================================
% 29. EJE IMAGINARIO j*omega
% =========================================================

% Eje vertical:
%
%       j*omega = Im(s)
%
% Esta linea corresponde a:
%
%       sigma = 0
%
% Divide el plano en:
%
% sigma < 0 -> semiplano izquierdo
%
% sigma > 0 -> semiplano derecho


plot([0 0],[-15 15], ...
     'r-', ...
     'LineWidth',1.5);


%% =========================================================
% 30. GRAFICAR POLOS
% =========================================================

% Convencion:
%
% X = Polo


plot(real(polos), ...
     imag(polos), ...
     'x', ...
     'MarkerSize',13, ...
     'LineWidth',3);


%% =========================================================
% 31. GRAFICAR CEROS
% =========================================================

% Convencion:
%
% O = Cero


if ~isempty(ceros)

    plot(real(ceros), ...
         imag(ceros), ...
         'o', ...
         'MarkerSize',13, ...
         'LineWidth',3);

end


%% =========================================================
% 32. ETIQUETAS
% =========================================================

xlabel('\sigma');

ylabel('j\omega');


%% =========================================================
% 33. TITULO
% =========================================================

title('Lugar de las Raices - Root Locus');


%% =========================================================
% 34. CONFIGURACION DE LA GRAFICA
% =========================================================

grid on;

axis equal;

xlim([-30 30]);
ylim([-30 30]);


%% =========================================================
% 35. IDENTIFICAR SEMIPLANOS
% =========================================================



%% =========================================================
% 36. LEYENDA
% =========================================================

legend('Root Locus', ...
       'Eje \sigma', ...
       'Eje j\omega', ...
       'Polos de lazo abierto', ...
       'Ceros de lazo abierto', ...
       'Location','best');

hold off;


%% =========================================================
% FUNCION: MOSTRAR POLINOMIO
% =========================================================

function mostrarPolinomio(coef)

    grado = length(coef)-1;

    primero = true;

    for i = 1:length(coef)

        valor = coef(i);

        potencia = grado-(i-1);


        if abs(valor) < 1e-12

            continue;

        end


        % ---------------------------------------------
        % SIGNO
        % ---------------------------------------------

        if primero

            if valor < 0

                fprintf('-');

                valor = abs(valor);

            end

            primero = false;

        else

            if valor >= 0

                fprintf(' + ');

            else

                fprintf(' - ');

                valor = abs(valor);

            end

        end


        % ---------------------------------------------
        % TERMINO INDEPENDIENTE
        % ---------------------------------------------

        if potencia == 0

            fprintf('%.4g',valor);


        % ---------------------------------------------
        % TERMINO s
        % ---------------------------------------------

        elseif potencia == 1

            if abs(valor-1) < 1e-12

                fprintf('s');

            else

                fprintf('%.4g*s',valor);

            end


        % ---------------------------------------------
        % POTENCIAS MAYORES
        % ---------------------------------------------

        else

            if abs(valor-1) < 1e-12

                fprintf('s^%d',potencia);

            else

                fprintf('%.4g*s^%d',valor,potencia);

            end

        end

    end

    fprintf('\n');

end


%% =========================================================
% FUNCION: MOSTRAR ECUACION CARACTERISTICA
% =========================================================

function mostrarCaracteristica(den,num)

    grado = length(den)-1;

    primero = true;

    for i = 1:length(den)

        d = den(i);

        n = num(i);

        potencia = grado-(i-1);


        if abs(d) < 1e-12 && abs(n) < 1e-12

            continue;

        end


        % =================================================
        % SIGNO
        % =================================================

        if ~primero

            fprintf(' + ');

        end

        primero = false;


        % =================================================
        % TERMINO D(s)
        % =================================================

        if abs(d) > 1e-12

            if potencia == 0

                fprintf('%.4g',d);

            elseif potencia == 1

                if abs(d-1) < 1e-12

                    fprintf('s');

                else

                    fprintf('%.4g*s',d);

                end

            else

                if abs(d-1) < 1e-12

                    fprintf('s^%d',potencia);

                else

                    fprintf('%.4g*s^%d',d,potencia);

                end

            end

        end


        % =================================================
        % TERMINO K*N(s)
        % =================================================

        if abs(n) > 1e-12

            if abs(d) > 1e-12

                fprintf(' + ');

            end


            if potencia == 0

                if abs(n-1) < 1e-12

                    fprintf('K');

                else

                    fprintf('%.4g*K',n);

                end


            elseif potencia == 1

                if abs(n-1) < 1e-12

                    fprintf('K*s');

                else

                    fprintf('%.4g*K*s',n);

                end


            else

                if abs(n-1) < 1e-12

                    fprintf('K*s^%d',potencia);

                else

                    fprintf('%.4g*K*s^%d',n,potencia);

                end

            end

        end

    end


    fprintf(' = 0\n');

end