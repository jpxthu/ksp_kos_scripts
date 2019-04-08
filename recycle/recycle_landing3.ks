parameter landGeo.
parameter vesselHeight.

RunOncePath("/recycle/recycle_lib").
RunOncePath("/lib/trajactory").

local impPos to Ship:Position.
function UpdateImpPos {
    local updated to False.
    local msg to 0.
    until Core:Messages:Empty {
        set msg to Core:Messages:Pop.
        set updated to True.
    }
    if updated {
        set impPos to msg:Content.
    }
}

SAS OFF.
RCS OFF.

local tset to 0.
local sset to UP.

lock Throttle to tset.
lock Steering to sset.

until Ship:Velocity:Surface * UP:Vector < -100 {
    set sset to -Ship:Velocity:Surface.
    wait 0.1.
}

if not Brakes { toggle Brakes. }
print "Open air brakes.".

local stableCount to 0.

local dt to 0.01.
local steeringTime to 2.

RCS ON.

until FALSE {
    local acc to Ship:Sensors:Acc.
    local vel to Ship:Velocity:Surface.
    local fac to Ship:Facing:Vector.
    local upVec to UP:Vector.

    local velH to vel - vel * upVec * upVec.
    local velZ to -vel * upVec.
    local dist to Altitude - landGeo:TerrainHeight.

    local avlThrust to Ship:AvailableThrustAt(Ship:Sensors:Pres * Constant:KPaToAtm).

    local gravity to Body:MU / (landGeo:TerrainHeight + Body:Radius) ^ 2.
    local maxAcc to fac * avlThrust / Ship:Mass.
    local maxAccZ to maxAcc * upVec - gravity.

    set tset to targetThrottle(velZ, dist, maxAccZ, gravity, vesselHeight).

    CLEARVECDRAWS().
    if velZ > 10 {
        // set impPos to Addons:Tr:ImpactPos:Position.
        UpdateImpPos().
        local lanPos to landGeo:Position.
        local tarPos to lanPos + velH * 0.1.

        local plaVec to -vel:Normalized.
        set sset to plaVec.

        local errPos to (tarPos - impPos) / min(10000, max(1000, dist - MIN_HEIGHT)) * 100.
        set Ship:Control:StarBoard to min(1, max(-1, errPos * Ship:Facing:StarVector)).
        // set Ship:Control:Fore      to 0.
        set Ship:Control:Top       to min(1, max(-1, errPos * Ship:Facing:TopVector)).

        VECDRAW(V(0, 0, 0), tarPos, RGB(1, 0, 0), "TAR", 1, TRUE).
        VECDRAW(V(0, 0, 0), impPos, RGB(0, 1, 0), "IMP", 1, TRUE).
        VECDRAW(V(0, 0, 0), tarDir * 50, RGB(0, 0, 1), "tarDir", 1, TRUE).
    } else {
        set Ship:Control:StarBoard to -vel * Ship:Facing:StarVector.
        // set Ship:Control:Fore      to 0.
        set Ship:Control:Top       to -vel * Ship:Facing:TopVector.
        set sset to upVec.
    }

    if dist < 100 + MIN_HEIGHT {
        if not Gear {
            toggle Gear.
        }
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

    wait dt.
}

set tset to 0.
wait 0.1.
unlock Throttle.
unlock Steering.
RCS OFF.

if Brakes { toggle Brakes. }
CLEARVECDRAWS().
