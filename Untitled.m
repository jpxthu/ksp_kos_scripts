a = load('2.log');
a = a(2001 : 3000, :);

n = size(a, 1);
pres        = a(:, 1);
avlThrust   = a(:, 2);
throttle    = a(:, 3);
mass        = a(:, 4);
acc         = a(:, 5 : 7);
g           = a(:, 8);
v           = a(:, 9 : 11);
facing      = a(:, 12 : 14);
upVec       = a(:, 15 : 17);

vn          = zeros(n, 1);
ang         = zeros(n, 1);
accS        = zeros(n, 1);
ff          = zeros(n, 1);

for i = 1 : n
    acc(i, :) = acc(i, :) + g(i) * upVec(i, :);
    vn(i) = norm(v(i, :));
    vv = v(i, :) / vn(i);
    ang(i) = acos(- facing(i, :) * vv');
    accS(i) = sqrt(sum(acc(i, :) .^ 2) - (acc(i, :) * facing(i, :)') ^ 2);
    ff(i) = pres(i) * vn(i) ^ 2 * sin(ang(i));
end

m = 4;

ax(1) = subplot(m, 1, 1);
plot(pres);
grid on;
legend('Air pressure');
ylabel('Atmosphere');

ax(2) = subplot(m, 1, 2);
plot(vn);
grid on;
legend('Velocity');
ylabel('m/s');

ax(3) = subplot(m, 1, 3);
plot(ang / pi * 180);
grid on;
legend('Tilt angle');
ylabel('degree');

ax(4) = subplot(m, 1, 4);
plot([accS, ff / 1e5 * 1.74]);
% plot(acc);
grid on;
legend('Acceleration - side direction', 'Calculated result (approximate lift model)');
ylabel('m/s^2');

linkaxes(ax, 'x');
