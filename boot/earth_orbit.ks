// Launch
LOCK THROTTLE TO 1.
LOCK STEERING TO HEADING(90, 90).
WAIT 2.

PRINT "Lauch".
STAGE.

FUNCTION tilt {
    PARAMETER angle.
    LOCK STEERING TO HEADING(90, 90 - angle).
}

IF STAGE:SOLIDFUEL > 0 {
    LOCK THROTTLE TO 0.
    UNTIL STAGE:SOLIDFUEL < 1 {
        WAIT 1.
        tilt(ALTITUDE / 1000).
    }.
} ELSE {
    SET lastFuel TO STAGE:LIQUIDFUEL.
    SET lastFuelCost TO 0.
    SET detach TO FALSE.
    UNTIL detach {
        WAIT 1.0.
        tilt(ALTITUDE / 1000).
        set fuelCost TO STAGE:LIQUIDFUEL - lastFuel.
        SET detach TO fuelCost * 2 < lastFuelCost.
        SET lastFuel TO STAGE:LIQUIDFUEL.
        SET lastFuelCost TO fuelCost.
    }.
}.

WAIT 1.
PRINT "Detach secondary tanks.".
STAGE.
LOCK THROTTLE TO 1.0.
WAIT 0.1.
LOCK THROTTLE TO 0.0.
WAIT 1.9.
LOCK THROTTLE TO 1.0.

UNTIL APOAPSIS > 80000 {
    tilt(ALTITUDE / 1000).
    WAIT 1.0.
}.

UNTIL PERIAPSIS > 70000 {
    // LOCK STEERING TO PROGRADE.
    tilt(90).
    IF STAGE:LIQUIDFUEL < 1 {
        PRINT "Detach main tank.".
        STAGE.
    }.
    WAIT 1.
}.
LOCK THROTTLE TO 0.
TOGGLE LIGHTS.
PRINT "Into earth orbit.".
