parameter ftTag.
parameter landGeo.

local tank to Ship:PartsTagged(ftTag)[0].
local tankMain to Ship:PartsTagged("ftMain")[0].

local disapartVec to (tank:Position - tankMain:Position):Normalized * 0.5.
until False {
    if not Core:Messages:Empty {
        local msg to Core:Messages:Pop.
        if msg:Content = "Detach" {
            break.
        }
    }
}

wait 0.1.

local tset to 0.
local sset to Ship:Velocity:Surface.

lock Throttle to tset.
lock Steering to sset.

RCS ON.
local timeNext to Time + 3.
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

RunPath("/recycle/recycle_adjust", landGeo).
RunPath("/recycle/recycle_landing3", landGeo, 30).
