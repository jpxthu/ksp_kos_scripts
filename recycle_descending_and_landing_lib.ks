set MIN_HEIGHT to 50.
// set MIN_HEIGHT to 15.
set MIN_VELOCITY to 4.
set KP TO 10.

function targetVelocity {
    parameter dist_.
    parameter maxAcc_.

    return max(MIN_VELOCITY, sqrt(max(0, (dist_ - MIN_HEIGHT) * maxAcc_ * 2)) * 0.9).
}

function targetThrottle {
    parameter vel_.
    parameter dist_.
    parameter maxAcc_.
    parameter gravity_.

    local tarVel is targetVelocity(dist_, maxAcc_).

    local dt is 0.1.
    local tarVel2 is targetVelocity(dist_ - vel_ * dt, maxAcc_).
    local tarAcc is (tarVel - tarVel2) / dt.

    return min(1, max(0, ((vel_ - tarVel) * KP + tarAcc + gravity_) / maxAcc_)).
}

function predictThrottle {
    parameter dist_.
    parameter vel_.
    parameter maxAcc_.
    parameter gravity_.

    // local tarVel is targetVelocity(dist_, maxAcc_).

    local dt is 0.1.
    local tarVel2 is targetVelocity(dist_ - vel_ * dt, maxAcc_).
    local tarAcc is (vel_ - tarVel2) / dt.

    return min(1, max(0, (tarAcc - extAcc * UP:Vector) / maxAcc_)).
}

// (c * pres * v ^ 2 - avlThrust * Throttle / mass) * sin(a) = acc

set liftRatio to 0.000006.
function liftPerAngle {
    parameter acc_.
    parameter vel_.
    parameter fac_.
    parameter pres_.
    parameter thrustAcc_.

    local accS is (acc_ - acc_ * fac_ * fac_):Mag.
    local velM is vel_:Mag.
    local velV is vel_:Normalized.
    local sinTheta is sqrt(max(0, 1 - (fac_ * velV) ^ 2)).

    local tmp is pres_ * velM ^ 2.
    local tmp2 is tmp * sinTheta.

    if accS > 1 and tmp2 > 1 {
        local c is accS / (tmp * sinTheta).
        set liftRatio to liftRatio + (c - liftRatio) * max(0, 0.1 - Throttle) * 0.5.
    }

    local tmp3 is liftRatio * tmp - thrustAcc_.

    // print liftRatio + " " + tmp3.
    return tmp3.
}