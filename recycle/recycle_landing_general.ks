parameter vesselHeight.

local minHeight to vesselHeight + 5.

RunOncePath("/lib/control").
RunOncePath("/recycle/recycle_lib").

SAS OFF.
RCS OFF.

local tset to 0.
local sset to UP.

lock Throttle to tset.
lock Steering to sset.

until FALSE {
    local vel to Ship:Velocity:Surface.
    local fac to Ship:Facing:Vector.
    local upVec to UP:Vector.

    local velZ to -vel * upVec.

    local dist to Alt:Radar - minHeight.

    local avlThrust to Ship:AvailableThrustAt(Ship:Sensors:Pres * Constant:KPaToAtm).

    local gravity to Body:MU / (Altitude + Body:Radius) ^ 2.
    local maxAcc to fac * avlThrust / Ship:Mass.
    local maxAccZ to maxAcc * upVec - gravity.

    set tset to targetThrottle(velZ, dist, maxAccZ, gravity, minHeight).

    if velZ > 10 {
        local plaVec to -vel:Normalized.
        set sset to plaVec.
    } else {
        set sset to upVec.
    }

    if dist < 100 + minHeight {
        if Throttle < 0.01 {
            set stableCount to stableCount + 1.
            if stableCount > 100 {
                print "Landed.".
                break.
            }
        } else {
            set stableCount to 0.
        }
    }

    wait 0.01.
}

UnlockControl().
