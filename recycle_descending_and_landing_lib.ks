set MIN_HEIGHT to 50.
// set MIN_HEIGHT to 15.
set MIN_VELOCITY to 4.
set KP TO 10.

function targetVelocity {
    parameter dist.
    parameter maxAcc.

    return max(MIN_HEIGHT, sqrt(max(0, (dist - MIN_HEIGHT) * maxAcc * 2)) * 0.9).
}

function targetThrottle {
    parameter vel.
    parameter tarVel.
    parameter maxAcc.

    return (vel - tarVel) * KP / maxAcc.
}
