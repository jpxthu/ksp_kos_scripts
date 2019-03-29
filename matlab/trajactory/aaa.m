function aaa(dt, n, throttle, tilt)

thrust1 = 2298.387;
thrust0 = 2500.000;

vx = zeros(n, 1);
vy = zeros(n, 1);
h  = zeros(n, 1);
x  = zeros(n, 1);
m  = zeros(n, 1) + 113;

thrustMax = zeros(n, 1);

for i = 2 : n
    g = MU / (h(i - 1) + R) ^ 2;
    [~, pAtm, ~] = KerbinAtmosphere(h(i - 1));
    thrustMax(i) = thrust1 + (thrust0 - thrust1) * pAtm;
    aTh = throttle(i - 1) * thrustMax(i) / m(i - 1);
    ax = aTh * sin(tilt(i));
    ay = aTh * cos(tilt(i)) - g;

    vx(i) = vx(i - 1) + ax * dt;
    vy(i) = vy(i - 1) + ay * dt;
    x(i) = x(i - 1) + vx(i) * dt;
    h(i) = h(i - 1) + vy(i) * dt;
    m(i) = m(i - 1) - fuelRate * throttle(i);

    % dax = dthrottle * thrustMax / m * sin(tilt + dtilt)
    % day = dthrottle * thrustMax / m * cos(tilt + dtilt)
end

end
