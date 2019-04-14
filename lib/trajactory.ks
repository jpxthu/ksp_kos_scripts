function ImpactPositionKerbin {
    parameter k.
    parameter tarHeight.

    local upV to UP:Vector.
    local pos to Ship:Position.
    local vel to Ship:Velocity:Surface.
    local m to Ship:Mass * 1000.
    local e to Constant:E.

    local kr to Body:Radius.
    local kmu to Body:MU.
    local corePos to pos - upV * (Altitude + kr).

    until False {
        local posFromCore to pos - corePos.
        local hToR to posFromCore:Mag.
        local hToRSqrMag to posFromCore:SqrMagnitude.
        local posFromCoreDir to posFromCore / hToR.

        local h to hToR - kr.
        local leftH to h - tarHeight.
        if leftH < 0 {
            break.
        }

        local g to -kmu / hToRSqrMag * posFromCoreDir.
        local dens to 3.407 * e ^ (- ((h + 18250) / 17990) ^ 2).
        local velM to vel:Mag.
        local acc to g - vel * velM * dens / m * k.
        local dt to min(10, max(0.1, leftH / max(1, velM) / 2)).
        set vel to vel + acc * dt.
        set pos to pos + vel * dt.
    }

    return pos.
}
