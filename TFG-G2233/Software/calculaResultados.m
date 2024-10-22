% Programa para generar resultados a partir de un workspace salvado

% Cargamos workspace

load Workspace_fractales.mat;

%Resultados globales
disp(['***Resultados TOTALES***'])
disp(['++Sin Score Ratio'])
if isMale == 1
    disp(['***Resultados HOMBRES***'])
    disp(['Media EER individuales HL: ', num2str(mean(EerIndHL_H))])
    disp(['Media EER individuales HD: ', num2str(mean(EerIndHD_H))])
    disp(['Media EER individuales Suma: ', num2str(mean(EerIndSuma_H))])
    %compute Pmiss and Pfa from experimental detection output scores
    [P_miss,P_fa] = Compute_DET (matrizAutenticasH(:,1), matrizImpostorasH(:,1));
    %Calculamos EER
    EER = eer(P_miss,P_fa);
    disp(['EER con HL: ', num2str(1-EER)]);
    
    [P_miss,P_fa] = Compute_DET (matrizAutenticasH(:,2), matrizImpostorasH(:,2));
    EER = eer(P_miss,P_fa);
    disp(['EER con HD: ', num2str(1-EER)]);
    
    TAR = sqrt((matrizAutenticasH(:,1).^2)+ (matrizAutenticasH(:,2).^2));
    NON = sqrt((matrizImpostorasH(:,1).^2)+ (matrizImpostorasH(:,2).^2));
    [P_miss,P_fa] = Compute_DET (TAR, NON);
    EER = eer(P_miss,P_fa);
    disp(['EER con SUMA: ', num2str(1-EER)]);
end
if isFemale == 1
    disp(['***Resultados MUJERES***'])
    disp(['Media EER individuales HL: ', num2str(mean(EerIndHL_M))])
    disp(['Media EER individuales HD: ', num2str(mean(EerIndHD_M))])
    disp(['Media EER individuales Suma: ', num2str(mean(EerIndSuma_M))])
    %compute Pmiss and Pfa from experimental detection output scores
    [P_miss,P_fa] = Compute_DET (matrizAutenticasM(:,1), matrizImpostorasM(:,1));
    %Calculamos EER
    EER = eer(P_miss,P_fa);
    disp(['EER con HL: ', num2str(1-EER)]);
    
    [P_miss,P_fa] = Compute_DET (matrizAutenticasM(:,2), matrizImpostorasM(:,2));
    EER = eer(P_miss,P_fa);
    disp(['EER con HD: ', num2str(1-EER)]);
    
    TAR = sqrt((matrizAutenticasM(:,1).^2)+ (matrizAutenticasM(:,2).^2));
    NON = sqrt((matrizImpostorasM(:,1).^2)+ (matrizImpostorasM(:,2).^2));
    %TAR = matrizAutenticasM(:,1)+ matrizAutenticasM(:,2);
    %NON = matrizImpostorasM(:,1)+ matrizImpostorasM(:,2);
    [P_miss,P_fa] = Compute_DET (TAR, NON);
    EER = eer(P_miss,P_fa);
    disp(['EER con SUMA: ', num2str(1-EER)]);
end
disp(['*** Resultados AMBOS ***'])
EerIndA_HL = vertcat(EerIndHL_H,EerIndHL_M);
EerIndA_HD = vertcat(EerIndHD_H,EerIndHD_M);
EerIndA_Suma = vertcat(EerIndSuma_H,EerIndSuma_M);
ambosAutenticas = vertcat(matrizAutenticasH,matrizAutenticasM);
ambosImpostoras = vertcat(matrizImpostorasH,matrizImpostorasM);
disp(['Media EER individuales HL: ', num2str(mean(EerIndA_HL))]);
disp(['Media EER individuales HD: ', num2str(mean(EerIndA_HD))]);
disp(['Media EER individuales Suma: ', num2str(mean(EerIndA_Suma))]);
%compute Pmiss and Pfa from experimental detection output scores
[P_miss,P_fa] = Compute_DET (ambosAutenticas(:,1), ambosImpostoras(:,1));
%Calculamos EER
EER = eer(P_miss,P_fa);
disp(['EER con HL: ', num2str(1-EER)]);

[P_miss,P_fa] = Compute_DET (ambosAutenticas(:,2), ambosImpostoras(:,2));
EER = eer(P_miss,P_fa);
disp(['EER con HD: ', num2str(1-EER)]);

TAR = ambosAutenticas(:,1)+ ambosAutenticas(:,2);
NON = ambosImpostoras(:,1)+ ambosImpostoras(:,2);
[P_miss,P_fa] = Compute_DET (TAR, NON);
EER = eer(P_miss,P_fa);
disp(['EER con SUMA: ', num2str(1-EER)]);

disp(['++Con Score Ratio'])
if isMale == 1
    casoSR = 1;
    for Id_SR = nMuestrasSR
        disp(['***Resultados HOMBRES(SR ', num2str(Id_SR), ' ***'])
        disp(['Media EER individuales HL (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndHL_H_SR(:,casoSR)))])
        disp(['Media EER individuales HD: (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndHD_H_SR(:,casoSR)))])
        disp(['Media EER individuales Suma: (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndSuma_H_SR(:,casoSR)))])
        %compute Pmiss and Pfa from experimental detection output scores
        [P_miss,P_fa] = Compute_DET (matrizAutenticasH_SR(:,1,casoSR), matrizImpostorasH_SR(:,1,casoSR));
        %Calculamos EER
        EER = eer(P_miss,P_fa);
        disp(['EER con HL: ', num2str(1-EER)]);
        
        [P_miss,P_fa] = Compute_DET (matrizAutenticasH_SR(:,2,casoSR), matrizImpostorasH_SR(:,2,casoSR));
        EER = eer(P_miss,P_fa);
        disp(['EER con HD: ', num2str(1-EER)]);
        
        TAR = matrizAutenticasH_SR(:,1,casoSR)+ matrizAutenticasH_SR(:,2,casoSR);
        NON = matrizImpostorasH_SR(:,1,casoSR)+ matrizImpostorasH_SR(:,2,casoSR);
        [P_miss,P_fa] = Compute_DET (TAR, NON);
        EER = eer(P_miss,P_fa);
        disp(['EER con SUMA: ', num2str(1-EER)]);
        casoSR = casoSR + 1;
    end
end
if isFemale == 1
    casoSR = 1;
    for Id_SR = nMuestrasSR
        disp(['***Resultados MUJERES (SR ', num2str(Id_SR), ' ***'])
        disp(['Media EER individuales HL (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndHL_M_SR(:,casoSR)))])
        disp(['Media EER individuales HD: (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndHD_M_SR(:,casoSR)))])
        disp(['Media EER individuales Suma: (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndSuma_M_SR(:,casoSR)))])
        %compute Pmiss and Pfa from experimental detection output scores
        [P_miss,P_fa] = Compute_DET (matrizAutenticasM_SR(:,1,casoSR), matrizImpostorasM_SR(:,1,casoSR));
        %Calculamos EER
        EER = eer(P_miss,P_fa);
        disp(['EER con HL: ', num2str(1-EER)]);
        
        [P_miss,P_fa] = Compute_DET (matrizAutenticasM_SR(:,2,casoSR), matrizImpostorasM_SR(:,2,casoSR));
        EER = eer(P_miss,P_fa);
        disp(['EER con HD: ', num2str(1-EER)]);
        
        TAR = matrizAutenticasM_SR(:,1,casoSR)+ matrizAutenticasM_SR(:,2,casoSR);
        NON = matrizImpostorasM_SR(:,1,casoSR)+ matrizImpostorasM_SR(:,2,casoSR);
        [P_miss,P_fa] = Compute_DET (TAR, NON);
        EER = eer(P_miss,P_fa);
        disp(['EER con SUMA: ', num2str(1-EER)]);
        casoSR = casoSR + 1;
    end
end
casoSR = 1;
EerIndA_SR_HL = vertcat(EerIndHL_H_SR,EerIndHL_M_SR);
EerIndA_SR_HD = vertcat(EerIndHD_H_SR,EerIndHD_M_SR);
EerIndA_SR_Suma = vertcat(EerIndSuma_H_SR,EerIndSuma_M_SR);
ambosAutenticas_SR = vertcat(matrizAutenticasH_SR,matrizAutenticasM_SR);
ambosImpostoras_SR = vertcat(matrizImpostorasH_SR,matrizImpostorasM_SR);
for Id_SR = nMuestrasSR
    disp(['***Resultados AMBOS(SR ', num2str(Id_SR), ' ***'])
    disp(['Media EER individuales HL (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndA_SR_HL(:,casoSR)))])
    disp(['Media EER individuales HD: (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndA_SR_HD(:,casoSR)))])
    disp(['Media EER individuales Suma: (SR ', num2str(Id_SR), '): ', num2str(mean(EerIndA_SR_Suma(:,casoSR)))])
    %compute Pmiss and Pfa from experimental detection output scores
    [P_miss,P_fa] = Compute_DET (ambosAutenticas_SR(:,1,casoSR), ambosImpostoras_SR(:,1,casoSR));
    %Calculamos EER
    EER = eer(P_miss,P_fa);
    disp(['EER con HL: ', num2str(1-EER)]);
    
    [P_miss,P_fa] = Compute_DET (ambosAutenticas_SR(:,2,casoSR), ambosImpostoras_SR(:,2,casoSR));
    EER = eer(P_miss,P_fa);
    disp(['EER con HD: ', num2str(1-EER)]);
    
    TAR = ambosAutenticas_SR(:,1,casoSR)+ ambosAutenticas_SR(:,2,casoSR);
    NON = ambosImpostoras_SR(:,1,casoSR)+ ambosImpostoras_SR(:,2,casoSR);
    [P_miss,P_fa] = Compute_DET (TAR, NON);
    EER = eer(P_miss,P_fa);
    disp(['EER con SUMA: ', num2str(1-EER)]);
    casoSR = casoSR + 1;
end