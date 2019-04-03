set success to False.
set maxQ to 20000.

SAS OFF.
RCS OFF.

function tilt {
    parameter angle.
    lock Steering to Heading(90, 90 - angle).
}

// Launch
tilt(0).
lock Throttle to 1.
wait 2.

print "Lauch".
Stage.

function autoTilte {
    if Apoapsis > 70000 and Periapsis > 70000 {
        lock Steering to Prograde.
        lock Throttle to 0.
        set success to True.
        print "Into earth orbit.".
        return.
    }
    tilt(Apoapsis / 70000 * 90).
    if (Apoapsis < 68000) {
        lock Throttle to 1.
    } else {
        lock Throttle to min(1, max(0, (35 - Eta:Apoapsis) / 10)).
    }
}

function CalculateQ {
    local q is 0.5 * Ship:Sensors:Pres * 1000 / 287.053 / Ship:Sensors:Temp.
    if Altitude < 30000 {
        return q * (Ship:Velocity:Surface:Mag) ^ 2.
    } else {
        return q * (Ship:Velocity:Orbit:Mag) ^ 2.
    }
}

until Apoapsis > 70000 {
    // print Apoapsis + " " + Periapsis.

    tilt(Apoapsis / 70000 * 90).

    local q is CalculateQ();
    lock Throttle to min(1, max(0, (1.1 - q / maxQ) * 5)).

    wait 0.1.
}

until Apoapsis > 70000 and Periapsis > 70000 {
    // print Apoapsis + " " + Periapsis.
}

print "Success.".
unlock Steering.
unlock Throttle.
