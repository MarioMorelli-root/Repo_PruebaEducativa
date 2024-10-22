function [HLambda, HD] = calculo_fractal(imagen_original, imagen_comprobar)
%%Calcula los fractales de la 'imagen original' y la 'imagen_comprobar'
% estos dos elementos deben ser matrices del mismo tamaño con valores
% comprendidos entre 0 y 255 (valores de grises).
%-Syntax :
%   calculo_fractal(imagen_original, imagen_comprobar);

e_maximo = 4;

%%Primero se comprueba si las dos imágenes son del mismo tamaño.
if(size(imagen_original) == size(imagen_comprobar))
    [height,width] = size(imagen_original);
    u = [];
    b = [];
    for e_indice = 0:e_maximo
        for i = 1:height
            for j = 1:width
                if e_indice == 0
                    %Se carga la imagen principal
                    gris = imagen_original(i,j);
                    u(i,j,e_indice +1) = gris;
                    b(i,j,e_indice +1) = gris;
                    %Se carga la imágen secundaria
                    gris = imagen_comprobar(i,j);
                    u2(i,j,e_indice +1) = gris;
                    b2(i,j,e_indice +1) = gris;
                else% e_indice != 0
                    valores_u = [];
                    valores_b = [];
                    valores_u2 = [];
                    valores_b2 = [];
                    if i < height %Si (i = height), no se puede obtener i+1 
                     valores_u = horzcat(valores_u , u(i+1,j,e_indice));
                     valores_b = horzcat(valores_b ,b(i+1,j,e_indice));
                     valores_u2 = horzcat(valores_u2,u2(i+1,j,e_indice));
                     valores_b2 = horzcat(valores_b2 , b2(i+1,j,e_indice));
                    end
                    if i > 1 %Si i = 1, no se puede obtener i-1
                     valores_u = horzcat(valores_u , u(i-1,j,e_indice));
                     valores_b = horzcat(valores_b , b(i-1,j,e_indice));
                     valores_u2 = horzcat(valores_u2,u2(i-1,j,e_indice));
                     valores_b2 = horzcat(valores_b2 , b2(i-1,j,e_indice));
                    end
                    if j < width %Si j=width, no se puede obtener j+1
                     valores_u = horzcat(valores_u ,u(i,j+1,e_indice));
                     valores_b = horzcat(valores_b ,b(i,j+1,e_indice));
                     valores_u2 = horzcat(valores_u2,u2(i,j+1,e_indice));
                     valores_b2 = horzcat(valores_b2 ,b2(i,j+1,e_indice));
                    end
                    if j > 1 %Si j=1, no se puede llamar a j-1
                     valores_u = horzcat(valores_u ,u(i,j-1,e_indice));
                     valores_b = horzcat(valores_b , b(i,j-1,e_indice));
                     valores_u2 =horzcat(valores_u2, u2(i,j-1,e_indice));
                     valores_b2 =horzcat(valores_b2 , b2(i,j-1,e_indice));
                    end
                    if i > 2 %Si i = 2, no se puede obtener i-2
                     valores_u = horzcat(valores_u , u(i-2,j,e_indice));
                     valores_b = horzcat(valores_b , b(i-2,j,e_indice));
                     valores_u2 = horzcat(valores_u2 , u2(i-2,j,e_indice));
                     valores_b2 = horzcat(valores_b2 , b2(i-2,j,e_indice));
                    end
                    %Almacenamos los resultados
                    u(i,j,e_indice +1) = max([u(i,j,e_indice) max(valores_u)]);
                    b(i,j,e_indice +1) = min([b(i,j,e_indice) min(valores_b)]);
                    u2(i,j,e_indice +1) = max([u2(i,j,e_indice) max(valores_u2)]);
                    b2(i,j,e_indice +1) = min([b2(i,j,e_indice) min(valores_b2)]);
                    %Se calcula la dif en ese punto.
                    dif(i,j,e_indice +1) = u(i,j,e_indice +1) - b(i,j,e_indice +1);
                    dif2(i,j,e_indice +1) = u2(i,j,e_indice +1) - b2(i,j,e_indice +1);
                end%if e_indice
            end%for j= 0:width
        end%for i= 0:height
    end %For e_indice= 0:4
    
    %%Se calcula el volumen y area de cada capa.
       for e_indice = 1:e_maximo
          volumen(e_indice) = sum(sum(dif(:,:,e_indice)));
          volumen2(e_indice) = sum(sum(dif2(:,:,e_indice)));
          %Calculo del area
          if e_indice <= 1
            area(e_indice) = volumen(e_indice)/2;
            area2(e_indice) = volumen2(e_indice)/2;
          else
            area(e_indice) = (volumen(e_indice) - volumen(e_indice -1))/2;
            area2(e_indice) = (volumen2(e_indice) - volumen2(e_indice -1))/2;
            
            %Solo trataremos el e_indice >= 2
            if e_indice >= 2
                auxMedia = dif(:,:,e_indice);
                auxMedia2 = dif2(:,:,e_indice);
            
                media(e_indice -1) = mean(auxMedia(:));
                media2(e_indice -1)= mean(auxMedia2(:));
            
                varianza(e_indice -1) = var(double(auxMedia(:)));
                varianza2(e_indice -1) = var(double(auxMedia2(:)));
                
                delta(e_indice -1) = varianza(e_indice -1) / media(e_indice -1)^2;
                delta2(e_indice -1) = varianza2(e_indice -1) / media2(e_indice -1)^2;
                
            end
          end
        end%Calculo de volumen
        for e_indice = 2:e_maximo
            epsil = e_indice;
            while epsil == e_indice
                epsil = rand;
                epsil = int8(round(rand * 2) + 2);
            end
        %Se definen D y D2 (en mayusculas) para mantener la nomenclatura.
            D(e_indice -1)  = 2 - ( (log2(area(e_indice)) - log2(area(epsil)) ) / (log2(e_indice) - log2(double(epsil))));
            D2(e_indice -1) = 2 - ( (log2(area2(e_indice)) - log2(area2(epsil)) ) / (log2(e_indice) - log2(double(epsil))));
        end
        D = abs(D);
        D2 = abs(D2);
        
    HLambda = sum(abs(delta - delta2));
    HD = sum(abs(D - D2));
    %fractal = [media; media2; varianza; varianza2; delta; delta2; D; D2];
    %fractal = [HLambda, HD];
end% if sizes iguales