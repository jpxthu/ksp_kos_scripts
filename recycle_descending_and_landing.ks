run recycle_descending_and_landing_lib.ks.

set landGeo to LatLng(-0.0972079934541428, -74.5576762507677). //Ship:GeoPosition.

until Ship:Velocity:Surface * UP:Vector < -100 {
    set Steering to UP.
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
set ratioDir to 1.

until FALSE {
    set acc to Ship:Sensors:Acc.
    set vel to Ship:Velocity:Surface.
    set fac to Ship:Facing:Vector.
    set upVec to UP:Vector.
    
    set velZ to -vel * upVec.
    set dist to Altitude - landGeo:TerrainHeight.

    set avlThrust to Ship:AvailableThrustAt(Ship:Sensors:Pres * Constant:KPaToAtm).

    set extAcc to extAcc + (acc - fac * avlThrust * Throttle - extAcc) * 0.01.

    set gravity to Body:MU / (landGeo:TerrainHeight + Body:Radius) ^ 2.
    set maxAcc to fac * avlThrust / Ship:Mass.// - extAcc.
    set maxAccZ to maxAcc * upVec - gravity.

    log Ship:Sensors:Pres + " " + avlThrust + " " + Throttle + " " + Ship:Mass + " " + acc:X + " " + acc:Y + " " + acc:Z + " " + gravity + " " + vel:X + " " + vel:Y + " " + vel:Z + " " + fac:X + " " + fac:Y + " " + fac:Z + " " + upVec:X + " " + upVec:Y + " " + upVec:Z to "2.log".
    
    set tarThrottle to targetThrottle(velZ, dist, maxAccZ).

    // print maxAccZ + " " + dist + " " + tarV.

    // if dist > 5000 {
    //     set tarThrottle1 to 0.
    // } else {
        set tarThrottle1 to tarThrottle.
    // }
    set tarThrottle2 to min(1, max(0, tarThrottle1)).
    
    CLEARVECDRAWS().
    set tarDir to V(0, 0, 0).
    if velZ > 50 {
        set impPos to Addons:Tr:ImpactPos:Position.
        set lanPos to landGeo:Position.

        set errPos to lanPos - upVec * (lanPos * upVec).
        set errPosMag to errPos:Mag.
        if errPosMag > 0.01 {
            set errPos to errPos:Normalized * min(10, max(0, (dist - MIN_HEIGHT) / 10)).
        }
        set tarPos to lanPos + errPos * max(0, ratioDir).
        // set tarPos to lanPos + errPos * ratioDir.

        set plaVec to -vel:Normalized.
        
        set rotateVec to VCRS(impPos:Normalized, tarPos:Normalized).
        set rotateMag to rotateVec:Mag.
        set rotateDir to V(0, 0, 0).
        if rotateMag < 0.0001 {
            set rotateMag to 0.
        } else {
            set rotateDir to rotateVec / rotateMag.
        }
        set ratioDir to min(1, max(-1, 1 - Throttle * 100000 / velZ ^ 2)).
        if ratioDir > 0 {
            set rotateMag to rotateMag * max(5, sqrt(dist) / 2).
            if rotateMag > 0.4 {
                set rotateMag to 0.4.
            }
        } else {
            set rotateMag to rotateMag * 2.
            if rotateMag > 0.15 {
                set rotateMag to 0.15.
            }
        }
        set rotateMag to rotateMag * ratioDir.
        set tarDir to VCRS(rotateDir, plaVec) * rotateMag + plaVec * sqrt(1 - rotateMag * rotateMag).
        set ratio to min(1, max(0, (velZ - 10) / 20)).
        set tarDir to tarDir * ratio + plaVec * (1 - ratio).

        VECDRAW(V(0, 0, 0), tarPos, RGB(1, 0, 0), "TAR", 1, TRUE).
        VECDRAW(V(0, 0, 0), impPos, RGB(0, 1, 0), "IMP", 1, TRUE).
        VECDRAW(V(0, 0, 0), lanPos, RGB(0, 0, 1), "LAN", 1, TRUE).
    // } else if velZ > 4 {
        // set tarDir to -vel:Normalized.
    } else {
        set velH to (vel + velZ * upVec) * 0.1.
        set velHM to velH:Mag.
        if velHM > 0.1 {
            set velH to velH / velHM * 0.1.
        }
        set tarDir to upVec - velH.
        // set tarDir to upVec.
    }

    set steeringError to tarDir * fac.
    // if steeringError < 0.995 { set tarThrottle2 to max(0.1, tarThrottle2). }

    set Steering to tarDir.
    set Throttle to tarThrottle2.
    
    VECDRAW(V(0, 0, 0), tarDir * 20, RGB(1, 0, 1), "STE", 1, TRUE).

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
        if steeringError < 0.9995 or velZ < 50 {
            if not RCS { RCS ON. }
        } else {
            if RCS { RCS OFF. }
        }
    }

    wait 0.01.
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
