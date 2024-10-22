function dist = score( img1,img2,args )
% Calculo de distancia basado en binarizar la imagen y calcular distancias
%de hamming entre ellas

% Codificacion tono grises:
%   0 => negro
%   255 => blanco


%% Variables

umbralBinarizacion = args{1};  %0.5;
op = args{2};   %'xor';  % valores: and, xor


%% Calculo rango de cada imagen y el umbral de binarización

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


%% Binarizo imagenes

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
%figure , imshow(img1);
%figure, imshow(img2);

% Calculo distancia binaria

%img1
%img2
if strcmp(op,'xor') == 1
    opXor = xor(img1,img2);  %busco distintos
    dist = length(find(opXor==1));
%    figure, imshow(opXor);
end

if strcmp(op,'and') == 1
    opAnd = and(img1,img2);  %busco negro iguales
    dist = length(find(opAnd==1));
    dist = -dist;  % porque cuanto mayor sea mas parecidas son
%    figure, imshow(opAnd);
end

%pause;


