function dist = dist_NormaP(firma1,firma2,P)
% Restamos elementos de las firmas

[m,n] = size(firma1);

dist = power(abs(firma1-firma2),P);
dist = sum(sum(dist)) / m;  %La división por m es para que los valores no sean tan altos
dist = power(dist,1/P);

end

