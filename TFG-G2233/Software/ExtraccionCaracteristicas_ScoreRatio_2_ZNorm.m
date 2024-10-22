% Lo modifico para probar con cualquier distancia

close all
clear all

path(path,'C:\Users\Sergio_Venas\Desktop\FingerVein\Recursos\DET_toolbox\'); % ¡¡AVISO!! Linea dependiente de maquina

% Parte donde definimos el sistema a usar. Las funciones estarán en
% directorios diferentes y lo cargamos

sistema = 'Hamming';  % dct->basado en la DCT   Hamming->basada en Hamming entre imagenes  corr->basado en correlacion entre imagenes
dirRootSistemas = 'C:\Users\Sergio_Venas\Desktop\FingerVein\Sistemas\'; % ¡¡AVISO!! Linea dependiente de maquina
dir = strcat(dirRootSistemas,sistema,'\')
path(dir,path)

% Argumentos al calculo de distancias
% Separo hombres y mujeres porque pueden tener distinta configuracion
%optima
% Valores:
%   +Caso dct: 1->numero coeficientes  2->P en distancia fraccional
%   +Caso Hamming: 1->umbral binarizacion  2->operacion lógica (string:
%      'xor', 'and')
%   +Caso corr: 1->Umbral valores correlacion

argH = {0.8,'and'}; %{50,0.6};  % para hombres
argM = {0.8,'and'}; %{150,0.4};

genero = { 'H' , 'M' };
lado = { 'I' , 'D' }; %Izquierda, derecha.
%numMuestras = 10; %Numero de muestras por individuo y por dedo.
%userInicial = 009; %Número del primer usuario
%numUsuarios = 034; %Número de usuarios.
%muestraInicialTest = 04;  %muestra inicial para prueba autentica
muestrasPatron = [01 02 03];
muestrasTest = [04 05 06 07 08 09 10];  %[04 05 06 07 08 09 10];
isMale = 1;  % 1->verdad
isFemale = 1;
testImpostorMultiGenero = 1;
opt = 'min';

load FemaleTest_prueba.txt; female=FemaleTest_prueba;
load MaleTest_prueba.txt; male=MaleTest_prueba; %cargamos fichero
[todos{1}] = [male'];
numMales = length(todos{1});
[todos{2}] = [female'];
numFemales = length(todos{2});

root = 'pruebas_mascara\';

% Fichero de salida de resultados

nombreFich = '20160523_dct_.txt';
fileID = fopen(nombreFich,'w');

% Para score ratio

load ScoreRatio_pruebas.txt; SR=ScoreRatio_pruebas;
%load ScoreRatio.txt; SR=ScoreRatio;
numSR = length(SR);
muestraSR = 03; %Muestra usada para el score ratio
nMuestrasSR = [1 3 5 10];  %numero de muestras usadas para el score ratio
[filas nPruebasSR] = size(nMuestrasSR);

% Declaracion de estrcturas de datos

% Sin score normalization

matrizAutenticasH = [];
matrizImpostorasH = [];
matrizAutenticasM = [];
matrizImpostorasM = [];
EerIndH = zeros(numMales*2,1);
EerIndM = zeros(numFemales*2,1);

% Parte relacionada con score ratio

matrizAutenticasH_SR = [];
matrizImpostorasH_SR = [];
matrizAutenticasM_SR = [];
matrizImpostorasM_SR = [];
EerIndH_SR = zeros(numMales*2,length(nMuestrasSR));
EerIndM_SR = zeros(numFemales*2,length(nMuestrasSR));
rootSR = root;


% Parte ZNrom

load ZNorm.txt; ZN=ZNorm;
numZN = length(ZN);
matrizAutenticasH_ZN = [];
matrizImpostorasH_ZN = [];
matrizAutenticasM_ZN = [];
matrizImpostorasM_ZN = [];
EerIndH_ZN = zeros(numMales*2,1);
EerIndM_ZN = zeros(numFemales*2,1);

% Parte relacionada con score ratio

muestraZN = 03; %Muestra usada para el score ratio
matrizAutenticasH_SR_ZN = [];
matrizImpostorasH_SR_ZN = [];
matrizAutenticasM_SR_ZN = [];
matrizImpostorasM_SR_ZN = [];
EerIndH_SR_ZN = zeros(numMales*2,length(nMuestrasSR));
EerIndM_SR_ZN = zeros(numFemales*2,length(nMuestrasSR));
rootZN = root;


% cargo la imagenes para score ratio aqui, ya que siempre
%van a ser las mismas y así no se repite esa operacion siempre

disp('*** Imagenes para Score Ratio');
imagenSR = zeros(100,330,numSR*2);
indice = 1;
for id = SR'
    for l = 1:2
        imagen2 = strcat(lado{l}, num2str(muestraSR, '_0%i'));
        if id < 10 %Siempre el número debe ser de 3 dígitos.
            numero = strcat(num2str(id,'00%i'), 'H');
        elseif id < 100
            numero = strcat(num2str(id,'0%i'), 'H');
        else
            numero = strcat(num2str(id,'%i'), 'H');
        end %if
        ruta_completa = strcat(rootSR, numero, '_');
        ruta_completa = strcat(ruta_completa, imagen2, '.png')
        if exist(ruta_completa,'file')
            %imread(ruta_completa)
            %pause;
            imagenSR(:,:,indice) = imread(ruta_completa);
            indice = indice + 1;
        else
            strcat('** AVISO: el fichero de SR', ruta_completa, ' NO EXISTE')
        end
    end
end

% cargo la imagenes para score normalization aqui, ya que siempre
%van a ser las mismas y así no se repite esa operacion siempre

disp('*** Imagenes para Score Normalization');
imagenZN = zeros(100,330,numZN*2);
indice = 1;
for id = ZN'
    for l = 1:2
        imagen2 = strcat(lado{l}, num2str(muestraZN, '_0%i'));
        if id < 10 %Siempre el número debe ser de 3 dígitos.
            numero = strcat(num2str(id,'00%i'), 'H');
        elseif id < 100
            numero = strcat(num2str(id,'0%i'), 'H');
        else
            numero = strcat(num2str(id,'%i'), 'H');
        end %if
        ruta_completa = strcat(rootZN, numero, '_');
        ruta_completa = strcat(ruta_completa, imagen2, '.png')
        if exist(ruta_completa,'file')
            %imread(ruta_completa)
            %pause;
            imagenZN(:,:,indice) = imread(ruta_completa);
            indice = indice + 1;
        else
            strcat('** AVISO: el fichero de ZN', ruta_completa, ' NO EXISTE')
        end
    end
end
[dZN1 dZN2 dZN3] = size(imagenZN);  % por si algun fichero no existe
scoreMuestrasZN = zeros(dZN3,1);
scoreMuestrasZN_SR = zeros(dZN3,length(nMuestrasSR));

[dSR1 dSR2 dSR3] = size(imagenSR);
scoreMuestrasSR = zeros(dSR3,1);
contAutenticasH = 1;
contImpostorasH = 1;
contAutenticasM = 1;
contImpostorasM = 1;
nExp_H = 1;
nExp_M = 1;
for g = 1:2
    if (g==1 && isMale==1) || (g==2 && isFemale==1)
        
        strcat('Experimento para genero: ', genero{g});
        
        if g == 1  %hombres  
            arg = argH;
        else
            arg = argM;
        end
        
        for n = todos{g} %%BUCLE INICIAL
            %strcat('usuario: ', num2str(n));
            close all;
            for l = 1:2
                %Muestras patron
                patron = [];
                indice = 1;
                TAR = [];
                NON = [];
                TAR_SR = [];
                NON_SR = [];
                for mu2 = muestrasPatron
                    imagen2 = strcat(lado{l}, num2str(mu2, '_0%i'));
                    if n < 10 %Siempre el número debe ser de 3 dígitos.
                        numero = strcat(num2str(n,'00%i'), genero{g});
                    elseif n < 100
                        numero = strcat(num2str(n,'0%i'), genero{g});
                    else
                        numero = strcat(num2str(n,'%i'), genero{g});
                    end %if
                    ruta_completa = strcat(root, numero, '_');
                    ruta_completa = strcat(ruta_completa, imagen2, '.png');
                    if exist(ruta_completa,'file')
                        patron(:,:,indice) = imread(ruta_completa);
                        indice = indice + 1;
                    else
                        strcat('** AVISO: el fichero de patron', ruta_completa, ' NO EXISTE')
                    end
                end
                
                %% Calculo valores de normalizacion de score
                
                for Id_ZN = 1:dZN3
                    [d1 d2 d3] = size(patron);
                    distancias = zeros(1,d3);
                    for i2 = 1:d3
                        distancias(1,i2) = score(imagenZN(:,:,Id_ZN), patron(:,:,i2), arg);
                    end
                    %En función de "opt" realizamos la acción indicada
                    if(strcmp(opt,'min') == 1)
                        vectorAUX = min(distancias(:));  % no es vector, pero mantengo nombre para minimizar cambios
                    end
                    if(strcmp(opt,'max') == 1)
                        vectorAUX = max(distancias(:));
                    end
                    if(strcmp(opt,'media') == 1)
                        vectorAUX = mean(distancias(:));
                    end
                    if(strcmp(opt,'mediana') == 1)
                        vectorAUX = median(distancias(:));
                    end
                    scoreMuestrasZN(Id_ZN) = vectorAUX;
                    
                    % Parte score ratio
                    for Id_SR = 1:dSR3
                        %HLs = zeros(1,d3); HDs=zeros(1,d3);
                        %for i2 = 1:d3
                        %[HL , HD] = distancia(imagenSR(:,:,Id_SR), imagen_original);
                        %HLs(1,1) = HL
                        %HDs(1,1) = HD
                        %matrizAutenticas = vertcat(matrizAutenticas, distancia(imagen_original,imagen_comprobar));
                        %end
                        %En función de "opt" realizamos la acción indicada
                        %if(strcmp(opt,'min') == 1)
                        %    vectorAUX_SR = [min(HLs(:)) , min(HDs(:))]
                        %end
                        %if(strcmp(opt,'max') == 1)
                        %    vectorAUX_SR = [max(HLs(:)) , max(HDs(:))];
                        %end
                        %if(strcmp(opt,'media') == 1)
                        %    vectorAUX_SR = [mean(HLs(:)) , mean(HDs(:))];
                        %end
                        %if(strcmp(opt,'mediana') == 1)
                        %    vectorAUX_SR = [median(HLs(:)) , median(HDs(:))];
                        %end
                        vectorAUX_SR = score(imagenZN(:,:,Id_ZN), imagenSR(:,:,Id_SR), arg); % Para no cambiar el resto...
                        %Almacenamos salidas muestras SR
                        scoreMuestrasSR(Id_SR) = vectorAUX_SR;
                    end  %id_SR
                    scoreMuestrasSR = sort(scoreMuestrasSR); %Ordeno de menor a mayor cada columna
                    %caldulo valor de normalizacion para cada caso
                    casoSR = 1;
                    for Id_SR = nMuestrasSR
                        den = 0;
                        for Id2_SR = 1:Id_SR
                            den = den + scoreMuestrasSR(Id2_SR);
                        end
                        den = den / Id_SR;
                        %Almacenamos scores
                        scoreMuestrasZN_SR(Id_ZN,casoSR) = vectorAUX/den;
                        casoSR = casoSR + 1;
                    end
                end
                media = mean(scoreMuestrasZN);
                desv = std(scoreMuestrasZN);
                mediaSR = mean(scoreMuestrasZN_SR);
                desvSR = std(scoreMuestrasZN_SR);

                
                %% Pruebas autenticas
                contAutenticas_caso=1;
                for mu = muestrasTest
                    %Las muestras se numerarán de 01 en adelante, y hay muestras de
                    % dos dedos, el indice derecho y el indice izquierdo.
                    %imagen = 'D_01';
                    'Pruebas autenticas';
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
                    
                    ruta_completa = strcat(root, numero, '_');
                    ruta_completa = strcat(ruta_completa, imagen, '.png');
                    
                    if exist(ruta_completa,'file')
                        %Cargamos la imagen principal
                        imagen_original = imread(ruta_completa);
                        [d1 d2 d3] = size(patron);
                        distancias = zeros(1,d3);
                        distancias_ZN = zeros(1,d3);
                        for i2 = 1:d3
                            distancias(1,i2) = score(imagen_original, patron(:,:,i2), arg);
                            distancias_ZN(1,i2) = (distancias(1,i2)-media)/desv;
                        end
                        %En función de "opt" realizamos la acción indicada
                        if(strcmp(opt,'min') == 1)
                            vectorAUX = min(distancias(:));  % no es vector, pero mantengo nombre para minimizar cambios
                            vectorAUX_ZN = min(distancias_ZN(:));
                        end
                        if(strcmp(opt,'max') == 1)
                            vectorAUX = max(distancias(:));
                            vectorAUX_ZN = max(distancias_ZN(:));
                        end
                        if(strcmp(opt,'media') == 1)
                            vectorAUX = mean(distancias(:));
                            vectorAUX_ZN = mean(distancias_ZN(:));
                        end
                        if(strcmp(opt,'mediana') == 1)
                            vectorAUX = median(distancias(:));
                            vectorAUX_ZN = median(distancias_ZN(:));
                        end
                        %Almacenamos VectorAux en la matriz de Impostoras
                        if g == 1                            
                            matrizAutenticasH = vertcat(matrizAutenticasH, vectorAUX);
                            TAR = vertcat(TAR, vectorAUX);
                            
                            matrizAutenticasH_ZN = vertcat(matrizAutenticasH_ZN, vectorAUX_ZN);
                        else
                            matrizAutenticasM = vertcat(matrizAutenticasM, vectorAUX);
                            TAR = vertcat(TAR, vectorAUX);
                            
                            matrizAutenticasM_ZN = vertcat(matrizAutenticasM_ZN, vectorAUX_ZN);
                        end
                        
                        % PARTE SCORE RATIO
                        
                        for Id_SR = 1:dSR3
                            %HLs = zeros(1,d3); HDs=zeros(1,d3);
                            %for i2 = 1:d3
                            %[HL , HD] = distancia(imagenSR(:,:,Id_SR), imagen_original);
                            %HLs(1,1) = HL
                            %HDs(1,1) = HD
                            %matrizAutenticas = vertcat(matrizAutenticas, distancia(imagen_original,imagen_comprobar));
                            %end
                            %En función de "opt" realizamos la acción indicada
                            %if(strcmp(opt,'min') == 1)
                            %    vectorAUX_SR = [min(HLs(:)) , min(HDs(:))]
                            %end
                            %if(strcmp(opt,'max') == 1)
                            %    vectorAUX_SR = [max(HLs(:)) , max(HDs(:))];
                            %end
                            %if(strcmp(opt,'media') == 1)
                            %    vectorAUX_SR = [mean(HLs(:)) , mean(HDs(:))];
                            %end
                            %if(strcmp(opt,'mediana') == 1)
                            %    vectorAUX_SR = [median(HLs(:)) , median(HDs(:))];
                            %end
                            vectorAUX_SR = score(imagen_original, imagenSR(:,:,Id_SR), arg); % Para no cambiar el resto...
                            %Almacenamos salidas muestras SR
                            scoreMuestrasSR(Id_SR) = vectorAUX_SR;
                        end  %id_SR
                        scoreMuestrasSR = sort(scoreMuestrasSR); %Ordeno de menor a mayor cada columna
                        %caldulo valor de normalizacion para cada caso
                        casoSR = 1;
                        for Id_SR = nMuestrasSR
                            den = 0;
                            for Id2_SR = 1:Id_SR
                                den = den + scoreMuestrasSR(Id2_SR);
                            end
                            den = den / Id_SR;
                            %Almacenamos scores
                            if g == 1
                                %vectorAUX
                                matrizAutenticasH_SR(contAutenticasH,casoSR) = vectorAUX/den;
                                TAR_SR(contAutenticas_caso,casoSR) = vectorAUX/den;
                                
                                matrizAutenticasH_SR_ZN(contAutenticasH,casoSR) = ((vectorAUX/den)-mediaSR(casoSR))/desvSR(casoSR);
                            else
                                %vectorAUX
                                matrizAutenticasM_SR(contAutenticasM,casoSR) = vectorAUX/den;
                                TAR_SR(contAutenticas_caso,casoSR) = vectorAUX/den;
                                
                                matrizAutenticasM_SR_ZN(contAutenticasM,casoSR) = ((vectorAUX/den)-mediaSR(casoSR))/desvSR(casoSR);
                            end
                            casoSR = casoSR + 1;
                        end
                        if g == 1
                            contAutenticasH = contAutenticasH + 1;
                        else
                            contAutenticasM = contAutenticasM + 1;
                        end
                        contAutenticas_caso = contAutenticas_caso + 1;
                    else
                        strcat('** AVISO: el fichero de prueba AUTENTICA ', ruta_completa, ' NO EXISTE')
                    end
                    
                end
                %pause;
                %% Pruebas impostoras
                
                'Pruebas impostoras';
                contImpostoras_caso=1;
                for n2= todos{g}
                    if (n2 ~= n)
                        if n2 < 10 %Siempre el número debe ser de 3 dígitos.
                            numero2 = strcat(num2str(n2,'00%i'), genero{g});
                        elseif n2 < 100
                            numero2 = strcat(num2str(n2,'0%i'), genero{g});
                        else
                            numero2 = strcat(num2str(n2,'%i'), genero{g});
                        end %if n2
                        imagen2 = strcat(lado{l}, '_07');
                        ruta_completa = strcat(root, numero2, '_');
                        ruta_completa = strcat(ruta_completa, imagen2, '.png');
                        if exist(ruta_completa,'file')
                            %Cargamos la imagen principal
                            imagen_original = imread(ruta_completa);
                            distancias = zeros(1,d3);
                            distancias_ZN = zeros(1,d3);
                            for i2 = 1:d3
                                distancias(1,i2) = score(imagen_original, patron(:,:,i2), arg);
                                distancias_ZN(1,i2) = (distancias(1,i2)-media)/desv;
                            end
                            %En función de "opt" realizamos la acción indicada
                            if(strcmp(opt,'min') == 1)
                                vectorAUX = min(distancias(:));  % no es vector, pero mantengo nombre para minimizar cambios
                                vectorAUX_ZN = min(distancias_ZN(:));
                            end
                            if(strcmp(opt,'max') == 1)
                                vectorAUX = max(distancias(:));
                                vectorAUX_ZN = max(distancias_ZN(:));
                            end
                            if(strcmp(opt,'media') == 1)
                                vectorAUX = mean(distancias(:));
                                vectorAUX_ZN = mean(distancias_ZN(:));
                            end
                            if(strcmp(opt,'mediana') == 1)
                                vectorAUX = median(distancias(:));
                                vectorAUX_ZN = median(distancias_ZN(:));
                            end
                            %Almacenamos VectorAux en la matriz de Impostoras
                            if g == 1
                                matrizImpostorasH = vertcat(matrizImpostorasH, vectorAUX);
                                NON = vertcat(NON, vectorAUX);
                                
                                matrizImpostorasH_ZN = vertcat(matrizImpostorasH_ZN, vectorAUX_ZN);
                            else
                                matrizImpostorasM = vertcat(matrizImpostorasM, vectorAUX);
                                NON = vertcat(NON, vectorAUX);
                                
                                matrizImpostorasM_ZN = vertcat(matrizImpostorasM_ZN, vectorAUX_ZN);
                            end
                            
                            % PARTE SCORE RATIO
                            
                            for Id_SR = 1:dSR3
                                %HLs = zeros(1,d3); HDs=zeros(1,d3);
                                %for i2 = 1:d3
                                %[HL , HD] = distancia(imagenSR(:,:,Id_SR), imagen_original);
                                %HLs(1,1) = HL
                                %HDs(1,1) = HD
                                %matrizAutenticas = vertcat(matrizAutenticas, distancia(imagen_original,imagen_comprobar));
                                %end
                                %En función de "opt" realizamos la acción indicada
                                %if(strcmp(opt,'min') == 1)
                                %    vectorAUX_SR = [min(HLs(:)) , min(HDs(:))]
                                %end
                                %if(strcmp(opt,'max') == 1)
                                %    vectorAUX_SR = [max(HLs(:)) , max(HDs(:))];
                                %end
                                %if(strcmp(opt,'media') == 1)
                                %    vectorAUX_SR = [mean(HLs(:)) , mean(HDs(:))];
                                %end
                                %if(strcmp(opt,'mediana') == 1)
                                %    vectorAUX_SR = [median(HLs(:)) , median(HDs(:))];
                                %end
                                vectorAUX_SR = score(imagen_original, imagenSR(:,:,Id_SR), arg); % Para no cambiar el resto...
                                %Almacenamos salidas muestras SR
                                scoreMuestrasSR(Id_SR) = vectorAUX_SR;
                            end  %id_SR
                            scoreMuestrasSR = sort(scoreMuestrasSR); %Ordeno de menor a mayor cada columna
                            %caldulo valor de normalizacion para cada caso
                            casoSR = 1;
                            for Id_SR = nMuestrasSR
                                den = 0;
                                for Id2_SR = 1:Id_SR
                                    den = den + scoreMuestrasSR(Id2_SR);
                                end
                                den = den / Id_SR;
                                %Almacenamos scores
                                if g == 1
                                    %vectorAUX
                                    matrizImpostorasH_SR(contImpostorasH,casoSR) = vectorAUX/den;
                                    NON_SR(contImpostoras_caso,casoSR) = vectorAUX/den;
                                    
                                    matrizImpostorasH_SR_ZN(contImpostorasH,casoSR) = ((vectorAUX/den)-mediaSR(casoSR))/desvSR(casoSR);
                                else
                                    %vectorAUX
                                    matrizImpostorasM_SR(contImpostorasM,casoSR) = vectorAUX/den;
                                    NON_SR(contImpostoras_caso,casoSR) = vectorAUX/den;
                                    
                                    matrizImpostorasM_SR_ZN(contImpostorasM,casoSR) = ((vectorAUX/den)-mediaSR(casoSR))/desvSR(casoSR);
                                end
                                casoSR = casoSR + 1;
                            end
                            if g == 1
                                contImpostorasH = contImpostorasH + 1;
                            else
                                contImpostorasM = contImpostorasM + 1;
                            end
                            contImpostoras_caso = contImpostoras_caso + 1;
                        else
                            strcat('** AVISO: el fichero de prueba IMPOSTORA ', ruta_completa, ' NO EXISTE')
                            
                        end %EXISTE ruta_completa
                        
                    end %n2~=n
                end %bucle n2=male
                if testImpostorMultiGenero == 1
                    for n2= todos{mod(g,2)+1}
                        if (n2 ~= n)
                            if n2 < 10 %Siempre el número debe ser de 3 dígitos.
                                numero2 = strcat(num2str(n2,'00%i'), genero{mod(g,2)+1});
                            elseif n2 < 100
                                numero2 = strcat(num2str(n2,'0%i'), genero{mod(g,2)+1});
                            else
                                numero2 = strcat(num2str(n2,'%i'), genero{mod(g,2)+1});
                            end %if n2
                            imagen2 = strcat(lado{l}, '_07');
                            ruta_completa = strcat(root, numero2, '_');
                            ruta_completa = strcat(ruta_completa, imagen2, '.png');
                            if exist(ruta_completa,'file')
                                %Cargamos la imagen principal
                                imagen_original = imread(ruta_completa);
                                distancias = zeros(1,d3);
                                distancias_ZN = zeros(1,d3);
                                for i2 = 1:d3
                                    distancias(1,i2) = score(imagen_original, patron(:,:,i2), arg);
                                    distancias_ZN(1,i2) = (distancias(1,i2)-media)/desv;
                                end
                                %En función de "opt" realizamos la acción indicada
                                if(strcmp(opt,'min') == 1)
                                    vectorAUX = min(distancias(:));  % no es vector, pero mantengo nombre para minimizar cambios
                                    vectorAUX_ZN = min(distancias_ZN(:));
                                end
                                if(strcmp(opt,'max') == 1)
                                    vectorAUX = max(distancias(:));
                                    vectorAUX_ZN = max(distancias_ZN(:));
                                end
                                if(strcmp(opt,'media') == 1)
                                    vectorAUX = mean(distancias(:));
                                    vectorAUX_ZN = mean(distancias_ZN(:));
                                end
                                if(strcmp(opt,'mediana') == 1)
                                    vectorAUX = median(distancias(:));
                                    vectorAUX_ZN = median(distancias_ZN(:));
                                end
                                %Almacenamos VectorAux en la matriz de Impostoras
                                if g == 1
                                    matrizImpostorasH = vertcat(matrizImpostorasH, vectorAUX);
                                    NON = vertcat(NON, vectorAUX);
                                    
                                    matrizImpostorasH_ZN = vertcat(matrizImpostorasH_ZN, vectorAUX_ZN);
                                else
                                    matrizImpostorasM = vertcat(matrizImpostorasM, vectorAUX);
                                    NON = vertcat(NON, vectorAUX);
                                    
                                    matrizImpostorasM_ZN = vertcat(matrizImpostorasM_ZN, vectorAUX_ZN);
                                end
                                
                                % PARTE SCORE RATIO
                                
                                for Id_SR = 1:dSR3
                                    %HLs = zeros(1,d3); HDs=zeros(1,d3);
                                    %for i2 = 1:d3
                                    %[HL , HD] = distancia(imagenSR(:,:,Id_SR), imagen_original);
                                    %HLs(1,1) = HL
                                    %HDs(1,1) = HD
                                    %matrizAutenticas = vertcat(matrizAutenticas, distancia(imagen_original,imagen_comprobar));
                                    %end
                                    %En función de "opt" realizamos la acción indicada
                                    %if(strcmp(opt,'min') == 1)
                                    %    vectorAUX_SR = [min(HLs(:)) , min(HDs(:))]
                                    %end
                                    %if(strcmp(opt,'max') == 1)
                                    %    vectorAUX_SR = [max(HLs(:)) , max(HDs(:))];
                                    %end
                                    %if(strcmp(opt,'media') == 1)
                                    %    vectorAUX_SR = [mean(HLs(:)) , mean(HDs(:))];
                                    %end
                                    %if(strcmp(opt,'mediana') == 1)
                                    %    vectorAUX_SR = [median(HLs(:)) , median(HDs(:))];
                                    %end
                                    vectorAUX_SR = score(imagen_original, imagenSR(:,:,Id_SR), arg); % Para no cambiar el resto...
                                    %Almacenamos salidas muestras SR
                                    scoreMuestrasSR(Id_SR) = vectorAUX_SR;
                                end  %id_SR
                                scoreMuestrasSR = sort(scoreMuestrasSR); %Ordeno de menor a mayor cada columna
                                %caldulo valor de normalizacion para cada caso
                                casoSR = 1;
                                for Id_SR = nMuestrasSR
                                    den = 0;
                                    for Id2_SR = 1:Id_SR
                                        den = den + scoreMuestrasSR(Id2_SR);
                                    end
                                    den = den / Id_SR;
                                    %Almacenamos scores
                                    if g == 1
                                        %vectorAUX
                                        matrizImpostorasH_SR(contImpostorasH,casoSR) = vectorAUX/den;
                                        NON_SR(contImpostoras_caso,casoSR) = vectorAUX/den;
                                        
                                        matrizImpostorasH_SR_ZN(contImpostorasH,casoSR) = ((vectorAUX/den)-mediaSR(casoSR))/desvSR(casoSR);
                                    else
                                        %vectorAUX
                                        matrizImpostorasM_SR(contImpostorasM,casoSR) = vectorAUX/den;
                                        NON_SR(contImpostoras_caso,casoSR) = vectorAUX/den;
                                        
                                        matrizImpostorasM_SR_ZN(contImpostorasM,casoSR) = ((vectorAUX/den)-mediaSR(casoSR))/desvSR(casoSR);
                                    end
                                    casoSR = casoSR + 1;
                                end
                                if g == 1
                                    contImpostorasH = contImpostorasH + 1;
                                else
                                    contImpostorasM = contImpostorasM + 1;
                                end
                                contImpostoras_caso = contImpostoras_caso + 1;
                            else
                                strcat('** AVISO: el fichero de prueba IMPOSTORA ', ruta_completa, ' NO EXISTE')
                                
                            end %EXISTE ruta_completa
                            
                        end %n2~=n
                    end %bucle n2=female
                end % testImpostorMultiGenero == 1
                
                %Resultados individuales
                disp(['*** Resultados para usuario ', num2str(n), ' dedo ', lado{l}]);
                fprintf(fileID,'%s\n',['*** Resultados para usuario ', num2str(n), ' dedo ', lado{l}]);
                %TAR
                %NON
                fprintf(fileID,'TAR:\n');
                fprintf(fileID,'\t%d\n',TAR);
                fprintf(fileID,'NON:\n');
                fprintf(fileID,'\t%d\n',NON);
                disp(['Sin Score Ratio'])
                fprintf(fileID,'Sin Score Ratio\n');
                %compute Pmiss and Pfa from experimental detection output scores
                [P_miss,P_fa] = Compute_DET (TAR, NON);
                %Calculamos EER
                EER = eer(P_miss,P_fa);
                if g == 1
                    EerIndH(nExp_H,1) = 1-EER;
                else
                    EerIndM(nExp_M,1) = 1-EER;
                end
                disp(['EER: ', num2str(1-EER)]);
                
                %TAR_SR
                %NON_SR
                disp(['Con Score Ratio'])
                casoSR = 1;
                for Id_SR = nMuestrasSR
                    %compute Pmiss and Pfa from experimental detection output scores
                    [P_miss,P_fa] = Compute_DET (TAR_SR(:,casoSR), NON_SR(:,casoSR));
                    %Calculamos EER
                    EER = eer(P_miss,P_fa);
                    if g == 1
                        EerIndH_SR(nExp_H,casoSR) = 1-EER;
                    else
                        EerIndM_SR(nExp_M,casoSR) = 1-EER;
                    end
                    disp(['EER (SR ', num2str(Id_SR), '): ', num2str(1-EER)]);
                    casoSR = casoSR + 1;
                end %nMuestrasSR
                if g == 1
                    nExp_H = nExp_H + 1;
                else
                    nExp_M = nExp_M + 1;
                end
                %return
                %parar en el primer usuario.
            end % l=1:2
                %return
                %parar en el primer usuario con sus dos lados.
        end % BUCLE INICIAL
    end % male
    
end % genero
%Resultados globales
disp(['***Resultados TOTALES***'])
disp(['++Sin Score Ratio'])
if isMale == 1
    disp(['***Resultados HOMBRES***'])
    disp(['Media EER individuales: ', num2str(mean(EerIndH))])
    %compute Pmiss and Pfa from experimental detection output scores
    [P_miss,P_fa] = Compute_DET (matrizAutenticasH, matrizImpostorasH);
    %Calculamos EER
    EER = eer(P_miss,P_fa);
    disp(['EER: ', num2str(1-EER)]);
    [P_miss,P_fa] = Compute_DET (matrizAutenticasH_ZN, matrizImpostorasH_ZN);
    %Calculamos EER
    EER = eer(P_miss,P_fa);
    disp(['EER (ScoreNorm): ', num2str(1-EER)]);
end
if isFemale == 1
    disp(['***Resultados MUJERES***'])
    disp(['Media EER individuales: ', num2str(mean(EerIndM))]);
    %compute Pmiss and Pfa from experimental detection output scores
    [P_miss,P_fa] = Compute_DET (matrizAutenticasM, matrizImpostorasM);
    %Calculamos EER
    EER = eer(P_miss,P_fa);
    disp(['EER: ', num2str(1-EER)]);
    [P_miss,P_fa] = Compute_DET (matrizAutenticasM_ZN, matrizImpostorasM_ZN);
    %Calculamos EER
    EER = eer(P_miss,P_fa);
    disp(['EER(ScoreNorm): ', num2str(1-EER)]);
end
disp(['*** Resultados AMBOS ***'])
EerIndA = vertcat(EerIndH,EerIndM);
ambosAutenticas = vertcat(matrizAutenticasH,matrizAutenticasM);
ambosImpostoras = vertcat(matrizImpostorasH,matrizImpostorasM);
ambosAutenticas_ZN = vertcat(matrizAutenticasH_ZN,matrizAutenticasM_ZN);
ambosImpostoras_ZN = vertcat(matrizImpostorasH_ZN,matrizImpostorasM_ZN);
disp(['Media EER individuales: ', num2str(mean(EerIndA))]);
%compute Pmiss and Pfa from experimental detection output scores
[P_miss,P_fa] = Compute_DET (ambosAutenticas, ambosImpostoras);
%Calculamos EER
EER = eer(P_miss,P_fa);
disp(['EER: ', num2str(1-EER)]);
[P_miss,P_fa] = Compute_DET (ambosAutenticas_ZN, ambosImpostoras_ZN);
%Calculamos EER
EER = eer(P_miss,P_fa);
disp(['EER(ScoreNorm): ', num2str(1-EER)]);

disp(['++Con Score Ratio'])
if isMale == 1
    casoSR = 1;
    for Id_SR = nMuestrasSR
        disp(['***Resultados HOMBRES(SR ', num2str(Id_SR), ') ***'])
        disp(['Media EER individuales (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndH_SR(:,casoSR)))])
        %compute Pmiss and Pfa from experimental detection output scores
        [P_miss,P_fa] = Compute_DET (matrizAutenticasH_SR(:,casoSR), matrizImpostorasH_SR(:,casoSR));
        %Calculamos EER
        EER = eer(P_miss,P_fa);
        disp(['EER: ', num2str(1-EER)]);
        [P_miss,P_fa] = Compute_DET (matrizAutenticasH_SR_ZN(:,casoSR), matrizImpostorasH_SR_ZN(:,casoSR));
        %Calculamos EER
        EER = eer(P_miss,P_fa);
        disp(['EER(ScoreNorm): ', num2str(1-EER)]);
        casoSR = casoSR + 1;
    end
end
if isFemale == 1
    casoSR = 1;
    for Id_SR = nMuestrasSR
        disp(['***Resultados MUJERES (SR ', num2str(Id_SR), ') ***']);
        disp(['Media EER individuales (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndM_SR(:,casoSR)))]);
        %compute Pmiss and Pfa from experimental detection output scores
        [P_miss,P_fa] = Compute_DET (matrizAutenticasM_SR(:,casoSR), matrizImpostorasM_SR(:,casoSR));
        %Calculamos EER
        EER = eer(P_miss,P_fa);
        disp(['EER: ', num2str(1-EER)]);
        [P_miss,P_fa] = Compute_DET (matrizAutenticasM_SR_ZN(:,casoSR), matrizImpostorasM_SR_ZN(:,casoSR));
        %Calculamos EER
        EER = eer(P_miss,P_fa);
        disp(['EER(ScoreNorm): ', num2str(1-EER)]);
        casoSR = casoSR + 1;
    end
end
casoSR = 1;
EerIndA_SR = vertcat(EerIndH_SR,EerIndM_SR);
ambosAutenticas_SR = vertcat(matrizAutenticasH_SR,matrizAutenticasM_SR);
ambosImpostoras_SR = vertcat(matrizImpostorasH_SR,matrizImpostorasM_SR);
ambosAutenticas_SR_ZN = vertcat(matrizAutenticasH_SR_ZN,matrizAutenticasM_SR_ZN);
ambosImpostoras_SR_ZN = vertcat(matrizImpostorasH_SR_ZN,matrizImpostorasM_SR_ZN);
for Id_SR = nMuestrasSR
    disp(['***Resultados AMBOS(SR ', num2str(Id_SR), ') ***'])
    disp(['Media EER individuales: ', num2str(mean(EerIndA_SR(:,casoSR)))]);
    %compute Pmiss and Pfa from experimental detection output scores
    [P_miss,P_fa] = Compute_DET (ambosAutenticas_SR(:,casoSR), ambosImpostoras_SR(:,casoSR));
    %Calculamos EER
    EER = eer(P_miss,P_fa);
    disp(['EER: ', num2str(1-EER)]);
    [P_miss,P_fa] = Compute_DET (ambosAutenticas_SR_ZN(:,casoSR), ambosImpostoras_SR_ZN(:,casoSR));
    %Calculamos EER
    EER = eer(P_miss,P_fa);
    disp(['EER(ScoreNorm): ', num2str(1-EER)]);
    casoSR = casoSR + 1;
end
%csvwrite(strcat('csvImpostorasH', '_', opt,'.csv'), matrizImpostorasH);
%csvwrite(strcat('csvAutenticasH', '_', opt,'.csv'), matrizAutenticasH);
%csvwrite(strcat('csvImpostorasM', '_', opt,'.csv'), matrizImpostorasM);
%csvwrite(strcat('csvAutenticasM', '_', opt,'.csv'), matrizAutenticasM);

% Limpio el path, por si acaso

rmpath(dir);
