set MIN_HEIGHT to 50.
// set MIN_HEIGHT to 15.
set MIN_VELOCITY to 4.
set KP TO 10.

function targetVelocity {
    parameter dist.
    parameter maxAcc.

    return max(MIN_VELOCITY, sqrt(max(0, (dist - MIN_HEIGHT) * maxAcc * 2)) * 0.9).
}

function targetThrottle {
    parameter vel.
    parameter dist.
    parameter maxAcc.
    parameter gravity.

    local tarVel is targetVelocity(dist, maxAcc).

    local dt is 0.1.
    local tarVel2 is targetVelocity(dist - vel * dt, maxAcc).
    local tarAcc is (tarVel - tarVel2) / dt.

    return ((vel - tarVel) * KP + tarAcc + gravity) / maxAcc.
}

function predictThrottle {
    parameter dist.
    parameter maxAcc.
    parameter gravity.

    local tarVel is targetVelocity(dist, maxAcc).

    local dt is 0.1.
    local tarVel2 is targetVelocity(dist - tarVel * dt, maxAcc).
    local tarAcc is (tarVel - tarVel2) / dt.

    return (tarAcc + gravity) / maxAcc.
}

// c * pres * v ^ 2 * sin(a) - avlThrust * Throttle / mass * sin(a) = acc

set liftRatio to 15000.
function updateLiftRatio {
    parameter acc.
    parameter vel.
    parameter fac.
    parameter pres.
    parameter thrustAcc.

    local accS is (acc - acc * fac * fac):Mag.
    local velM is vel:Mag.
    local velV is vel:Normalized.
    local sinTheta is sqrt(max(0, 1 - (fac * velV) ^ 2)).

    local tmp is pres * velM ^ 2.
    local c is accS / (tmp * sinTheta).
    set liftRatio to liftRatio + (c - liftRatio) * max(0, 0.1 - Throttle) * 0.5.

    return liftRatio * tmp - thrustAcc.
}