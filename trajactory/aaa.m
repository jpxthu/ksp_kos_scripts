function aaa(dt, n, throttle, tilt)

thrust1 = 2298.387;
thrust0 = 2500.000;

vx = zeros(n, 1);
vy = zeros(n, 1);
h  = zeros(n, 1);
x  = zeros(n, 1);

thrustMax = zeros(n, 1);

for i = 2 : n
    g = MU / (h(i - 1) + R) ^ 2;
    [~, pAtm, ~] = KerbinAtmosphere(h(i - 1));
    thrustMax(i) = thrust1 + (thrust0 - thrust1) * pAtm;
    
end

end
