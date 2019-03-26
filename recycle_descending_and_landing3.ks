run recycle_descending_and_landing_lib.ks.

set landGeo to LatLng(-0.0972079934541428, -74.5576762507677). //Ship:GeoPosition.

until Ship:Velocity:Surface * UP:Vector < -100 {
    lock Steering to UP.
    wait 0.1.
}

SAS OFF.
RCS OFF.

if not Brakes { toggle Brakes. }
if not Lights { toggle Lights. }
print "Open air brakes.".

set stableCount to 0.

set trAvailable to Addons:Tr:Available.

set count to 0.
set extAcc to V(0, 0, 0).

set dt to 0.01.
set steeringTime to 2.

if not RCS { RCS ON. }

until FALSE {
    set acc to Ship:Sensors:Acc.
    set vel to Ship:Velocity:Surface.
    set fac to Ship:Facing:Vector.
    set upVec to UP:Vector.

    set velH to vel - vel * upVec * upVec.
    set velZ to -vel * upVec.
    set dist to Altitude - landGeo:TerrainHeight.

    set avlThrust to Ship:AvailableThrustAt(Ship:Sensors:Pres * Constant:KPaToAtm).

    set extAcc to extAcc + (acc - fac * avlThrust * Throttle - extAcc) * 0.01.

    set gravity to Body:MU / (landGeo:TerrainHeight + Body:Radius) ^ 2.
    set maxAcc to fac * avlThrust / Ship:Mass.// - extAcc.
    set maxAccZ to maxAcc * upVec - gravity.

    // log Ship:Sensors:Pres + " " + avlThrust + " " + Throttle + " " + Ship:Mass + " " + acc:X + " " + acc:Y + " " + acc:Z + " " + gravity + " " + vel:X + " " + vel:Y + " " + vel:Z + " " + fac:X + " " + fac:Y + " " + fac:Z + " " + upVec:X + " " + upVec:Y + " " + upVec:Z to "2.log".

    set tarThrottle to targetThrottle(velZ, dist, maxAccZ, gravity).

    CLEARVECDRAWS().
    set tarDir to V(0, 0, 0).
    if velZ > 10 {
        set impPos to Addons:Tr:ImpactPos:Position.
        set lanPos to landGeo:Position.
        set tarPos to lanPos + velH * 0.8.

        print velH:Mag.

        set plaVec to -vel:Normalized.
        set tarDir to plaVec.

        set errPos to (tarPos - impPos) / min(10000, max(1000, dist - MIN_HEIGHT)) * 100.
        set Ship:Control:StarBoard to min(1, max(-1, errPos * Ship:Facing:StarVector)).
        // set Ship:Control:Fore      to 0.
        set Ship:Control:Top       to min(1, max(-1, errPos * Ship:Facing:TopVector)).

        VECDRAW(V(0, 0, 0), tarPos, RGB(1, 0, 0), "TAR", 1, TRUE).
        VECDRAW(V(0, 0, 0), impPos, RGB(0, 1, 0), "IMP", 1, TRUE).
        VECDRAW(V(0, 0, 0), lanPos, RGB(0, 0, 1), "LAN", 1, TRUE).
    } else {
        set Ship:Control:StarBoard to -vel * Ship:Facing:StarVector.
        // set Ship:Control:Fore      to 0.
        set Ship:Control:Top       to -vel * Ship:Facing:TopVector.
        // set velH to (vel + velZ * upVec) * 0.1.
        // set velHM to velH:Mag.
        // if velHM > 0.1 {
        //     set velH to velH / velHM * 0.1.
        // }
        // set tarDir to upVec - velH.
        set tarDir to upVec.
    }

    // set steeringError to tarDir * fac.
    // if steeringError < 0.995 { set tarThrottle to max(0.1, tarThrottle). }

    lock Steering to tarDir.
    lock Throttle to tarThrottle.

    // VECDRAW(V(0, 0, 0), tarDir * 20, RGB(1, 0, 1), "STE", 1, TRUE).

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

    if dist < 70000 {
        if velZ < 1200 {
            if not Lights { toggle Lights. }
        }
        // if velZ < 50 {
        //     if Brakes { toggle Brakes. }
        // } else {
        //     if not Brakes { toggle Brakes. }
        // }
        // if steeringError < 0.9995 or velZ < 50 {
        //    if not RCS { RCS ON. }
        // } else {
        //     if RCS { RCS OFF. }
        // }
    }

    wait dt.
}

wait 0.01.
lock Throttle to 0.
lock Steering to UP.
wait 0.01.
unlock Throttle.
unlock Steering.

if Brakes { toggle Brakes. }
if Lights { toggle Lights. }
if RCS { RCS OFF. }
CLEARVECDRAWS().
