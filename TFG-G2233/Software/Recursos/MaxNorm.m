%% Funcion que aplica la normalizacion por division por el maximo a cada columna de la matriz introducida como argumento

function data_s = MaxNorm(data_e)

[num_fil,num_col] = size(data_e);

data_s=[];
for i=1:num_col
  data_s = [data_s,data_e(:,i)/max(data_e(:,i))];
  end
