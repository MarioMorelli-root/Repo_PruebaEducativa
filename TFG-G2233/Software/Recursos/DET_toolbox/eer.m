function [EER] = eer(Pmiss, Pfa)
%function [EER] = eer(Pmiss, Pfa)
%
% Funcion que calcula la tasa de equierror (EER)
%
% Pmiss and Pfa are the correcponding miss and false alarm
% trade-off probabilities.
%
%
% See DET_usage for an example of how to use Min_DCF.


npts = max(size(Pmiss));
if npts ~= max(size(Pfa))
        error ('vector size of Pmiss and Pfa not equal in call to Plot_DET');
end

%-------------------------
%Find EER:

EER_vector = Pmiss  - Pfa;
[min_val min_i] = min (abs(EER_vector));

EER = Pmiss(min_i);


