function dist = score(img1,img2,args )
%calculo de la distancia basada en DCT


%% Declaracion de variables

numCoeficientes = args{1};  %150;  % Numero de coeficientes DCT usados para distancia
vectorCarac1 = zeros(numCoeficientes,1);  %vectores de caracteristicas
vectorCarac2 = zeros(numCoeficientes,1);

P = args{2};   %0.8;  % valor de p en la normaP (norma fraccional)


%% Calculo de la DCT

D1 = dct2(img1);
D2 = dct2(img2);

%Tratamiento adicional

%D1 = abs(D1).^2;  %espectro de potencia
%D2 = abs(D2).^2;  
%D1 = log(1+D1);  
%D2 = log(1+D2);  %se disminuye rango con el logaritmo


%% Creacion vector caracteristicas. Recorrido en zig-zag dct

direccion = 2;  % 1->fila-columna  2->columna-fila
sig_fila = [1,0]; % movernos al siguiente punto eje X
sig_columna = [0,1]; %movernos al siguiente punto Y
mover_fila_columna = [-1,1];  % para movernos en esa direccion diagonal. En la matriz de abajo a arriba
mover_columna_fila = [1,-1];  % para movernos en esa dirección diagonal. En la matriz de arriba a abajo

coor = [1,1];  % inicializo coordenada elemento matriz DCT a pasar al vector de caracteristicas
vectorCarac1(1,1) = D1(coor(1,1),coor(1,2)); % Primer valor
vectorCarac2(1,1) = D2(coor(1,1),coor(1,2));
coor = [1,2]; % fijo el siguiente punto
for i = 2:numCoeficientes
    vectorCarac1(i,1) = D1(coor(1,1),coor(1,2));
    vectorCarac2(i,1) = D2(coor(1,1),coor(1,2));
    % actualizo coordenada siguiente elemento DCT a coger
    if (direccion == 1) && (coor(1,1) == 1)  % he llegado al limite, me muevo a la siguiente columna y cambio direccion
        coor = coor + sig_columna;
        direccion = 2;
    else
        if (direccion == 2) && (coor(1,2) == 1)  % he llegado al limite, me muevo a la siguiente fila y cambio direccion
            coor = coor + sig_fila;
            direccion = 1;
        else
            if (direccion == 1)  % No he llegado al extremo me muevo en diagonal
                coor = coor + mover_fila_columna;
            else
                coor = coor + mover_columna_fila;
            end
        end
    end
end
%vectorCarac1
%vectorCarac2

%% Calculo distancia

dist = power(abs(vectorCarac1-vectorCarac2),P);
dist = sum(sum(dist)) / numCoeficientes;  %La división por m es para que los valores no sean tan altos
dist = power(dist,1/P);

%pause;

