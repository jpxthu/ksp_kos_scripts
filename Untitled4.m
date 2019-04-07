a = load('4.log');
% a = a(1 : end - 10, :);

n = size(a, 1);
v = a(:, 1);
acc = a(:, 2);
h = a(:, 3);
m = a(:, 4);

dens = 3.407 .* exp(- ((h + 18250) ./ 17990) .^ 2);

axi = 0;
axn = 4;

axi = axi + 1;
ax(axi) = subplot(axn, 1, axi);
plot(h);
grid on;

axi = axi + 1;
ax(axi) = subplot(axn, 1, axi);
plot(v);
grid on;

axi = axi + 1;
ax(axi) = subplot(axn, 1, axi);
plot([v .^ 2 .* dens ./ m ./ 1000 * 3, acc]);
grid on;
ylim([0, 60]);

axi = axi + 1;
ax(axi) = subplot(axn, 1, axi);
plot(dens);
grid on;

linkaxes(ax, 'x');
