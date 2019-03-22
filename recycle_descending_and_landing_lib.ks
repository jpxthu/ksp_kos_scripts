set MIN_HEIGHT to 50.
// set MIN_HEIGHT to 15.
set MIN_VELOCITY to 3.
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

    local tarVel is targetVelocity(dist, maxAcc).

    local dt is 0.1.
    local tarVel2 is targetVelocity(dist - vel * dt, maxAcc).
    local tarAcc is (tarVel - tarVel2) / dt.

    return ((vel - tarVel) * KP + tarAcc) / maxAcc.
}
