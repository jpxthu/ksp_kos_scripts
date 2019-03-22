lock steering to UP.

until false {
    set tmp to Ship:Facing:Vector * UP:Vector.
    set tmp2 to min(4, (max(0, 1 - tmp ^ 2)) ^ 0.5 * 2 + 2).
    print tmp2.
    set SteeringManager:MaxStoppingTime to tmp2.

    // if abs(Ship:Control:Pitch) + abs(Ship:Control:Yaw) > 0.2 {
    //     RCS ON.
    // } else {
    //     RCS OFF.
    // }
    wait 0.1.

    print Ship:Control:PilotRoll + " " + Ship:Control:PilotPitch + " " + Ship:Control:PilotYaw.
    // if tmp > 0.9999 {
    //     break.
    // }
}

// wait 5.
// unlock steering.
