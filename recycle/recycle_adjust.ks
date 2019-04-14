parameter landGeo.

RunOncePath("/lib/steering_manager").
RunOncePath("/recycle/recycle_lib").

SAS OFF.

print "Adjust predicted impact position.".
ResetSteeringManager().
Core:Messages:Clear().

local lastErr to 999999.
local began to False.
local lanPos to landGeo:Position.
local landOnSea to landGeo:TerrainHeight < 0.

local sset to Ship:Facing:Vector.
local tset to 0.

lock Steering to sset.
lock Throttle to tset.

RCS ON.

until FALSE {
    wait 0.01.
    // ClearVecDraws().

    local upVec to UP:Vector.
    if landOnSea {
        set lanPos to landGeo:AltitudePosition(0).
    } else {
        set lanPos to landGeo:Position.
    }

    // local tarPos to landGeo:Position + (landGeo:Position - landGeo:Position * UP:Vector * UP:Vector):Normalized * 50.
    local tarPos to lanPos + (Ship:Velocity:Surface - Ship:Velocity:Surface * UP:Vector * UP:Vector):Normalized * 50.
    // local tarVec to tarPos - Addons:Tr:ImpactPos:Position.
    local impPos to UpdateImpPos().
    if Addons:Tr:HasImpact {
        set impPos to Addons:Tr:ImpactPos:Position.
    }
    local impPosH to impPos / max(1, -impPos * upVec) * max(1, -tarPos * upVec).
    local tarVec to tarPos - impPosH.
    local tarDir to tarVec:Normalized.
    local tarErr to tarVec:Mag.

    set sset to tarDir.

    SetMaxStoppingTime(tarDir, 2, 5).
    local steerCM to tarDir * Ship:Facing:Vector.
    if steerCM > 0.95 {
        set tset to min(1, tarErr / 10000) * (steerCM - 0.95) * 20.
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
