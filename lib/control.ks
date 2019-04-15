function UnlockControl {
    set tset to 0.
    unlock Throttle.
    unlock Steering.
    set Ship:Control:StarBoard to 0.
    set Ship:Control:Fore      to 0.
    set Ship:Control:Top       to 0.
    set Ship:Control:Neutralize to true.
}
