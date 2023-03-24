function d = manhat(x,y,u,v)
% MANHATTANAVST�NDET mellan tv� punkter i planet.
% Den f�rsta punkten har koordinaterna (x,y) den andra punkten har
% koordinaterna (u,v)

d = abs(x-u) + abs(y - v);
end 