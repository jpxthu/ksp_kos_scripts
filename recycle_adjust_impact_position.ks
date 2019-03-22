set landGeo to LatLng(-0.0972079934541428, -74.5576762507677). //Ship:GeoPosition.

run steering.ks.

SAS OFF.
RCS OFF.

lock Steering to UP.
lock Throttle to 1.
Stage.
// wait 1.
if Gear { toggle Gear. }

until Apoapsis > 120000 {
    lock Steering to heading(90, 90 + Altitude / 2000).
    lock Throttle to 1.
    wait 0.1.
}
lock Throttle to 0.
print "Apapsis to 120000. Shutdown engines.".

until Ship:Sensors:Pres < 0.0001 {
    lock Steering to heading(90, 90 + Altitude / 2000).
    wait 0.1.
}
wait 1.
print "Out of atmosphere. Adjust predicted impact position.".

set lastErr to (landGeo:Position - Addons:Tr:ImpactPos:Position):Mag.
set count to 0.
set began to False.

RCS ON.

until FALSE {
    wait 0.01.

    local tarVec is landGeo:Position - Addons:Tr:ImpactPos:Position.
    local tarDir is tarVec:Normalized.
    local tarErr is tarVec:Mag.

    lock Steering to tarDir.
    SetMaxStoppingTime(tarDir, 2, 4).
    if tarDir * Ship:Facing:Vector > 0.999 {
        lock Throttle to min(1, tarErr / 1000).
        set began to true.
    } else {
        lock Throttle to 0.
    }

    // print tarErr.

    if began {
        if tarErr >= lastErr and tarErr < 100 {
            break.
        }
        //     set count to count + 1.
        //     if count > 10 {
        //         break.
        //     }
        // } else {
        //     set count to 0.
        // }
    }

    set lastErr to tarErr .
}

lock Throttle to 0.
lock Steering to UP.
print "Predicted impact position adjust finished.".

run recycle_descending_and_landing.ks.
