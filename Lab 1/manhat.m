function d = manhat(x,y,u,v)
% MANHATTANAVSTÅNDET mellan två punkter i planet.
% Den första punkten har koordinaterna (x,y) den andra punkten har
% koordinaterna (u,v)

d = abs(x-u) + abs(y - v);
end 