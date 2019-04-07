local stageFule is 3000.

set tank to Ship:PartsTagged("FT3")[0].
for r in tank:Resources {
    if r:Name = "LiquidFuel" {
        set fuel to r.
        break.
    }
}

wait until fuel:Amount < stageFule.

run once trajactory.

local landGeo to LatLng(-0.108690763956662, -74.5642229639099).

set conn to Processor("Computer3"):Connection.

until False {
    local impPos is ImpactPosition(3, -landGeo:Position * UP:Vector).
    conn:SendMessage(impPos).
}
