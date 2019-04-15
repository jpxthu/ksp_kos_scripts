local secondaryStageFuel to 2000.

local connNorth to Processor("cpuNorth"):Connection.
local connSouth to Processor("cpuSouth"):Connection.

local secondaryFuel to 0.
for r in Ship:PartsTagged("ftNorth")[0]:Resources {
    if r:Name = "LiquidFuel" {
        set secondaryFuel to r.
        break.
    }
}

wait until secondaryFuel:Amount <= secondaryStageFuel.
Core:Messages:Clear().

connNorth:SendMessage("Detach").
connSouth:SendMessage("Detach").
wait 0.01.
Stage.

wait until Throttle < 0.1.
Core:Messages:Clear().
wait 1.
Stage.

RCS ON.
set Ship:Control:Fore to -Ship:Facing:Vector * Ship:Facing:ForeVector.
wait 1.
set Ship:Control:Fore to 0.
RCS OFF.

RunPath("/recycle/recycle_constant").
RunPath("/recycle/recycle_adjust", KERBAL_SEA_LANDING_OFCOUSE_I_LOVE_U).
RunPath("/recycle/recycle_landing3", KERBAL_SEA_LANDING_OFCOUSE_I_LOVE_U, 40).
