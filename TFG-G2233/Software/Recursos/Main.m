%calcula modelos firmas
%programa principal
clear;
clear functions;

path(path,'C:\Documents and Settings\cevp\DOCENCIA\MBI\Toolbox_Curso14-15\Firmas_toolbox'); % ¡¡AVISO!! Linea dependiente de maquina
path(path,'C:\Documents and Settings\cevp\DOCENCIA\MBI\Toolbox_Curso14-15\DET_toolbox'); % ¡¡AVISO!! Linea dependiente de maquina
%path(path,'C:\Users\alfcarr\Documents\MATLAB\DET_toolbox\'); % ¡¡AVISO!! Linea dependiente de maquina

%% Variables generales

% Para la normalizacion geométrica de la firma
PCX=0;           % Punto traslado centro masas (coord X)
PCY=0;           % Punto traslado centro masas (coord Y)

% Para la clasificación. Se define tamaño de la firma normalizada,
% parametros de la distancia fraccional y estadistico sobre distancias a
% las firmas del modelo
criterio_final='min';
ventana=0;  % Numero de muestras antes y despues de cada una que forman parte del vector de caracteristicas
num_vec=30;  % Numero de puntos de la firma normalizada.
% IMPORTANTE: si es mayor que el numero de la firma original se generará un aviso, aunque el algoritmo
%funciona igual.
P=0.4;

%Directorio del corpus
dirFirmas='C:\Documents and Settings\cevp\DOCENCIA\MBI\MCYT100';

% Para normalización de los vectores de características
normalizar_comp='no';  % si->se normalizan los valores de las caracteristicas extraids   no->No se normalizan
normalizacion=1;  %Tipo de normalizacion: 1->ZNorm  2->MaxNorm   3->MinMaxNorm

% Variables para guardar datos
TAR_todos = []; %para almacenar las salidas genuinas de todos los firmantes
RND_todos = []; %salidas del clasificador para muestras de impostores random, todos los firmantes
EER_rnd = []; %para almacenar los EER impostores random con umbral individual

%% Creamos el Modelo
%Los valores de los bucles dependerán de la configuración del experimento

for firmante=0:99
    centenas=floor(firmante/100);
    resto=mod(firmante,100);
    decenas=floor(resto/10);
    unidades=mod(resto,10);
    nombre_usuario = strcat('0',num2str(centenas),num2str(decenas),num2str(unidades));

    num_mues_ent=0;

    for firma_ent=0:4
        %disp(['Procesando firma Entrenamiento: ',nombre_usuario,'v0',num2str(firma_ent),'.ascii']);
        [vect,n,p,fs]=leer_firma_ascii([dirFirmas,'\',nombre_usuario,'\',nombre_usuario,'v0',num2str(firma_ent),'.ascii']);
        %disp(['numero vectores: ',num2str(n), '. Periodo medio muestreo: ', num2str(1/fs)]);
        %hold on;
        %plot(vect(:,1),vect(:,2));  %Para ver la firma sin normalizar en posición
        vect=trasladaFirma(vect,PCX,PCY);
        %plot(vect(:,1),vect(:,2),'b'); %Para ver la firma normalizada en posición
        vect = Normaliza_Puntos(vect,num_vec); %Normalizo el número de puntos de la firma
        %plot(vect(:,1),vect(:,2),'r.'); %Para ver la firma normalizada en numero de puntos

        if strcmp(normalizar_comp,'si') & (normalizacion == 1)
            vect = ZNorm(vect);
        end
        if strcmp(normalizar_comp,'si') & (normalizacion == 2)
            vect = MaxNorm(vect);
        end
        if strcmp(normalizar_comp,'si') & (normalizacion == 3)
            vect = MinMaxNorm(vect);
        end

        [train_s{num_mues_ent+1}]=[vect];

        num_mues_ent = num_mues_ent + 1;
    end  % Bucle creación modelo
    %return;

    %% Probamos con las firmas autenticas
    %Los valores de los bucles dependerán de la configuración del experimento

    %disp(['*** Salidas pruebas autenticas cliente ',nombre_usuario,':'])
    TAR_cli=[];
    for firma_pru=5:24
        decenasFirma=floor(firma_pru/10);
        unidadesFirma=mod(firma_pru,10);
        Firma = strcat(num2str(decenasFirma),num2str(unidadesFirma));
        %disp(['Procesando firma prueba autentica: ',nombre_usuario,'v',Firma,'.ascii']);
        [vect,n,p,fs]=leer_firma_ascii([dirFirmas,'\',nombre_usuario,'\',nombre_usuario,'v',Firma,'.ascii']);
        vect=trasladaFirma(vect,PCX,PCY);
        vect = Normaliza_Puntos(vect,num_vec); %Normalizo el número de puntos de la firma

        if strcmp(normalizar_comp,'si') & (normalizacion == 1)
            vect = ZNorm(vect);
        end
        if strcmp(normalizar_comp,'si') & (normalizacion == 2)
            vect = MaxNorm(vect);
        end
        if strcmp(normalizar_comp,'si') & (normalizacion == 3)
            vect = MinMaxNorm(vect);
        end

        dist = dist_FirmasNorm(train_s,num_mues_ent,vect,criterio_final,P);
        %disp(num2str(dist));
        TAR_cli = [TAR_cli;dist];
    end
    TAR_todos = [TAR_todos;TAR_cli];  %Almacenamos salidas en matriz con todas para calculo de errores con umbral general
    %return;





    %% Probamos con las firmas de impostores random
    %Los valores de los bucles dependerán de la configuración del experimento

    %Variables generales
    firmaRnd=4;  % Firma de cada usuario que vamos a usar para random
    decenasFirma=floor(firmaRnd/10);
    unidadesFirma=mod(firmaRnd,10);
    Firma = strcat(num2str(decenasFirma),num2str(unidadesFirma));
    numPruebas=50; % Numero de pruebas random

    %disp(['*** Salidas impostores random para cliente ',nombre_usuario,':']);
    RND_cli=[];
    pruebaNumero=1;  %Contador de numero de pruebas random realizadas
    firmanteRnd=0;  %variable que contiene el firmante cuyas muestras son usadas para prueba random
    while pruebaNumero <= numPruebas
        if firmanteRnd ~= firmante  % Quito de la prueba al firmante cliente
            centenas=floor(firmanteRnd/100);
            resto=mod(firmanteRnd,100);
            decenas=floor(resto/10);
            unidades=mod(resto,10);
            nombre_usuario_Rnd = strcat('0',num2str(centenas),num2str(decenas),num2str(unidades));

            %disp(['Procesando firma prueba random: ',nombre_usuario_Rnd,'v',Firma,'.ascii']);
            [vect,n,p,fs]=leer_firma_ascii([dirFirmas,'\',nombre_usuario_Rnd,'\',nombre_usuario_Rnd,'v',Firma,'.ascii']);
            vect=trasladaFirma(vect,PCX,PCY);
            vect = Normaliza_Puntos(vect,num_vec); %Normalizo el número de puntos de la firma

            if strcmp(normalizar_comp,'si') & (normalizacion == 1)
                vect = ZNorm(vect);
            end
            if strcmp(normalizar_comp,'si') & (normalizacion == 2)
                vect = MaxNorm(vect);
            end
            if strcmp(normalizar_comp,'si') & (normalizacion == 3)
                vect = MinMaxNorm(vect);
            end

            dist = dist_FirmasNorm(train_s,num_mues_ent,vect,criterio_final,P);
            %disp(num2str(dist));
            RND_cli = [RND_cli;dist];
            pruebaNumero = pruebaNumero + 1; %siguiente prueba
            firmanteRnd = firmanteRnd + 1; %siguiente firmante
        else
            firmanteRnd = firmanteRnd + 1;  %siguiente firmante
        end
    end
    RND_todos = [RND_todos;RND_cli];

    % Calculo EER para prueba random con umbral individual
    [P_miss,P_fa] = Compute_DET (-TAR_cli, -RND_cli);  % Esta diseñada para probabilidades, por eso cambiamos signo: aqui son distancias
    EER = eer(P_miss,P_fa);
    EER = EER * 100; % Lo paso a %
    disp(['++EER firmante ', nombre_usuario, ' imitadores random: ', num2str(EER), '%']);
    EER_rnd = [EER_rnd;EER];  %Lo almaceno en el vector con todos

    %disp(['------- Acabada prueba para firmante: ',nombre_usuario, ' --------']);
    disp(' ');  %pongo linea en blando entre salidas de cada experimento


end

disp('Errores medios con umbral individual:');
EER_umbral_ind_ski = mean(EER_ski);
disp(['EER skilled = ',num2str(EER_umbral_ind_ski),'%']);
EER_umbral_ind_rnd = mean(EER_rnd);
disp(['EER random = ',num2str(EER_umbral_ind_rnd),'%']);
%return;


%% Calculamos errores con umbral general

disp('Errores con umbral general:');


%Caso prueba random
if (max(TAR_todos) <= min(RND_todos)) % Si no se solapan las salidas del clasificador el cálculo es sencillo
    EER = 0.0;
    disp(['EER random = ',num2str(EER), '%']);
    disp('Popt_miss random = 0');
    disp('Popt_fa random = 0');
    disp('DCF_opt random = 0');
else

    %compute Pmiss and Pfa from experimental detection output scores
    % La función está preparada para trabajar con probabilidades en las que
    %las distribuciones están intercambiadas. Por eso aplico el operador -
    [P_miss,P_fa] = Compute_DET (-TAR_todos, -RND_todos);

    %Calculamos EER
    EER = eer(P_miss,P_fa);
    %------------------------------
    %call figure, plot DET-curve
    Plot_DET (P_miss, P_fa,'b-',2);


    %find lowest cost point and plot
    C_miss = 10;
    C_fa = 1;
    P_target = 0.01;
    Set_DCF(C_miss,C_fa,P_target);
    [DCF_opt Popt_miss Popt_fa] = Min_DCF(P_miss,P_fa);
    hold on;
    Plot_DET (Popt_miss,Popt_fa,'bx',2);
    disp(['EER random = ',num2str(EER*100.0),'%']);
    disp(['Popt_miss random = ', num2str(Popt_miss)]);
    disp(['Popt_fa random = ', num2str(Popt_fa)]);
    disp(['DCF_opt random = ', num2str(DCF_opt)]);
end
