SET success TO FALSE.

FUNCTION tilt {
    PARAMETER angle.
    LOCK STEERING TO HEADING(90, 90 - angle).
}

// Launch
tilt(0).
LOCK THROTTLE TO 1.
WAIT 2.

PRINT "Lauch".
STAGE.

FUNCTION autoTile {
    IF PERIAPSIS > 70000 {
        LOCK STEERING TO PROGRADE.
        LOCK THROTTLE TO 0.
        SET success TO TRUE.
        PRINT "Into earth orbit.".
        RETURN.
    }
    IF APOAPSIS > 80000 {
        IF ETA:APOAPSIS < 30 OR ETA:APOAPSIS > 300 {
            LOCK THROTTLE TO 1.
        } ELSE {
            LOCK THROTTLE TO 0.1.
        }
        tilt(90).
        RETURN.
    }
    tilt(ALTITUDE / 1000).
}

IF STAGE:SOLIDFUEL > 0 {
    LOCK THROTTLE TO 0.
    UNTIL STAGE:SOLIDFUEL < 1 OR success {
        WAIT 1.
        autoTile.
    }.
} ELSE {
    SET lastFuel TO STAGE:LIQUIDFUEL.
    SET maxFuelCost TO 0.
    SET detachCount TO 0.
    UNTIL FALSE {
        IF success {
            BREAK.
        }.
        WAIT 0.1.
        autoTile.
        SET fuelCost TO lastFuel - STAGE:LIQUIDFUEL.
        IF fuelCost * 2 < maxFuelCost * THROTTLE {
            SET detachCount TO detachCount + 1.
        } ELSE {
            SET detachCount TO 0.
        }.
        IF detachCount > 9 {
            BREAK.
        }.
        if fuelCost > maxFuelCost {
            SET maxFuelCost TO fuelCost.
        }.
        SET lastFuel TO STAGE:LIQUIDFUEL.
    }.
}.

IF NOT success {
    WAIT 1.
    PRINT "Detach secondary tanks.".
    STAGE.
    LOCK THROTTLE TO 1.0.
    WAIT 0.1.
    LOCK THROTTLE TO 0.0.
    WAIT 1.9.
    LOCK THROTTLE TO 1.0.
}.

UNTIL STAGE:LIQUIDFUEL < 1 OR success {
    autoTile.
    WAIT 1.
}.

IF NOT success {
    PRINT "Detach main tank.".
    STAGE.
}.

UNTIL success {
    autoTile.
    WAIT 1.
}

PRINT "Success.".

TOGGLE LIGHTS.
LOCK THROTTLE TO 0.
