// set VESSEL_HEIGHT to 30.
local MIN_HEIGHT to 10.
local MIN_VELOCITY to 4.
local KP to 4.

function TargetVelocity {
    parameter dist_.
    parameter maxAcc_.
    parameter vesselHeight_.

    return max(MIN_VELOCITY, sqrt(max(0, (dist_ - minHeight_ - MIN_HEIGHT) * maxAcc_ * 2)) * 0.9).
}

function TargetThrottle {
    parameter vel_.
    parameter dist_.
    parameter maxAcc_.
    parameter gravity_.
    parameter vesselHeight_.

    local tarVel to TargetVelocity(dist_, maxAcc_, vesselHeight_).

    local dt to 0.1.
    local tarVel2 to TargetVelocity(dist_ - vel_ * dt, maxAcc_, vesselHeight_).
    local tarAcc to (tarVel - tarVel2) / dt.

    return min(1, max(0, ((vel_ - tarVel) * KP + tarAcc + gravity_) / maxAcc_)).
}

function PredictThrottle {
    parameter dist_.
    parameter vel_.
    parameter maxAcc_.
    parameter gravity_.
    parameter vesselHeight_.

    local dt to 0.1.
    local tarVel to TargetVelocity(dist_ - vel_ * dt, maxAcc_, vesselHeight_).
    local tarAcc to (vel_ - tarVel) / dt.

    return min(1, max(0, (tarAcc - extAcc * UP:Vector) / maxAcc_)).
}

// (c * pres * v ^ 2 - avlThrust * Throttle / mass) * sin(a) = acc

// set liftRatio to 0.00002.
// function LiftPerAngle {
//     parameter acc_.
//     parameter vel_.
//     parameter fac_.
//     parameter pres_.
//     parameter thrustAcc_.

//     local accS to (acc_ - acc_ * fac_ * fac_):Mag.
//     local velM to vel_:Mag.
//     local velV to vel_:Normalized.
//     local sinTheta to sqrt(max(0, 1 - (fac_ * velV) ^ 2)).

//     local tmp to pres_ * velM ^ 2.
//     local tmp2 to tmp * sinTheta.

//     if accS > 1 and pres_ > 0.01 and velM > 100 and sinTheta > 0.2 {
//         local c to accS / (tmp * sinTheta).
//         set liftRatio to liftRatio + (c - liftRatio) * max(0, 0.1 - Throttle) * 0.5.
//     }

//     local tmp3 to liftRatio * tmp - thrustAcc_.

//     print liftRatio + " " + tmp3 + " " + thrustAcc_.
//     return tmp3.
// }
