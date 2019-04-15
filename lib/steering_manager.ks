function SetMaxStoppingTime {
    parameter tarVec.
    parameter minV.
    parameter maxV.

    local crossProduct to Ship:Facing:Vector * tarVec.
    set SteeringManager:MaxStoppingTime to min(maxV, (max(0, 1 - crossProduct ^ 2)) ^ 0.5 * (maxV - minV) + minV).
}

function ResetSteeringManager {
    SteeringManager:ResetToDefault().
}
