function steps = trajactory_kerbin(k, terrain_height, h, vx, vy, m)

kr = 6e5;
kmu = 3.5316e12;

pos = [0, kr + h];
vel = [vx, vy];

steps = 0;

while 1
    steps = steps + 1;
    posFromCore = pos(end, :);
    hToRSqrMag = sum(posFromCore .^ 2);
    hToR = sqrt(hToRSqrMag);
    posFromCoreDir = posFromCore / hToR;
    
    h = hToR - kr;
    leftH = h - terrain_height;
    if leftH < 0
        break;
    end
    
    g = -kmu / hToRSqrMag * posFromCoreDir;
    dens = 3.407 * exp(-((h + 18250) / 17990) ^ 2);
    velM = norm(vel(end, :));
    acc = g - vel(end, :) * velM * dens / m * k;
    dt = min(10, max(0.1, leftH / max(1, velM) / 2));
    vel = [vel; vel(end, :) + acc * dt];
    pos = [pos; pos(end, :) + vel(end, :) * dt];
end

plot(pos(:, 1), pos(:, 2));
hold on;
rectangle('Position', [-kr, -kr, kr * 2, kr * 2], 'Curvature', [1 1]);
hold off;
grid on;
axis equal;

end
