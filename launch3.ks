set success to False.
set maxQ to 15000.
set tarHeight to 70000.
set dt to 0.1.

SAS OFF.
RCS OFF.

set tset to 0.
set sset to UP.

// Launch
lock Throttle to tset.
lock Steering to sset.

function tilt {
    parameter angle.
    set sset to Heading(90, 90 - angle).
}

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

until Apoapsis > tarHeight {
    tilt(Apoapsis / tarHeight * 90).

    local q is CalculateQ().
    set tset to min(1, max(0, (1.1 - q / maxQ) * 5)).

    wait dt.
    print "0 " + Apoapsis + " " + Periapsis.
}

until false {
    local velApoapsis is Ship:Velocity:Orbit:Mag * (Altitude + Body:Radius) / (Apoapsis + Body:Radius).
    local velApoapsisTar is sqrt(Body:MU / (Apoapsis + Body:Radius)).
    local dvTar is velApoapsisTar - velApoapsis.

    local maxAcc is Ship:AvailableThrustAt(Ship:Sensors:Pres * Constant:KPaToAtm) / Ship:Mass.
    local burnTime is dvTar / maxAcc.
    
    tilt(Apoapsis / tarHeight * 90).
    set tset to max(0, min(1, (tarHeight - Apoapsis) / 20)).
    print "1 " + Apoapsis + " " + Periapsis.

    if ETA:Apoapsis < burnTime / 2 + 2 {
        set n to Node(Time:Seconds + ETA:Apoapsis, 0, 0, dvTar).
        add n.
        set sset to n:deltaV.
        remove n.
        break.
    }

    wait dt.
}

until Periapsis + Apoapsis > tarHeight * 2 {
    // local velApoapsis is Ship:Velocity:Orbit:Mag * (Altitude + Body:Radius) / (Apoapsis + Body:Radius).
    // local velApoapsisTar is sqrt(Body:MU / (Apoapsis + Body:Radius)).
    // local dvTar is velApoapsisTar - velApoapsis.
    
    // local maxAcc is Ship:AvailableThrustAt(Ship:Sensors:Pres * Constant:KPaToAtm) / Ship:Mass.
    // local burnTime is dvTar / maxAcc.

    set tset to 1.//max(0.1, min(1, burnTime / dt)).
    print "2 " + Apoapsis + " " + Periapsis.

    wait dt.
}

RCS ON.
until false {
    local vecV is Ship:Velocity:Orbit:Normalized.
    local vecVH is (vecV - vecV * UP:Vector * UP:Vector):Normalized.
    local velTar is sqrt(Body:MU / (tarHeight + Body:Radius)) * vecVH.
    local velErr is velTar - Ship:Velocity:Orbit.
    local accTar is velErr * 0.5.
    
    set sset to accTar:Normalized.
    if Ship:Facing:Vector * sset > 0.999 {
        local maxAcc is Ship:AvailableThrustAt(Ship:Sensors:Pres * Constant:KPaToAtm) / Ship:Mass.
        set tset to accTar:Mag / maxAcc.
    } else {
        set tset to 0.
    }

    if velErr:Mag < 0.1 {
        break.
    }

    wait dt.
    print "3 " + Apoapsis + " " + Periapsis.
}

set tset to 0.
print "2 " + Apoapsis + " " + Periapsis.

print "Success.".
unlock Steering.
unlock Throttle.
