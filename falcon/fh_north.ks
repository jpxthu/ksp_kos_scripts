RunOncePath("/recycle/recycle_constant").

local stageFule to FALCON_RETURN_FUEL.

local tank to Ship:PartsTagged("FT4")[0].
local tank2 to Ship:PartsTagged("FT3")[0].
local fuel to 0.
for r in tank:Resources {
    if r:Name = "LiquidFuel" {
        set fuel to r.
        break.
    }
}

wait until fuel:Amount < stageFule.

local disapartVec to (tank:Position - tank2:Position):Normalized * 0.5.
wait 0.1.

// Stage.

local tset to 0.
local sset to Ship:Velocity:Surface.

lock Throttle to tset.
lock Steering to sset.

RCS ON.
local timeNext to Time + 5.
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

local landGeo to KERBAL_CENTER_LAUNCH_PAD_NORTH_GEO.

RunPath("/recycle/recycle_adjust", landGeo).
RunPath("/recycle/recycle_landing3", landGeo).
