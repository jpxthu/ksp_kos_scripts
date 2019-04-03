function v = fTiltDiff(tilt)

if tilt > pi / 2
    v = tilt - pi / 2;
elseif tilt < 0.05
    v = tilt - 0.05;
else
    v = 0;
end

v = v * 1e9;

end
