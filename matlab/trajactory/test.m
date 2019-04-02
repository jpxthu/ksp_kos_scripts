constant;

dt = 0.1;
n = 4000;

throttle = zeros(n, 1) + 1;
tilt = zeros(n, 1);

[vx, vy, h, x, m, thrustMax, throttle] = predict(dt, n, throttle, tilt);

while 1
    axn = 4;
    axi = 0;
    axi = axi + 1;
    ax(axi) = subplot(axn, 1, axi);
    plot([vx, vy]);
    grid on;
    legend('v_x', 'v_y');
    
    axi = axi + 1;
    ax(axi) = subplot(axn, 1, axi);
    plot([h, x]);
    grid on;
    legend('h', 'x');
    
    axi = axi + 1;
    ax(axi) = subplot(axn, 1, axi);
    plot(m);
    grid on;
    legend('Mass');
    
    axi = axi + 1;
    ax(axi) = subplot(axn, 1, axi);
    plot([throttle, tilt]);
    grid on;
    legend('Throttle', 'Tilt');
    
    linkaxes(ax, 'x');
    pause(0.01);
    
    [throttle, tilt] = updateV(dt, n, throttle, tilt, thrustMax, vx, vy, h, m);
    [vx, vy, h, x, m, thrustMax, throttle] = predict(dt, n, throttle, tilt);
end
