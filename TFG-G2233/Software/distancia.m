function dist_i = distancia(imagen1, imagen2, potencia)
%distancia(cell imagen1,cell imagen2,int potencia)
    [w,h] = size(imagen1);
    
    %dist_i = power(abs(imagen1 - imagen2),potencia);
    dist_i = double((abs(imagen1 - imagen2))).^potencia;
    dist_i = sum(sum(dist_i)) / w;
    %dist_i = power(dist_i,1/potencia);
    dist_i = dist_i^(1/potencia);
    
end