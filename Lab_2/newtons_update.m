function [xr] = newtons_update(f,fder, xi)

% x0 = f(xi);
% k = fder(x0);
% b = f(x0)-k*x0;
% xr = -b/k;

xr = xi-f(xi)/fder(xi);

end

