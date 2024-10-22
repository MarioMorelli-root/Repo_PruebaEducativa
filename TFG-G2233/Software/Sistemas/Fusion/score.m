function dist = score( img1,img2,args )
% distancia basada en la fucion de correlacion, DCT y Hamming
% args:
%   1.- umbral para caso correlacion
%   2.- numero coeficientes a usar en DCT
%   3.- p de la distancia en el caso DCT
%   4.- Umbral de binarizacion

%% Variables sigmoide

A_NCoef = 0.01;
C_NCoef = 500;
A_DCT = 0.01;
C_DCT = 500;
A_Xor = 0.01;
C_Xor = 500;
A_And = 0.01;
C_And = 500;

%% Correlacion
% Variables

umbralCorr = args{1};

% Calculo correlacion

cc = normxcorr2(img1,img2);

% Calculo de distancia

[dist I] =  max(abs(cc(:))); % PRUEBA valor maximo
distMax = 1-dist;  %% CONVERTIDA A DISTANCIA

% PRUEBA a coger la media de los n mas altos
%n = 100;
%dist = 0;
%[nF nC] = size(cc);
%for i=1:n
%[M I] =  max(abs(cc(:)));
%dist = dist + (1-M);  % para pasarlo a distancia
%[f c] = ind2sub([nF nC], I);
%cc(f,c) = 0;
%end
%dist = dist / n;
%pause;

distNCoef = (1-sigmf(length(find(cc > umbralCorr)), [A_NCoef C_NCoef]));  % Normalizado a [0,1] y convertida a distancia
%dist = -(length(find(cc > umbralCorr)));  % PRUEBA numero de valores encima umbral
%if dist == 0  %% da problemas en score ratio
%    umbralCorr = umbralCorr-0.05;
%    dist = -(length(find(cc > umbralCorr)));
%    while dist == 0
%        umbralCorr = umbralCorr-0.05;
%        dist = -(length(find(cc > umbralCorr)));
%    end
%dist = -0.1;
%end

%dist = (1-dist) + (1-sigmf(length(find(cc > umbralCorr)), [0.01 250])); % PRUEBA fusion scores 



%% DCT

% Declaracion de variables

numCoeficientes = args{2};  %150;  % Numero de coeficientes DCT usados para distancia
vectorCarac1 = zeros(numCoeficientes,1);  %vectores de caracteristicas
vectorCarac2 = zeros(numCoeficientes,1);

P = args{3};   %0.8;  % valor de p en la normaP (norma fraccional)

% Calculo de la DCT

D1 = dct2(img1);
D2 = dct2(img2);

%Tratamiento adicional

%D1 = abs(D1).^2;  %espectro de potencia
%D2 = abs(D2).^2;  
%D1 = log(1+D1);  
%D2 = log(1+D2);  %se disminuye rango con el logaritmo

% Creacion vector caracteristicas. Recorrido en zig-zag dct

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

% Calculo distancia

distDCT = power(abs(vectorCarac1-vectorCarac2),P);
distDCT = sum(sum(distDCT)) / numCoeficientes;  %La división por m es para que los valores no sean tan altos
distDCT = power(distDCT,1/P);
distDCT = sigmf(distDCT, [A_DCT C_DCT]);  % Normalizado a [0,1]


%% Caso binarizacion imagen

% Codificacion tono grises:
%   0 => negro
%   255 => blanco

% Variables

umbralBinarizacion = args{4};  %0.5;
%op = args{4};   %'xor';  % valores: and, xor

% Calculo rango de cada imagen y el umbral de binarización

%img1
%img2

minImg1 = min(min(img1));
minImg2 = min(min(img2));
maxImg1 = max(max(img1));
maxImg2 = max(max(img2));

rangoImg1 = (maxImg1-minImg1)*umbralBinarizacion;
rangoImg2 = (maxImg2-minImg2)*umbralBinarizacion;

umbral1 = minImg1 + rangoImg1;
umbral2 = minImg2 + rangoImg2;

% Binarizo imagenes

[m1,n1] = size(img1);
[m2,n2] = size(img2);

if (m1~=m2) || (n1~=n2)
    disp (['ERROR las imagenes no son iguales'])
    exit;
end

for i=1:m1
    for j=1:n1
        if img1(i,j) < umbral1
            img1(i,j) = 0;  % 1=> negro
        else
            img1(i,j) = 1;  % 0=> blanco
        end
        if img2(i,j) < umbral2
            img2(i,j) = 0;
        else
            img2(i,j) = 1;
        end
    end
end

% Calculo distancia binaria

%img1
%img2
%if strcmp(op,'xor') == 1
    opXor = xor(img1,img2);  %busco distintos
    distXor = length(find(opXor==1));
    distXor = sigmf(distXor, [A_Xor C_Xor]);  % Normalizado a [0,1]
%end

%if strcmp(op,'and') == 1
    opAnd = and(img1,img2);  %busco negro iguales
    distAnd = length(find(opAnd==1));
    distAnd = (1-sigmf(distAnd, [A_And C_And]));  % Normalizado a [0,1] y convertida a distancia porque cuanto mayor sea mas parecidas son
%end


%% Fusion

dist = (1*distMax) + (1*distNCoef) + (1*distDCT) + (1*distXor) + (1*distAnd);  % suma

%pause;
return