function KerbinAtmosphereTest

h = (0 : 70000)';
n = size(h, 1);
pPa1 = zeros(n, 1);
pPa2 = zeros(n, 1);
pAtm1 = zeros(n, 1);
pAtm2 = zeros(n, 1);
dens1 = zeros(n, 1);
dens2 = zeros(n, 1);
TK = zeros(n, 1);

for i = 1 : n
    [x, y, z] = KerbinAtmosphere(h(i));
    pPa1(i) = x;
    pAtm1(i) = y;
    dens1(i) = z;
    
    [x, y, z, t] = KerbinAtmospherePrecise(h(i));
    pPa2(i) = x;
    pAtm2(i) = y;
    dens2(i) = z;
    TK(i) = t;
end

ax(1) = subplot(4, 1, 1);
plot(h, log([pPa1, pPa2]) / log(10));
grid on;
legend('pPa1', 'pPa2');

ax(2) = subplot(4, 1, 2);
plot(h, log([pAtm1, pAtm2]) / log(10));
grid on;
legend('pAtm1', 'pAtm2');

ax(3) = subplot(4, 1, 3);
plot(h, log([dens1, dens2]) / log(10));
grid on;
legend('dens1', 'dens2');

ax(4) = subplot(4, 1, 4);
plot(h, TK);
grid on;
legend('T');

linkaxes(ax, 'x');

end
