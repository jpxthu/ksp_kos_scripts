parameter landGeo.// is LatLng(-0.0972079934541428, -74.5576762507677).

run once steering_manager.
run once trajactory.

set impPos to Ship:Position.
function UpdateImpPos {
    local sth is False.
    until Core:Messages:Empty {
        set msg to Core:Messages:Pop.
        set sth to True.
    }
    if sth {
        set impPos to msg:Content.
    }
}

SAS OFF.

print "Adjust predicted impact position.".
ResetSteeringManager().

// set lastErr to (landGeo:Position - Addons:Tr:ImpactPos:Position):Mag.
UpdateImpPos().
set lastErr to 999999.
set count to 0.
set began to False.

set sset to Ship:Facing:Vector.
set tset to 0.

lock Steering to sset.
lock Throttle to tset.

RCS ON.

until FALSE {
    wait 0.01.
    CLEARVECDRAWS().

    local upVec is UP:Vector.

    // local tarPos is landGeo:Position + (landGeo:Position - landGeo:Position * UP:Vector * UP:Vector):Normalized * 100.
    local tarPos is landGeo:Position + (Ship:Velocity:Surface - Ship:Velocity:Surface * UP:Vector * UP:Vector):Normalized * 100.
    // local tarVec is tarPos - Addons:Tr:ImpactPos:Position.
    UpdateImpPos().
    local impPosH is impPos / max(1, -impPos * upVec) * max(1, -tarPos * upVec).
    local tarVec is tarPos - impPosH.
    local tarDir is tarVec:Normalized.
    local tarErr is tarVec:Mag.

    set sset to tarDir.

    SetMaxStoppingTime(tarDir, 2, 4).
    local steerCM is tarDir * Ship:Facing:Vector.
    if steerCM > 0.99 {
        set tset to min(1, tarErr / 10000) * (steerCM - 0.99) * 100.
        set began to true.
    } else {
        set tset to 0.
    }

    // print tarErr.
    // VECDRAW(V(0, 0, 0), tarDir * 50, RGB(1, 0, 0), "TAR", 1, TRUE).
    // VECDRAW(V(0, 0, 0), Ship:Facing:Vector * 50, RGB(0, 1, 0), "Fac", 1, TRUE).

    if began {
        if tarErr >= lastErr and tarErr < 1000 {
            break.
        }
    }

    set lastErr to tarErr .
}

unlock Throttle.
unlock Steering.
ResetSteeringManager().
print "Predicted impact position adjust finished.".
