parameter landGeo.
parameter vesselHeight.

local minHeight to vesselHeight + 5.

RunOncePath("/recycle/recycle_lib").

SAS OFF.
RCS OFF.

local tset to 0.
local sset to UP.

lock Throttle to tset.
lock Steering to sset.

until Ship:Velocity:Surface * UP:Vector < -100 and Altitude < 40000 {
    set sset to -Ship:Velocity:Surface.
    wait 0.1.
}

if not Brakes { toggle Brakes. }
print "Open air brakes.".
Core:Messages:Clear().

local stableCount to 0.

local dt to 0.01.
local lanPos to landGeo:Position.
local landHeight to landGeo:TerrainHeight.
local landOnSea to landHeight < 0.

RCS ON.

until FALSE {
    local acc to Ship:Sensors:Acc.
    local vel to Ship:Velocity:Surface.
    local fac to Ship:Facing:Vector.
    local upVec to UP:Vector.

    local velH to vel - vel * upVec * upVec.
    local velZ to -vel * upVec.

    if landOnSea {
        set landHeight to 0.
        set lanPos to landGeo:AltitudePosition(0).
    } else {
        set landHeight to landGeo:TerrainHeight.
        set lanPos to landGeo:Position.
    }

    local dist to Altitude - landHeight.

    local avlThrust to Ship:AvailableThrustAt(Ship:Sensors:Pres * Constant:KPaToAtm).

    local gravity to Body:MU / (landHeight + Body:Radius) ^ 2.
    local maxAcc to fac * avlThrust / Ship:Mass.
    local maxAccZ to maxAcc * upVec - gravity.

    set tset to targetThrottle(velZ, dist, maxAccZ, gravity, minHeight).

    // ClearVecDraws().
    if velZ > 10 {
        // set impPos to Addons:Tr:ImpactPos:Position.
        local impPos to UpdateImpPos().
        // if Addons:Tr:HasImpact {
        //     set impPos to Addons:Tr:ImpactPos:Position.
        // }
        // local tarPos to lanPos + min(velH * 0.05.
        local bodyTailPos to -vesselHeight * fac.
        local tarPos to lanPos + velH * 0.1 + (bodyTailPos - bodyTailPos * upVec * upVec).

        local plaVec to -vel:Normalized.
        set sset to plaVec.

        local errPos to (tarPos - impPos) / min(10000, max(1000, dist - minHeight)) * 100.
        set Ship:Control:StarBoard to min(1, max(-1, errPos * Ship:Facing:StarVector)).
        // set Ship:Control:Fore      to 0.
        set Ship:Control:Top       to min(1, max(-1, errPos * Ship:Facing:TopVector)).

        // VecDraw(V(0, 0, 0), tarPos, RGB(1, 0, 0), "TAR", 1, True).
        // VecDraw(V(0, 0, 0), impPos, RGB(0, 1, 0), "IMP", 1, True).
        // VecDraw(V(0, 0, 0), sset * 50, RGB(0, 0, 1), "tarDir", 1, True).
    } else {
        set Ship:Control:StarBoard to -vel * Ship:Facing:StarVector.
        // set Ship:Control:Fore      to 0.
        set Ship:Control:Top       to -vel * Ship:Facing:TopVector.
        set sset to upVec.
    }

    if dist < 100 + minHeight {
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
// ClearVecDraws().
