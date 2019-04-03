function v = fThrottleDiff(throttle)

if throttle > 1
    v = throttle - 1;
elseif throttle < 0
    v = throttle;
else
    v = 0;
end

v = v * 1e9;

end
