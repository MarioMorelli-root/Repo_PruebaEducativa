%% Funcion que aplica la normalizacion por maximo y minimo de tal manera que los valores de cada columna esten comprendidos entre 0 y 1

function data_s = MinMaxNorm(data_e)

[num_fil,num_col] = size(data_e);

data_s=[];
for i=1:num_col
  data_s = [data_s,(data_e(:,i)-min(data_e(:,i)))/(max(data_e(:,i))-min(data_e(:,i)))];
  end
