local stageFule is 3000.

set tank to Ship:PartsTagged("FT4")[0].
for r in tank:Resources {
    if r:Name = "LiquidFuel" {
        set fuel to r.
        break.
    }
}

wait until fuel:Amount < stageFule.

run once trajactory.

local landGeo to LatLng(-0.0853591972406485, -74.5641045902701).

set conn to Processor("Computer4"):Connection.

until False {
    local impPos is ImpactPosition(3, -landGeo:Position * UP:Vector).
    conn:SendMessage(impPos).
}
