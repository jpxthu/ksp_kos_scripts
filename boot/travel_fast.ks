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
stage.
lock THROTTLE to 0.5.
wait 0.1.
lock THROTTLE to 0.0.
wait 1.9.
lock THROTTLE to 0.5.

until APOAPSIS > 80000 {
    tilt(ALTITUDE / 1000).
    wait 1.0.
}.
lock THROTTLE to 0.0.

tilt(90).
wait until ETA:APOAPSIS < 30.
lock THROTTLE to 0.1.
wait 5.
lock THROTTLE to 1.0.

wait until PERIAPSIS > 75000.
lock THROTTLE to 0.0.
wait 2.
toggle LIGHTS.

// until ETA:APOAPSIS < 20 {
//     lock STEERING to RETROGRADE.
//     wait 1.0.
// }.
lock STEERING to RETROGRADE.
lock THROTTLE to 0.1.
wait 20.
lock THROTTLE to 1.0.
// until PERIAPSIS < 40000 {
//     lock STEERING to RETROGRADE.
//     wait 1.0.
// }.
// lock THROTTLE to 0.0.

// until ALTITUDE < 60000 {
//     lock STEERING to RETROGRADE.
//     wait 1.0.
// }.
// lock THROTTLE to 1.0.
until STAGE:LIQUIDFUEL < 1 {
    lock STEERING to RETROGRADE.
    wait 1.0.
}.
wait 2.0.
stage.

wait until ALTITUDE < 10000.
until ALTITUDE < 1000 {
    CHUTESSAFE ON.
    wait 1.0.
}.
