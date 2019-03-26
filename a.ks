set n to 0.
until n > 1000 {
    local pres is n / 1000.
    log pres + " " + Ship:AvailableThrustAt(pres) to "thrust.log".
    set n to n + 1.
}

// lock Steering to UP.
lock Throttle to 1.
stage.

until false {
    log Ship:Sensors:Pres + " " + Altitude + " " + Ship:Velocity:Surface:X + " " + Ship:Velocity:Surface:Y + " " + Ship:Velocity:Surface:Z + " " + Ship:Velocity:Orbit:X + " " + Ship:Velocity:Orbit:Y + " " + Ship:Velocity:Orbit:Z + " " + UP:Vector:X + " " + UP:Vector:Y + " " + UP:Vector:Z + " " + Ship:Sensors:Acc:X + " " + Ship:Sensors:Acc:Y + " " + Ship:Sensors:Acc:Z + " " + Body:MU + " " + Body:Radius + " " + Ship:Mass + " " + Ship:Facing:Vector:X + " " + Ship:Facing:Vector:Y + " " + Ship:Facing:Vector:Z to "3.log".
    wait 0.01.
}
