function ImpactPosition {
    parameter k.
    parameter terrainHeight.

    local pos is Ship:Position.
    local vel is Ship:Velocity:Surface.
    local upV is UP:Vector.
    local m is Ship:Mass * 1000.
    local e is Constant:E.

    until False {
        local z is -pos * upV.
        local h is Altitude - z.
        local leftH is terrainHeight - z.
        if leftH < 0 {
            break.
        }
        local g is Body:MU / (h + Body:Radius) ^ 2.
        local dens is 3.407 * e ^ (- ((h + 18250) / 17990) ^ 2).
        local velM is vel:Mag.
        local acc is -g * upV - vel * velM * dens / m * k.
        local dt is min(10, max(0.1, leftH / max(1, velM)) / 2).
        set vel to vel + acc * dt.
        set pos to pos + vel * dt.
    }

    return pos.
}
