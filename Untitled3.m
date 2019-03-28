a = load('thrust.log');

pres = a(:, 1);
thrust = a(:, 2);

plot(pres, thrust);
grid on;
xlabel('Pressure (ATM)');
ylabel('Availabel Thrust (kN)');
title('Thrust Curve');

polyfit(pres, thrust, 1)

a = load('3.log');

n           = size(a, 1);
c           = 0.00986923266716013;
pres        = a(:, 1) * c;
altitude    = a(:, 2);
velSurface  = a(:, 3 : 5);
velOrbit    = a(:, 6 : 8);
upVector    = a(:, 9 : 11);
acc         = a(:, 12 : 14);
mu          = a(1, 15);
r           = a(1, 16);
m           = a(:, 17);
facing      = a(:, 18 : 20);

g           = zeros(n, 3);
f           = zeros(n, 1);
thrustAcc   = zeros(n, 3);
coef        = zeros(n, 1);
velSurfaceM = sqrt(sum(velSurface .^ 2, 2));

x = zeros(0, 1);
y = zeros(0, 1);

for i = 1 : n
    g(i, :) = mu / (r + altitude(i)) ^ 2 * upVector(i, :);
    thrust = 2500 - pres(i) * (2500 - 2298.387);
    thrustAcc(i, :) = thrust * facing(i, :) / m(i);
    f(i) = norm(acc(i, :) + g(i, :) - thrustAcc(i, :));
    if velSurfaceM(i) > 50 && pres(i) > 0.005
        coef(i) = f(i) / pres(i) / velSurfaceM(i) ^ 2;
        x = [x; velSurfaceM(i)];
        y = [y; , coef(i)];
    end
end



plot(altitude, pres);
grid on;
xlim([0, 100000]);
ylim([0, 1]);
xlabel('Altitude (m)');
ylabel('Air Pressure (ATM)');
title('Atmosphere Curve');

ax(1) = subplot(4, 1, 1);
plot(altitude);
grid on;
ax(2) = subplot(4, 1, 2);
plot(pres);
grid on;
ax(3) = subplot(4, 1, 3);
plot(velSurfaceM / 340);
grid on;
ax(4) = subplot(4, 1, 4);
plot(coef);
grid on;
% legend('tx', 'ty', 'tz', 'ax', 'ay', 'az', 'gx', 'gy', 'gz');
