function corteF3 = recortar(imagen)
%RECORTAR Dada una im�gen sin tratar de la captura eliminar� todo el fondo
%   negro y seleccionar� la zona de inter�s.

d = imread(imagen);
de = rgb2gray(d);
%figure, imshow(de), title('Diferencia');
%figure, imhist(de);
h = 0; %Altura deseada para el corte
w = 0;
level = 0.35 %Nivel de luminosidad
while w < 470
    b = im2bw(de, level);

    de2 = de;
    de2(~b) = 0;
    %figure, subplot(1,2,1),imshow(de2),title('Im�gen con m�scara');
    %subplot(1,2,2), imshow(b), title('m�scara');
    [B,L] = bwlabel(de2);
    bls = regionprops(B);

    %------------------------------------------------------------------%
    %  Evitamos que en bls se almacenen peque�os cuadrados que podr�an %
    %   entorpecer los c�lculos posteriores.                           %
    %------------------------------------------------------------------%
    if ismatrix(bls)
        ind = find([bls.Area] >= max([bls.Area]));
        bls = bls(ind);
    end

    bb = bls.BoundingBox;
    corte = imcrop(de,bb);
    [h,w] = size(corte);

%    figure, imshow(corte), title('recortada');
%    figure, imhist(corte);

    level = level - 0.05;
end %while
level


%b1 = edge(corte, 'canny');
%b1 = edge(corte, 'sobel', 'horizontal');
%b1 = edge(corte, 'canny', [0.15,0.3]);
%figure, imshow(b1);


Y(1:62)=0;
Y(57:255)=255;
rfin=Y(corte+1);
bfin=uint8(rfin);
%figure,imshow(bfin);

[A,B]=find(bfin);
ymin=min(A);
ymax=max(A);
xmin=min(B);
xmax=max(B);
width = xmax - xmin;
height = ymax - ymin;
%-------------------------------------------------------------------------%
%Como las capturas se hacen sobre una zona invariante se puede recortar   %
% con valores constantes, de este modo se mueve xmin 20 a la derecha y    %
% se mueve ymin 6 hacia abajo.                                            %
% Al ancho de la im�gen se le resta 20 de los movidos en xmin y 100 de la %
% tercera falange,y al alto se le resta 6 por arriba y 8 por abajo apra   %
% quitar los bordes.                                                      %
%-------------------------------------------------------------------------%
corteF = imcrop(corte,[xmin+120,ymin+8,width-120,height-18]);

%-----------------------------------------------------------------------%
%figure, set(gcf,'units','normalized','outerposition',[0 0 1 1])%%Ventana maximizada
%subplot(1,1,1), imshow(corteF), title('Im�gen recortada con valores constantes.');
%pause;
%-----------------------------------------------------------------------%
%figure, imhist(corteF);

%---------------------------------------------------------------%
%  Buscamos la Zona de inter�s a partir de la im�gen precortada %
% determinando donde est�n las 2 zonas interfalange y cortando a%
% partir de ah�.                                                %
%---------------------------------------------------------------%
notROI = true;
rango = 35;
while notROI
    [height,width] = size(corteF);
    midH = round(height/2);
    if midH > 50
      midH = corteF(midH-50:midH+50,:);
    else
      midH = corteF(midH-10:midH+10,:);
    end
    mediaH = mean(midH);
    maxH = max(mediaH);
    mediaH2 = mediaH > (maxH - rango); %vector con 1 donde cumple la condicion y 0 donde no.
    

    primer1 = find(mediaH2, 1);
    if primer1 > 30
        primer1 = primer1 - 30;
    end
    ultimo1 = find(mediaH2, 1, 'last') + 10;

    corteF2 = imcrop(corteF,[primer1, 0, ultimo1-primer1, height]);
    [h,w] = size(corteF2);
    
    %--------------------------------------------------------------------%
    % Si el ancho de la im�gen resultante del corte es menor de 400 esto %
    % significa que no se han podido detectar correctamente las zonas    %
    % interfalanges de la im�gen y es necesario calcularla de nuevo con  %
    % un rango superior.                                                 %
    %--------------------------------------------------------------------%
    if w > 400
        notROI = false;
    else
        rango = rango + 10;
    end
    %figure, imshow(corteF2);
    %figure, imshow(mediaH2);
    %--Gr�fica de colores--%
    %figure, plot([1:width],mediaH);
    %pause;
    %----------------------%
end

    
%---------------------------------------------------------------%
%  De la zona de inter�s se quitan los bordes blancos o negros  %
%---------------------------------------------------------------%
corteF3 = [];
for i=1:floor(height/6)
    medHigh = median(corteF2(i,:)) < 230;
    medLow = median(corteF2(i,:))  >  50;
    if medHigh && medLow
        corteF3 = [corteF3; corteF2(i,:)];
    end
end

corteF3 = [corteF3; corteF2((floor(height/6) + 1):(floor(height * 5/6) -1),:)];

for i=floor(height * 5/6) : height
    medHigh = median(corteF2(i,:)) < 230;
    medLow  = median(corteF2(i,:)) >  50;
    if medHigh & medLow
        corteF3 = [corteF3; corteF2(i,:)];
    end
    
end

%figure,imshow(corteF3), title('S�lo ROI');

end

