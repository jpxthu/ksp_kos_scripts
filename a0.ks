parameter tarHeight.

run launch.lib.ks.

SAS OFF.
RCS OFF.

set tset to 0.
set sset to UP.

lock Throttle to tset.
lock Steering to sset.

until Apoapsis > tarHeight {
    set sset to AngleToHeading(Apoapsis / tarHeight * 90).

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
    
    set sset to AngleToHeading(Apoapsis / tarHeight * 90).
    set tset to max(0, min(1, (tarHeight - Apoapsis) / 20)).

    if ETA:Apoapsis < burnTime / 2 + 2 {
        set n to Node(Time:Seconds + ETA:Apoapsis, 0, 0, dvTar).
        add n.
        set sset to n:deltaV.
        remove n.
        break.
    }

    wait dt.
    print "1 " + Apoapsis + " " + Periapsis.
}

until Periapsis + Apoapsis > tarHeight * 2 {
    set tset to 1.

    wait dt.
    print "2 " + Apoapsis + " " + Periapsis.
}

// until false {
//     local vecV is Ship:Velocity:Orbit:Normalized.
//     local vecVH is (vecV - vecV * UP:Vector * UP:Vector):Normalized.
//     local velTar is sqrt(Body:MU / (tarHeight + Body:Radius)) * vecVH.
//     local velErr is velTar - Ship:Velocity:Orbit.
//     local accTar is velErr * 0.5.
    
//     set sset to accTar:Normalized.
//     if Ship:Facing:Vector * sset > 0.999 {
//         local maxAcc is Ship:AvailableThrustAt(Ship:Sensors:Pres * Constant:KPaToAtm) / Ship:Mass.
//         set tset to accTar:Mag / maxAcc.
//     } else {
//         set tset to 0.
//     }

//     if velErr:Mag < 0.1 {
//         break.
//     }

//     wait dt.
//     print "3 " + Apoapsis + " " + Periapsis.
// }

set tset to 0.
print Apoapsis + " " + Periapsis.

print "Success.".
unlock Steering.
unlock Throttle.
