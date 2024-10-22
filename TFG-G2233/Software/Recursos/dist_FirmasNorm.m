function dist = dist_FirmasNorm(train,num_train,data,option,P)

% Funcion que devuelve la distancia de la muestra de prueba "data" a las "num_train" muestras de entrenamiento "train".
% Option indica como se calcula la distancia de data a la muestras de entrenamiento. Puede ser:
%	'min' devuelve la distancia minima
%	'max' la maxima
%	'media' la media
%	'mediana' la mediana


distancias=[];  %inicializo variable donde almacenar distancias
for i=1:num_train
    dist_i = dist_NormaP(train{i},data,P);
    %dist_i = dist_i / length(train{i});
    distancias = [distancias;dist_i];
end

if ( strcmp(option,'min') == 1 )
    dist = min (distancias);
end
if ( strcmp(option,'max') == 1 )
    dist = max (distancias);
end
if ( strcmp(option,'media') == 1 )
    dist = mean (distancias);
end
if ( strcmp(option,'mediana') == 1 )
    dist = median (distancias);
end
end
