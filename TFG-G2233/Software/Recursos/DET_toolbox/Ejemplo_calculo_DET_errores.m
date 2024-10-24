%---------------------------------------------------
%
%  Programa que calcula la CDET.
%
%--------------------------------------------------------


path(path,'D:\FingerVein\Recursos\DET_toolbox'); % ��AVISO!! Linea dependiente de maquina

%------------------------------
%load output scores
load TAR   %true_user_scores
load NON    %impostor_scores

%------------------------------
%compute Pmiss and Pfa from experimental detection output scores
[P_miss,P_fa] = Compute_DET (TAR, NON);   %(true_speaker_scores, impostor_scores);

%------------------------------
%call figure, plot DET-curve
Plot_DET (P_miss, P_fa,'k-',2);


%find lowest cost point and plot
C_miss = 1;
C_fa = 1;
P_target = 0.5;
Set_DCF(C_miss,C_fa,P_target);
[DCF_opt Popt_miss Popt_fa] = Min_DCF(P_miss,P_fa);

%Muestra por pantalla el DCF_opt y las tasas de error correspondientes
disp(['min(DCF)=',num2str(DCF_opt),'  P_fr=',num2str(Popt_miss),'  P_fa=', num2str(Popt_fa)])

%plot DCF_opt
hold on
Plot_DET (Popt_miss,Popt_fa,'ko',2);


%calcula EER
EER = eer(P_miss,P_fa);

%Muestra por pantalla el DCF_opt y las tasas de error correspondientes
disp(['EER=',num2str(EER)])

%plot EER
hold on
Plot_DET (EER,EER,'ks',2);


% figure(2)
% clf
% subplot(211)
% hist(impostor_scores), hold on
% subplot(212)
% hist(true_speaker_scores)

