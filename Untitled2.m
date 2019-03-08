a = load('3.log');

n = size(a, 1);

imPos = a(:, 1 : 3);
laPos = a(:, 4 : 6);
plVec = a(:, 7 : 9);
vel = a(:, 10 : 12);
steer = a(:, 13 : 15);

for i = 2 : n
end

figure(2);
m = 5;
ax(1) = subplot(m, 1, 1);
plot(imPos);
grid on;

ax(2) = subplot(m, 1, 2);
plot(laPos);
grid on;

ax(3) = subplot(m, 1, 3);
plot(plVec);
grid on;

ax(4) = subplot(m, 1, 4);
plot(-vel);
grid on;

ax(5) = subplot(m, 1, 5);
plot(steer);
grid on;

linkaxes(ax, 'x');

figure(3);
t = 1500;
imPos(t, :) = imPos(t, :) / norm(imPos(t, :));
plot3([0, imPos(t, 1)], [0, imPos(t, 2)], [0, imPos(t, 3)], 'LineWidth', 2);
hold on;
laPos(t, :) = laPos(t, :) / norm(laPos(t, :));
plot3([0, laPos(t, 1)], [0, laPos(t, 2)], [0, laPos(t, 3)], 'LineWidth', 2);

plot3([0, plVec(t, 1)], [0, plVec(t, 2)], [0, plVec(t, 3)], 'LineWidth', 2);

rotateVec = cross(imPos(t, :), laPos(t, :));
plot3([0, rotateVec(1)], [0, rotateVec(2)], [0, rotateVec(3)], 'LineWidth', 2);

rotateMag = norm(rotateVec);
rotateVec = rotateVec / rotateMag * max(0.5, rotateMag * 10);
st = cross(rotateVec, plVec(t, :));
plot3([0, st(1)], [0, st(2)], [0, st(3)], 'LineWidth', 2);
axis equal;
hold off;

legend('imPos', 'laPos', 'plVec', 'r', 'st');
