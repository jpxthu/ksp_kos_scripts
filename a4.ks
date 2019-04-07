local stageFule is 2000.

set tank to Ship:PartsTagged("FT4")[0].
set tank2 to Ship:PartsTagged("FT3")[0].
for r in tank:Resources {
    if r:Name = "LiquidFuel" {
        set fuel to r.
        break.
    }
}

wait until fuel:Amount < stageFule.

set disapartVec to (tank:Position - tank2:Position):Normalized * 0.5.
wait 0.1.

// Stage.

set tset to 0.
set sset to Ship:Velocity:Surface.

lock Throttle to tset.
lock Steering to sset.

RCS ON.
set timeNext to Time + 5.
set sset to UP:Vector + disapartVec * 0.5.
until Time > timeNext {
    set Ship:Control:StarBoard to disapartVec * Ship:Facing:StarVector.
    set Ship:Control:Fore      to disapartVec * Ship:Facing:ForeVector.
    set Ship:Control:Top       to disapartVec * Ship:Facing:TopVector.
    wait 0.1.
}
set Ship:Control:StarBoard to 0.
set Ship:Control:Fore      to 0.
set Ship:Control:Top       to 0.
RCS OFF.

unlock Throttle.
unlock Steering.

local landGeo to LatLng(-0.0853591972406485, -74.5641045902701).

run recycle_adjust_impact_position(landGeo).
run recycle_descending_and_landing3(landGeo).
