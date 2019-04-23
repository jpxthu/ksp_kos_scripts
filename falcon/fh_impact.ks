parameter cpuTag.
parameter landGeo.
parameter vesselHeight.
parameter engineTag.

RunOncePath("/lib/trajactory").

local conn to Processor(cpuTag):Connection.

local landHeight to landGeo:TerrainHeight.
local landOnSea to landHeight < 0.

until not Core:Messages:Empty {
    wait 0.1.
}
print "Begin calculation.".

// local eg to Ship:PartsTagged(engineTag)[0].

until False {
    if landOnSea {
        set landHeight to vesselHeight.
    } else {
        set landHeight to vesselHeight + landGeo:TerrainHeight.
    }

    // if eg:Mode <> "CenterOnly" and Altitude < 8000 {
    //     eg:ToggleMode().
    // }

    local impPos is ImpactPositionKerbin(3, landHeight).
    conn:SendMessage(impPos).
    wait 0.1.
}
