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
% dft = zeros(n, 1);

for i = 1 : n - 1
    dae(i, :) = thrustMax(i) / m(i) * [sin(tilt(i)), cos(tilt(i))];
    dat(i, :) = thrustMax(i) / m(i) * [cos(tilt(i)), -sin(tilt(i))] * throttle(i);
    dve(i, :) = dae(i, :) * dt;
    dvt(i, :) = dat(i, :) * dt;
    dpe(i, :) = (n - i) * dae(i, :) * dt ^ 2;
    dpt(i, :) = (n - i) * dat(i, :) * dt ^ 2;
    dme(i) = -FR * dt;
    dfe(i) = fThrottleDiff(throttle(i));
%     dft(i) = fTiltDiff(tilt(i));
end

dee = 2 .* Cvx .* (vx - tarVx) .* dve(:, 1) ...
    + 2 .* Cvy .* vy .* dve(:, 2) ...
    + 2 .* Ch .* (h - tarH) .* dpe(:, 1) ...
    - Cm .* dme + dfe;
det = 2 .* Cvx .* (vx - tarVx) .* dvt(:, 1) ...
    + 2 .* Cvy .* vy .* dvt(:, 2) ...
    + 2 .* Ch .* (h - tarH) .* dpt(:, 1);

length = sum([dee; det] .^ 2) ^ 0.5;

step = 10 / length;
throttle = throttle - dee * step;
tilt = tilt - det * step;

end
