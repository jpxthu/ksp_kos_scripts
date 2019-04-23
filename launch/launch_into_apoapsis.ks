parameter tarApoapsis.

local maxQ to 15000.
local dt to 0.1.

RunOncePath("/launch/launch_lib").
RunOncePath("/lib/control").

SAS OFF.
RCS OFF.

set tset to 0.
set sset to Ship:Facing:Vector.

lock Throttle to tset.
lock Steering to sset.

until Apoapsis > tarApoapsis {
    set sset to AngleToHeading(Apoapsis / tarApoapsis * 90).

    local q is CalculateQ().
    set tset to min(1, max(0, (1.1 - q / maxQ) * 5)).

    wait dt.
    // print "0 " + Apoapsis + " " + Periapsis.
}

UnlockControl().

print "Into apoapsis.".
print "Apoapsis: " + Apoapsis + " m".
print "Periapsis: " + Periapsis + " m".
