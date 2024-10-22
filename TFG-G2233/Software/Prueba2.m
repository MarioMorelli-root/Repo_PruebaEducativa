close all
clear all

genero = {'H','M'};

for n= 000:005 %%BUCLE INICIAL
 for g = 1:2
    clearvars -except n genero g; %%Vacía todas las variables excepto las del bucle
    close all;
    
    root = 'images\BaseDeDatos\';
    imagen = 'D_01';
    numero = strcat(num2str(n,'00%i'), genero{g});
    ruta_completa = strcat(root, numero, '\');
    ruta_completa = strcat(ruta_completa, imagen, '.jpg');
    if exist(ruta_completa,'file')
        corte = recortar(ruta_completa);
        
        
        prueba = imadjust(corte,stretchlim(corte),[]);
        
        figure,subplot(1,2,1), imshow(prueba),  title('Imágen con stretch pasado');
        subplot(1,2,2),imhist(prueba);
        
        %prueba = histeq(prueba);
        %figure,subplot(2,2,1), imshow(prueba),  title('Imágen con stretch y equalización de histograma');
        %subplot(2,2,2),imhist(prueba);
        
         prueba2 = imadjust(prueba,[0.05;0.75],[0;0.95],1);
        
        subplot(1,2,2),imshow(prueba2), title('imagen con imadjust [0.05,0.75] [0;0.95]');
        %subplot(1,2,1), imhist(prueba2);
        
        prueba2 = imadjust(prueba2,stretchlim(prueba2),[]);
        %figure,subplot(1,2,1),imshow(prueba2), title('imagen con ensanchamiento');
        %subplot(1,2,2), imhist(prueba2);
        
        prueba2 = adapthisteq(prueba2);
        %figure,subplot(1,2,1),imshow(prueba2), title('imagen con adaptHistEq');
        %subplot(1,2,2), imhist(prueba2);
        
        % Ensanchamiento de histogramas %
        bucle1 = imadjust(prueba2, stretchlim(prueba2),[]);
        bucle1 = imadjust(bucle1,[0.05;0.9],[0;0.95],1);
        bucleHist = imadjust(bucle1, stretchlim(bucle1),[]);
        
        
        %------------------------------------------%
        %figure, subplot(2,2,1), imshow(bucle1);
        %subplot(2,2,2), imhist(bucle1);
        %subplot(2,2,3), imshow(bucleHist);
        %subplot(2,2,4), imhist(bucleHist);
        %------------------------------------------%
        
        %b1 = edge(prueba2, 'canny');
        %b3 = edge(bucle1, 'sobel', 'horizontal');
        %b2 = edge(prueba2, 'sobel', 'horizontal');
        [b1,T] = edge(bucle1, 'canny', [0.08,0.11]);
        %[b1,T] = edge(prueba2, 'prewitt');
        %[b1,T] = edge(prueba2, 'zerocross');
        
        %b1 = b1+b2+b3;
       %figure, imshow(b1);
        
        %[L, threshold] = edge(de2,'sobel');
        %f = 0.85; %Es el valor optimo?
        %BW = edge(de2, 'sobel', threshold* f);
        %figure,imshow(BW), title('Mascara binary gradiant');
        %
        %se90 = strel('line', 3, 90);
        %se0 = strel('line', 3, 0);
        %sdil = imdilate(BW, [se90, se0]);
        %figure, imshow(sdil), title('Mascara de gradiente dilatada');
        
        %dfill = imfill(sdil, 'holes');%Se hace para unir las lineas blancas y crear una zona de interés
        %figure, imshow(dfill), title('Con holes');
        
        %imwrite(corte, strcat('pruebas\', numero, '_', imagen,'_Corte.jpg'), 'jpg');
        %imwrite(corteF3, strcat('pruebas\', numero, '_' , imagen,'_CorteROI.jpg'),'jpg');
        %imwrite(bucleHist,strcat('pruebas\', numero, imagen,'_Procesada.jpg'),'jpg');
        pause;
    end %%EXISTE ruta_completa
    
    
 end %%Género
end %% BUCLE INICIAL