close all
clear all

path(path,'C:\Users\Sergio_Venas\Desktop\FingerVein\Recursos\DET_toolbox\'); % ��AVISO!! Linea dependiente de maquina

%% Opci�n de fusi�n.
% Opciones: 'suma' , 'max' , 'min'
option = 'suma';

%% Formato del archivo
% Genero-N�mero-NombreArchivo-ScoreRatio-Correlaci�nDistMaxima-
% -CorrelacionNCoeficientes-DCT-Xor-And
% Separado por espacio en vez de gui�n, todo en una misma fila.

autenticas = importdata('autenticas.txt');
impostoras = importdata('impostoras.txt');
%importdata() genera una estructura que diferencia el texto de los n�meros
%dividiendo cada linea del archivo en "metadatos" y "resultados"
metadataA = autenticas.textdata;
SrA = autenticas.data(:,1);
resultsA = autenticas.data(:,2:end);

metadataI = impostoras.textdata;
SrI = impostoras.data(:,1);
resultsI = impostoras.data(:,2:end);

%% Obtenci�n de n�mero de Datos y n�mero de pruebas.
[numDatosA numPruebasA] = size(resultsA);
[numDatosI numPruebasI] = size(resultsI);

%% Normalizaci�n de pruebas que lo necesiten.

for i = 1:numPruebasA
    maximoA = max(resultsA(:,i));
    minimoA = min(resultsA(:,i)); 
    maximoI = max(resultsI(:,i));
    minimoI = min(resultsI(:,i));
    maximo = max(maximoA,maximoI);
    minimo = min(minimoA,minimoI);
    med = (maximo - minimo)/2;
    
    if (1 == 0)
    %if(maximo > 1 || minimo < 0)
        normalizadosA(:,i) = sigmf(resultsA(:,i), [0.01, (med + minimo)]);
        normalizadosI(:,i) = sigmf(resultsI(:,i), [0.01, (med + minimo)]);
    else
        normalizadosA(:,i) = resultsA(:,i);
        normalizadosI(:,i) = resultsI(:,i);
    end
end


%% Nos quedamos con cada columna

for i = 1:numPruebasA
    TAR = normalizadosA(:,i);
    NON = normalizadosI(:,i);
    [P_miss, P_fa] = Compute_DET(TAR, NON);
    EER = 1 - eer(P_miss,P_fa);
    disp(['EER para caracteristica ', num2str(i), ' :', num2str(EER)]); 
end
%% Se calcula el EER
%numUsuarios = size(TAR);
%numUsuarios = numUsuarios(2);
%EER = zeros(numUsuarios,1);
%for i = 1:numUsuarios
%    [P_miss, P_fa] = Compute_DET(TAR{i}, NON{i});
%    EER(i) = eer(P_miss,P_fa);
%end

%% Se imprime el EER en un archivo CSV
%csvwrite('Fusion_Minimo_EER_SR_ZN.csv',EER);