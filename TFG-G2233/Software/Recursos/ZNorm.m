%% Funcion que aplica la normalizacion Zero a cada columna de la matriz introducida como argumento

function data_s = ZNorm(data_e)

data_s = zscore(data_e);
