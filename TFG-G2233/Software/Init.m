close all
clear all

genero = { 'H' , 'M' };
lado = { 'I' , 'D' }; %Izquierda, derecha.
numMuestras = 10; %Numero de muestras por individuo y por dedo.

heightFinal = 100;%Alto final de la imagen.
widthFinal = 330;%Ancho final de la imagen.

numUsuarios = 078; %Número de usuarios.

p = 2.0;  %para el calculo de distancias

for n= 053:numUsuarios %%BUCLE INICIAL
 for g = 1:2
   close all;
   %figure, set(gcf,'units','normalized','outerposition',[0 0 1 1])
   for l = 1:2
     %clear vec_muestras
     for mu = 01:numMuestras
           clearvars -except n genero g heightFinal widthFinal numMuestras mu numUsuarios lado l vec_muestras p; %%Vacía todas las variables excepto las del bucle
           
           root = 'images\BaseDeDatos\';
           %Las muestras se numerarán de 01 en adelante, y hay muestras de
           % dos dedos, el indice derecho y el indice izquierdo.
           %imagen = 'D_01';
           if mu < 10
            imagen = strcat(lado{l}, num2str(mu, '_0%i'));
           else
            imagen = strcat(lado{l}, num2str(mu, '_%i'));
           end 
            %imagen = 'I_01';
           %imagen = 'I_02';
           
           if n < 10 %Siempre el número debe ser de 3 dígitos.
            numero = strcat(num2str(n,'00%i'), genero{g});
           elseif n < 100
            numero = strcat(num2str(n,'0%i'), genero{g});
           else
            numero = strcat(num2str(n,'%i'), genero{g});
           end %if
           
           ruta_completa = strcat(root, numero, '\');
           ruta_completa = strcat(ruta_completa, imagen, '.jpg');
           if exist(ruta_completa,'file')
               corte = recortar(ruta_completa);
               %figure, imshow(corte);
               
               adapt = adapthisteq(corte);
               adapt = medfilt2(adapt, [3 3]);
               adapt = imadjust(adapt,[0.05;0.75],[0.45;0.75],1);
               adapt = imadjust(adapt, stretchlim(adapt));
               
               %prueba = imadjust(adapt,stretchlim(adapt));
               %prueba2 = imadjust(adapt,[0.05;0.75],[0.55;0.75],1);
               %prueba3 = adapthisteq(adapt);
               adapt2 = histeq(adapt);
               
               escala = imresize(adapt,[heightFinal widthFinal],'bilinear');
               %figure, imshow(escala), title('Reescalada!');
               
               
               
               %prueba2 = imadjust(prueba,[0.05;0.75],[0;0.95],1);
               %prueba2 = imadjust(prueba,stretchlim(prueba));
               
               %figure, subplot(3,2,1),imshow(prueba), title('stretch');
               %subplot(4,2,2), imhist(prueba);
               %subplot(4,2,4), imhist(prueba2);
               %subplot(4,2,3), imshow(prueba2), title('imadjust 0.25->0.75 , 0->0.95');
               %subplot(4,2,6), imhist(prueba3);
               %subplot(4,2,5), imshow(prueba3), title('imadjust 0.05->0.75 , 0->0.95');
               %subplot(4,2,8), imhist(prueba4);
               %subplot(4,2,7), imshow(prueba4), title('imadjust 0.05->0.75 , 0->0.75');
               
               %------------------------------------------%
               %figure, subplot(2,2,1), imshow(bucle1);
               %subplot(2,2,2), imhist(bucle1);
               %subplot(2,2,3), imshow(bucleHist);
               %subplot(2,2,4), imhist(bucleHist);
               %------------------------------------------%
               
               %b1 = edge(prueba2, 'canny');
               %b3 = edge(bucle1, 'sobel', 'horizontal');
               %b2 = edge(prueba2, 'sobel', 'horizontal');
               %[b1,T] = edge(bucle1, 'canny', [0.08,0.11]);
               %[b1,T] = edge(prueba2, 'prewitt');
               %[b1,T] = edge(prueba2, 'zerocross');
               
               %b1 = b1+b2+b3;
               %figure, imshow(b1);
          
               subplot(numMuestras/2,2,mu),imshow(escala), title(strcat('Muestra', lado{l} , num2str(mu)));
               %if mu == numMuestras
               % pause;
               %end
               %subplot(4,2,2), imhist(prueba);
               %subplot(4,2,4), imhist(prueba2);
               %subplot(4,2,3), imshow(prueba2), title('imadjust 0.25->0.75 , 0->0.95');
               %subplot(4,2,6), imhist(prueba3);
               %subplot(4,2,5), imshow(prueba3), title('imadjust 0.05->0.75 , 0->0.95');
               %subplot(4,2,8), imhist(prueba4);
               %subplot(4,2,7), imshow(prueba4), title('imadjust 0.05->0.75 , 0->0.75');
               
               imwrite(escala,strcat('pruebas\', numero, '_', imagen, '.jpg'),'jpg');
               %imwrite(corte, strcat('pruebas\', numero, '_', imagen,'_Corte.jpg'), 'jpg');
               %imwrite(corteF3, strcat('pruebas\', numero, '_' , imagen,'_CorteROI.jpg'),'jpg');
               %imwrite(adapt,strcat('pruebas\', numero, '_' ,imagen,'_Procesada.jpg'),'jpg');
               
               imagen %%DEBUG print ID de imagen
               [vec_muestras{n+1,l ,mu}] = [escala];%n empieza en 0 los vectores en Matlab empiezan en 1
               if mu == numMuestras && l == 2
                   numero %%DEBUG Print del número. 
                if exist('vec_muestras', 'var') > 0
                    for j=1:numMuestras
                        calculo_distancias(vec_muestras{n+1, l}, numMuestras, vec_muestras{n+1, l ,j} , 'mediana', p);
                    end
                end %END exist(vec_muestras)
               end
           end %%EXISTE ruta_completa
     end %%Muestras
     
   end %Lado
   
 end %%Género
end %% BUCLE INICIAL
%%Generamos los vectores de los impostores y de aciertos
for i = 0:numUsuarios
    for j = 1:2
        for k = 1:numMuestras
            muestra = vec_muestras{i+1,j,k}; %Muestra con la que vamos a comparar los demás
            for kk = 1:numMuestras
                %aciertos{4*i + 2*(j-1) + kk} = calculo_distancias(vec_muestras{i+1,j},numMuestras,muestra,'mediana',10);
                aciertos{2*i + (j-1) + kk} = calculo_distancias(vec_muestras{i+1,j},numMuestras,muestra,'mediana',p);
            end %%end kk
            
            for i2=0:numUsuarios
                for j2=1:2
                    for k2=1:2
                        if(i~=i2 && j~=j2 && k~=k2)
                            fallos{4*(i2) + 2*(j2-1) + k2} = distancia(vec_muestras{i+1,j,k},vec_muestras{i2+1,j2,k2},p);
                        end
                    end
                end
            end
           end
    end
end

%CALCULO DE CDET
%path(path,'D:\FingerVein\Recursos\DET_toolbox');
%[P_miss,P_fa] = Compute_DET (aciertos, fallos);
%Plot_DET(PMiss,P_fa, 'k-', 2);
