parameter cpuTag.
parameter landGeo.

RunOncePath("/lib/trajactory").

local conn to Processor(cpuTag):Connection.

local lanPos to landGeo:Position.
local landHeight to landGeo:TerrainHeight.
local landOnSea to landHeight < 0.

until False {
    if landOnSea {
        set lanPos to landGeo:AltitudePosition(0).
    } else {
        set lanPos to landGeo:Position.
    }

    local impPos is ImpactPosition(3, -lanPos * UP:Vector).
    conn:SendMessage(impPos).
}
