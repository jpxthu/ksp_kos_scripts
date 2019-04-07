run once atmosphere.

function ImpactPosition {
    parameter k.
    parameter terrainHeight.

    local pos is Ship:Position.
    local vel is Ship:Velocity:Surface.
    local upV is UP:Vector.
    local m is Ship:Mass * 1000.

    local dt is 1.

    until False {
        local h is Altitude + pos * upV.
        if h < terrainHeight {
            break.
        }
        local g is Body:MU / (h + Body:Radius) ^ 2.
        local dens is KerbinDensity(h).
        local acc is -g * upV - vel * vel:Mag * dens / m * k.
        set vel to vel + acc * dt.
        set pos to pos + vel * dt.
    }

    return pos.
}
