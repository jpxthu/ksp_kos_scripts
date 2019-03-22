ang = (0 : pi / 100 : pi)';
cp = cos(ang);
plot(ang, [cp, sqrt(1 - cp .^ 2)]);