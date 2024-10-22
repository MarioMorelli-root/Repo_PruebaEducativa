function dist = score( img1,img2,args )
% distancia basada en la matriz de correlacion

%% Variables

umbralCorr = args{1};


%% Calculo correlacion

cc = normxcorr2(img1,img2);


%% Calculo de distancia

%[dist I] =  max(abs(cc(:))); % PRUEBA valor maximo
%dist = 1-dist;

% PRUEBA a coger la media de los n mas altos
%n = 100;
%dist = 0;
%[nF nC] = size(cc);
%for i=1:n
%[M I] =  max(abs(cc(:)));
%dist = dist + (1-M);  % para pasarlo a distancia
%[f c] = ind2sub([nF nC], I);
%cc(f,c) = 0;
%end
%dist = dist / n;
%pause;

dist = (1-sigmf(length(find(cc > umbralCorr)), [0.01 500]));  % Normalizado a [0,1]

%dist = -(length(find(cc > umbralCorr)));  % PRUEBA numero de valores encima umbral
%if dist == 0  %% da problemas en score ratio
%    umbralCorr = umbralCorr-0.05;
%    dist = -(length(find(cc > umbralCorr)));
%    while dist == 0
%        umbralCorr = umbralCorr-0.05;
%        dist = -(length(find(cc > umbralCorr)));
%    end
%dist = -0.1;
%end

%dist = (1-dist) + (1-sigmf(length(find(cc > umbralCorr)), [0.01 250])); % PRUEBA fusion scores 

%pause;
return

