pos = [0, 0, 0];
vel = [-807.512950590576, -1.38879158941039, -614.614290958791];
acc = zeros(0, 3);
att = 68016;

dt = 10;

up = [-0.758404424476892, -0.00181315178167167, 0.651781743695304];
m = 102.158508300781 * 1000;

res = [-40821.3753890043, 19.8997795268399, -194681.987527848];

tarH = res * up' + att;

while 1
    h = att + pos(end, :) * up';
    if h < tarH
        break;
    end
    
    g = 3.5316e12 / (h + 6e5) ^ 2;
    dens = 3.407 * exp(- ((h + 18250) / 17990) ^ 2);
    acc = [acc; -g * up - vel(end, :) * norm(vel(end, :)) * dens / m];
    vel = [vel; vel(end, :) + acc(end, :) * dt];
    pos = [pos; pos(end, :) + vel(end, :) * dt];
end

acc = [acc; acc(end, :)];

clear ax;
ax(1) = subplot(3, 1, 1);
plot(acc);
grid on;

ax(2) = subplot(3, 1, 2);
plot(vel);
grid on;

ax(3) = subplot(3, 1, 3);
plot(pos);
grid on;

linkaxes(ax, 'x');
