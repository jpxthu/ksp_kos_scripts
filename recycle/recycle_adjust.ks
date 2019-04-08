parameter landGeo.

RunOncePath("/lib/steering_manager").
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

print "Adjust predicted impact position.".
ResetSteeringManager().

UpdateImpPos().
local lastErr to 999999.
local began to False.

local sset to Ship:Facing:Vector.
local tset to 0.

lock Steering to sset.
lock Throttle to tset.

RCS ON.

until FALSE {
    wait 0.01.
    CLEARVECDRAWS().

    local upVec to UP:Vector.

    // local tarPos to landGeo:Position + (landGeo:Position - landGeo:Position * UP:Vector * UP:Vector):Normalized * 100.
    local tarPos to landGeo:Position + (Ship:Velocity:Surface - Ship:Velocity:Surface * UP:Vector * UP:Vector):Normalized * 100.
    // local tarVec to tarPos - Addons:Tr:ImpactPos:Position.
    UpdateImpPos().
    local impPosH to impPos / max(1, -impPos * upVec) * max(1, -tarPos * upVec).
    local tarVec to tarPos - impPosH.
    local tarDir to tarVec:Normalized.
    local tarErr to tarVec:Mag.

    set sset to tarDir.

    SetMaxStoppingTime(tarDir, 2, 4).
    local steerCM to tarDir * Ship:Facing:Vector.
    if steerCM > 0.99 {
        set tset to min(1, tarErr / 10000) * (steerCM - 0.99) * 100.
        set began to true.
    } else {
        set tset to 0.
    }

    if began {
        if tarErr >= lastErr and tarErr < 1000 {
            break.
        }
    }

    set lastErr to tarErr .
}

set tset to 0.
wait 0.1.
unlock Throttle.
unlock Steering.
RCS OFF.

ResetSteeringManager().
print "Predicted impact position adjust finished.".
