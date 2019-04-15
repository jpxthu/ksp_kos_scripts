parameter cpuTag.
parameter landGeo.
parameter vesselHeight.

RunOncePath("/lib/trajactory").

local conn to Processor(cpuTag):Connection.

// local lanPos to landGeo:Position.
local landHeight to landGeo:TerrainHeight.
local landOnSea to landHeight < 0.

until False {
    if landOnSea {
        // set lanPos to landGeo:AltitudePosition(0).
        set landHeight to 0.
    } else {
        // set lanPos to landGeo:Position.
        set landHeight to landGeo:TerrainHeight.
    }

    local impPos is ImpactPositionKerbin(3, landHeight + vesselHeight).
    conn:SendMessage(impPos).
}
