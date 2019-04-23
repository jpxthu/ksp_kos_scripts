local secondaryStageFuel to 2000.

local secondaryFuel to 0.
for r in Ship:PartsTagged("ftNorth")[0]:Resources {
    if r:Name = "LiquidFuel" {
        set secondaryFuel to r.
        break.
    }
}

until secondaryFuel:Amount <= secondaryStageFuel {
    wait 0.1.
}
Core:Messages:Clear().

Processor("cpuNorth"):Connection:SendMessage("Detach").
Processor("cpuSouth"):Connection:SendMessage("Detach").
Processor("cpuNorthImpact"):Connection:SendMessage("Begin").
Processor("cpuSouthImpact"):Connection:SendMessage("Begin").
wait 0.01.
Stage.

wait 0.01.
local eg to Ship:PartsTagged("egMain")[0].
set eg:ThrustLimit to 100.

until Throttle < 0.1 {
    wait 0.1.
}
Core:Messages:Clear().
wait 1.
Stage.
Processor("cpuMainImpact"):Connection:SendMessage("Begin").

RCS ON.
set Ship:Control:Fore to -1.
wait 1.
set Ship:Control:Fore to 0.
wait 1.
RCS OFF.

RunPath("/recycle/recycle_constant").
RunPath("/recycle/recycle_adjust", KERBAL_SEA_LANDING_OFCOUSE_I_LOVE_U).
RunPath("/recycle/recycle_landing3", KERBAL_SEA_LANDING_OFCOUSE_I_LOVE_U, 40).
