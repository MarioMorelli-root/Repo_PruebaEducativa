function distanc = calculo_distancias(vector,num_elementos,muestra,opt, potencia)
% calculo_distancias(vector, num_elementos, muestra, opt, potencia)
%Calcula la distancia de la 'muestra' a las distintas imágenes del 'vector'
% En 'opt' se podrá indicar el tipo de calculo de las distancias:
%         *"max"     --> devuelve la distancia máxima.
%         *"min"     --> devuelve la distancia mínima.
%         *"media"   --> devuelve la distancia media.
%         *"mediana" --> devuelve la distancia mediana.

distancias=[];

for i=1:num_elementos
    entren = vector(i);
    dist_i = distancia(muestra, entren,potencia);
    
    distancias = [distancias;dist_i];
    
    if(strcmp(opt, 'min') == 1)
        distanc = min(distancias);
    end %END strcmp(opt, 'min')
    if(strcmp(opt, 'max') == 1)
        distanc = max(distancias);
    end %END strcmp(opt, 'max')
    if(strcmp(opt, 'media')== 1)
        distanc = mean(distancias);
    end %END strcmp(opt, 'media')
    if(strcmp(opt, 'mediana'))
        distanc = median(distancias);
    end
    
end