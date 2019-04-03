function [vx, vy, h, x, m, thrustMax, throttle] = predict(dt, n, throttle, tilt)

constant;

vx = zeros(n, 1);
vy = zeros(n, 1);
h  = zeros(n, 1);
x  = zeros(n, 1);
m  = zeros(n, 1) + mMax;

thrustMax = zeros(n, 1);

for i = 2 : n
    g = MU / (h(i - 1) + R) ^ 2;
    ac = vx(i - 1) ^ 2 / (h(i - 1) + R);
    [~, pAtm, ~] = KerbinAtmosphere(h(i - 1));
    thrustMax(i) = thrust1 + (thrust0 - thrust1) * pAtm;
    aTh = throttle(i - 1) * thrustMax(i) / m(i - 1);
    ax = aTh * sin(tilt(i));
    ay = aTh * cos(tilt(i)) - g + ac;

    vx(i) = vx(i - 1) + ax * dt;
    vy(i) = vy(i - 1) + ay * dt;
    x(i) = x(i - 1) + vx(i) * dt;
    h(i) = h(i - 1) + vy(i) * dt;
    m(i) = m(i - 1) - FR * throttle(i - 1) * dt;
    
    throttle(i) = min(1, max(0, throttle(i)));
    tilt(i) = min(pi / 2, max(0, tilt(i)));
    if m(i) <= mMin
        throttle(i) = 0;
    end
end

end
