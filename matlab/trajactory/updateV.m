function [throttle, tilt] = updateV(dt, n, throttle, tilt, thrustMax, vx, vy, h, m)

constant;

dae = zeros(n, 2);
dat = zeros(n, 2);
dve = zeros(n, 2);
dvt = zeros(n, 2);
dpe = zeros(n, 2);
dpt = zeros(n, 2);
dme = zeros(n, 1);
dfe = zeros(n, 1);
dft = zeros(n, 1);

for i = 1 : n - 1
    dae(i, :) = thrustMax(i) / m(i) * [sin(tilt(i)), cos(tilt(i))];
    dat(i, :) = thrustMax(i) / m(i) * [cos(tilt(i)), -sin(tilt(i))] * throttle(i);
    dve(i, :) = dae(i, :) * dt;
    dvt(i, :) = dat(i, :) * dt;
    dpe(i, :) = (n - i) * dae(i, :) * dt ^ 2;
    dpt(i, :) = (n - i) * dat(i, :) * dt ^ 2;
    dme(i) = -FR * dt;
    dfe(i) = fThrottleDiff(throttle(i));
    dft(i) = fTiltDiff(tilt(i));
end

deeVx = 2 * Cvx * (vx(n) - tarVx) * dve(:, 1);
deeVy = 2 * Cvy * vy(n) * dve(:, 2);
deeh  = 2 * Ch * (h(n) - tarH) * dpe(:, 1);
deem  = - Cm * dme;
deee  = dfe;
dee = deeVx + deeVy + deeh + deem + deee;

detVx = 2 * Cvx * (vx(n) - tarVx) * dvt(:, 1);
detVy = 2 * Cvy * vy(n) * dvt(:, 2);
detH  = 2 * Ch * (h(n) - tarH) * dpt(:, 1);
dett  = dft;
det = detVx + detVy + detH + dett;

length = sum([dee; det] .^ 2) ^ 0.5;

figure(2);
ax(1) = subplot(2, 1, 1);
plot([deeVx, deeVy, deeh, deem, deee]);
grid on;
legend('v_x', 'v_y', 'h', 'm', 'e');

ax(2) = subplot(2, 1, 2);
plot([detVx, detVy, detH, dett]);
grid on;
legend('v_x', 'v_y', 'h', 't');

linkaxes(ax, 'x');

step = 1 / length;
throttle = throttle - dee * step;
tilt = tilt - det * step;

end
