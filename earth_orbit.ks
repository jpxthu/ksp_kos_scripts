// Launch
lock THROTTLE to 0.0.
lock STEERING to HEADING(90, 90).
wait 2.

print "Lauch".
stage.

function tilt {
    parameter angle.
    lock STEERING to HEADING(90, 90 - angle).
}

until STAGE:SOLIDFUEL < 1 {
    tilt(ALTITUDE / 1000).
    wait 1.0.
}.
wait 1.0.
stage.
lock THROTTLE to 1.0.
wait 0.1.
lock THROTTLE to 0.0.
wait 1.9.
lock THROTTLE to 1.0.

until APOAPSIS > 80000 {
    tilt(ALTITUDE / 1000).
    wait 1.0.
}.

until PERIAPSIS > 70000 {
    lock STEERING to PROGRADE.
    if STAGE:LIQUIDFUEL < 1 {
        stage.
    }.
    wait 1.0.
}.
lock THROTTLE to 0.0.
toggle LIGHTS.
