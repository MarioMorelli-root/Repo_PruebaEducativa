close all
clear all
%de = imread('04132015-3LED_950nmLijados_M1-3.jpg');
%de = imread('04132015-3LED_950nmLijados_M2.jpg');
%de = imread('04132015-3LED_950nmLijados_M3.jpg');
%de = imread('04132015-3LED_950nmLijados_M4.jpg');
%de = imread('04132015-3LED_950nmLijados_M5.jpg');
de = imread('04132015-3LED_950nmLijados_M6.jpg');
%de = imread('04132015-3LED_950nmLijados_M7.jpg');
%de = imread('04132015-3LED_950nmLijados_M1.jpg');
%de = imread('4LedI.jpg');
%de = imread('3LedI.jpg');
%de = imread('Imagen27.jpg');
%de = imread('Imagen90.jpg');

de2 = rgb2ycbcr(de);
dey = de2(:,:,1);
%figure,imshow(dey);
%figure,imhist(dey);
bdey = im2bw(dey,165/255);
%bdey = imfill(bdey, 'holes');
%figure,imshow(bdey);
ee = strel('disk',2);
fin1 = imopen(bdey,ee);
%figure,imshow(fin1);
[B,L] = bwlabel(fin1);
bls = regionprops(B);
bb = bls.BoundingBox;
fin2 = imcrop(dey,bb);
%figure,imshow(fin2);
%figure,imhist(fin2);
%fin3=imadjust(fin2);
%figure,imshow(fin3);
bfin2 = im2bw(fin2,100/255);
%figure,imshow(bfin2);
%Y(1:75)=0;
%Y(76:170)=255;
%Y(171:256)=0;
%rfin3=Y(fin2+1);
%bfin3=uint8(rfin3*255);
%figure,imshow(bfin3);
bfin3 = imerode(bfin2,ee);
%figure,imshow(bfin3);
bfin4 = imfill(bfin3,'holes');
%figure,imshow(bfin4);
[B,L] = bwlabel(bfin4);
bls = regionprops(B);
bb = bls.BoundingBox;
final = imcrop(fin2,bb);
%Código de prueba, Sergio.
finalHist = histeq(final);
finalB = 200 - final; %Invertimos los grises de la imagen "final"

%finalB = edge(final,'sobel');
h2=fspecial('average',[9,9]);

finalHistB = histeq(finalB, 80);
finalHistB = imfilter(finalHistB,h2);
%fig = get_param('finalHistB','Handle');

%paso finalB a blanco y negro, binaria.
finalB = im2bw(finalB,0.13);
finalB = imfilter(finalB, h2);
%Representación de las imágenes.
figure,subplot(2,2,1),
imshow(final), subplot(2,2,2),
imshow(finalB), subplot(2,2,3),
imshow(finalHist), subplot(2,2,4)
imshow(finalHistB);
%imwrite(finalB, 'Pruebas/M2-finalB.bmp');
%imwrite(finalHistB, 'Pruebas/M2-finalHistB.bmp');
%imwrite(finalHist, 'Pruebas/M2-finalHist.bmp');
%saveas(finalB,'Pruebas/finalB-M1','bmp');
%saveas(finalHist,'Pruebas/finalHist-M1','jpg');
%saveas(finalHistB,'Pruebas/finalHistB-M1.jpg');