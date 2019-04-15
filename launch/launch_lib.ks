function CalculateQ {
    local q is 0.5 * Ship:Sensors:Pres * 1000 / 287.053 / Ship:Sensors:Temp.
    if Altitude < 30000 {
        return q * (Ship:Velocity:Surface:Mag) ^ 2.
    } else {
        return q * (Ship:Velocity:Orbit:Mag) ^ 2.
    }
}
