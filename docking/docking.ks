parameter approachSpeed.
parameter approachThrottle.
parameter approachDist.
parameter dockingSpeed.
parameter tarPortTag is "".
parameter ctlPortTag is "".
parameter turnTime is -1.

RunOncePath("/lib/control").

local rcsForceFore to 1.
local rcsForceStar to 1.
local rcsForceTop  to 1.

UnlockControl().
TestRcsAcc().
Approach(approachSpeed, approachThrottle, approachDist).
Docking(dockingSpeed).

function Notify {
    parameter str.

    // HudText(str, 5, 2, 20, White, False).
    print str.
}

// 测试 RCS 动力
function TestRcsAcc {
    SAS OFF.
    RCS ON.
    local Fore to Ship:Facing.
    WaitAttitudeStableStrict(Fore).

    lock Throttle to 0.
    lock Steering to Fore.

    local testThrottle to 0.1.
    local testTime to 0.5.
    local ratio to 0.8.

    notify("RCS power test begin.").

    local acc1 to Ship:Sensors:Acc.
    set Ship:Control:Fore to testThrottle.
    wait testTime.
    local acc2 to Ship:Sensors:Acc.
    set Ship:Control:Fore to -testThrottle.
    wait testTime.
    set Ship:Control:Fore to 0.
    wait testTime.
    local acc3 to (acc2 - acc1) * Ship:Facing:ForeVector.
    local acc4 to (acc2 - acc1):Mag * ratio.
    set rcsForceFore to max(acc3, acc4) / testThrottle * Ship:Mass.

    set acc1 to Ship:Sensors:Acc.
    set Ship:Control:StarBoard to testThrottle.
    wait testTime.
    set acc2 to Ship:Sensors:Acc.
    set Ship:Control:StarBoard to -testThrottle.
    wait testTime.
    set Ship:Control:StarBoard to 0.
    wait testTime.
    set acc3 to (acc2 - acc1) * Ship:Facing:StarVector.
    set acc4 to (acc2 - acc1):Mag * ratio.
    set rcsForceStar to max(acc3, acc4) / testThrottle * Ship:Mass.

    set acc1 to Ship:Sensors:Acc.
    set Ship:Control:Top to testThrottle.
    wait testTime.
    set acc2 to Ship:Sensors:Acc.
    set Ship:Control:Top to -testThrottle.
    wait testTime.
    set Ship:Control:Top to 0.
    wait testTime.
    set acc3 to (acc2 - acc1) * Ship:Facing:TopVector.
    set acc4 to (acc2 - acc1):Mag * ratio.
    set rcsForceTop to max(acc3, acc4) / testThrottle * Ship:Mass.

    UnlockControl().

    // notify("RCS power test end.").
    notify("Acceleration when full RCS: (" + rcsForceFore + ", " + rcsForceStar + ", " + rcsForceTop + ")").
}

function WaitAttitudeStableWithParam {
    parameter dir.
    parameter cosValue1.
    parameter cosValue2.

    Notify("wait for stable.").

    local last1 to Ship:Facing:StarVector.
    local last2 to Ship:Facing:ForeVector.
    local last3 to Ship:Facing:TopVector.
    local n to 0.
    local c to 0.

    lock Steering to dir.
    lock Throttle to 0.
    until n > 10 {
        wait 0.1.
        local cur1 to Ship:Facing:StarVector.
        local cur2 to Ship:Facing:ForeVector.
        local cur3 to Ship:Facing:TopVector.
        if cur1 * last1 > cosValue1 and
           cur2 * last2 > cosValue2 and
           cur3 * last3 > cosValue2 {
            set n to n + 1.
        } else {
            set n to 0.
        }
        set c to c + 1.
        set last1 to cur1.
        set last2 to cur2.
        set last3 to cur3.
    }
    UnlockControl().
    return c / 10 - 1.
}

function WaitAttitudeStable {
    parameter dir.
    Notify("wait for stable.").
    return WaitAttitudeStableWithParam(dir, 0.99995, -1).
}

function WaitAttitudeStableStrict {
    parameter dir.
    Notify("wait for strict stable.").
    return WaitAttitudeStableWithParam(dir, 0.999998, 0.999998).
}

// 测试旋转半周的时间
function TestTurnTime {
    wait 0.1.
    SAS OFF.
    RCS OFF.

    local vec to Ship:Facing:Vector.
    WaitAttitudeStable(vec).

    SAS OFF.
    RCS OFF.

    set vec to -1 * vec.

    Notify("Turning test begin.").
    set turnTime to WaitAttitudeStable(vec).
    // Notify("Turning test end.").

    Notify("Turning: " + turnTime).
}

function GetTargetDockingPort {
    for d in Target:DockingPorts {
        if d:State = "Ready" {
            return d.
        }
    }
}

// 用火箭接近
function Approach {
    parameter maxVel.
    parameter accRatio.
    parameter distance.

    local tarPort to Target.

    if (tarPort:Position - Ship:Position):Mag < 200 and
       (tarPort:Velocity:Orbit - Ship:Velocity:Orbit):Mag < 20 {
        return.
    }

    local approachStatus to 0.

    if turnTime < 0 {
        TestTurnTime().
    }

    SAS OFF.
    RCS OFF.

    Notify("Start approching.").

    local tset to 0.
    local sset to Ship:Facing.

    lock Throttle to tset.
    lock Steering to sset.

    local hasTarPortTag to (tarPortTag <> "").
    local tarPortFound to False.
    local dockingPort to Target.

    until False {
        ClearVecDraws().

        // 目标位置为目标前方 distance 距离处的点
        local ctlPos to Ship:Position.
        local tarVel to tarPort:Velocity:Orbit.
        local ctlVel to Ship:Velocity:Orbit.

        local tarPos to Target:Position.
        if tarPortFound {
            set tarPos to dockingPort:NodePosition + dockingPort:PortFacing:Vector * approachDist.
        } else {
            set tarPos to tarPos - (tarPos - ctlPos):Normalized * approachDist.
            if hasTarPortTag {
                local parts to Target:PartsTagged(tarPortTag).
                if parts:Length > 0 {
                    set dockingPort to parts[0].
                    set tarPortFound to True.
                }
            }
        }

        // 与目标位置的距离
        local rlvPos to tarPos - ctlPos.
        local rlvPosDist to 0.
        local rlvPosVec to rlvPos:Normalized.

        if approachStatus > 1 {
            set rlvPosDist to -rlvPos * Ship:Facing:Vector.
        } else {
            set rlvPosDist to rlvPos:Mag.
        }
        // VecDraw(V(0, 2, 0), rlvPos, RGB(1, 0, 0), "POS", 1, True).

        // 与目标的相对速度
        local rlvVel to ctlVel - tarVel.
        local rlvVelMag to rlvVel:Mag.
        local rlvVelVec to rlvVel:Normalized.
        // VecDraw(V(0, -2, 0), rlvVel, RGB(1, 0, 0), "REL V", 1, True).

        local thrustAcc to Ship:AvailableThrust / Ship:Mass.
        local minDescendDist to rlvVelMag ^ 2 / thrustAcc / accRatio / 2.
        if rlvVel * rlvPosVec < 0 {
            if approachStatus < 4 {
                set approachStatus to 0.
            }
            set minDescendDist to 0.
        }

        local expVelNorm to min(maxVel, sqrt(max(0, 2 * rlvPosDist * thrustAcc * accRatio))).
        local expVel to rlvPosVec * expVelNorm.
        // VecDraw(V(0, -2, 0), expVel, RGB(0, 1, 0), "EXP V", 1, True).

        // 与期望接近速度的差
        local expVelOffset to expVel - rlvVel.
        local expVelOffsetNorm to expVelOffset:Mag.
        local expAcc to expVelOffset.// - thrustAcc * accRatio * rlvPosVec.

        // local tarVec to rlvPos:Normalized.
        local tarVec to expVelOffset:Normalized.

        local turnDist to rlvVelMag * turnTime.
        if approachStatus = 0 {
            if rlvPosDist < minDescendDist + turnDist * 10 {
                set approachStatus to 1.
                set maxVel to min(maxVel, rlvVelMag).
            }
        } else if approachStatus = 1 {
            if rlvPosDist < minDescendDist + turnDist * 2 {
                set approachStatus to 2.
                RCS ON.
            }
        } else if approachStatus = 2 {
            if rlvPosDist < minDescendDist or Ship:Facing:Vector * rlvVelVec < -0.995 {
                set approachStatus to 3.
            }
        } else if approachStatus = 3 {
            local deltaV to max(2, thrustAcc * accRatio * 0.5).
            // if expVelNorm < deltaV and expVelOffsetNorm < deltaV {
            if rlvVelMag < deltaV {
                set approachStatus to 4.
            }
        } else {
            if rlvPosDist < 1 and expVelNorm < 0.1 and expVelOffsetNorm < 0.1 {
                UnlockControl().
                SAS ON.
                Notify("Approching finished.").
                ClearVecDraws().
                Break.
            }
        }

        if approachStatus = 0 or approachStatus = 1 {
            // 达到期望接近速度时不频繁换姿态
            if expVelOffsetNorm > 0.5 {
                set sset to tarVec.
            }

            // 角度接近时开始机动
            local temp to sset * Ship:Facing:Vector.
            if temp > 0.95 {
                local tsetTemp to expVelOffsetNorm / thrustAcc * (temp - 0.95) * 20.
                if tsetTemp > 0.01 {
                    set tset to min(1, tsetTemp).
                } else {
                    set tset to 0.
                }
            } else {
                set tset to 0.
            }
        } else if approachStatus = 2 {
            set tset to 0.
            set sset to -rlvVelVec..
            set Ship:Control:StarBoard to min(1, max(-1, expAcc * Ship:Facing:StarVector / (rcsForceStar / Ship:Mass))).
            set Ship:Control:Fore      to 0.
            set Ship:Control:Top       to min(1, max(-1, expAcc * Ship:Facing:TopVector  / (rcsForceTop  / Ship:Mass))).
        } else if approachStatus = 3 {
            set tset to min(1, max(0, expAcc * Ship:Facing:Vector / thrustAcc + accRatio)).
            set sset to -rlvVelVec * 0.95 + tarVec * 0.05.
            set Ship:Control:StarBoard to min(1, max(-1, expAcc * Ship:Facing:StarVector / (rcsForceStar / Ship:Mass))).
            set Ship:Control:Fore      to 0.
            set Ship:Control:Top       to min(1, max(-1, expAcc * Ship:Facing:TopVector  / (rcsForceTop  / Ship:Mass))).
        } else {
            set tset to 0.
            // set sset to -rlvPosVec.
            set Ship:Control:StarBoard to min(1, max(-1, -rlvVel * Ship:Facing:StarVector / (rcsForceStar / Ship:Mass))).
            set Ship:Control:Fore      to min(1, max(-1, -rlvVel * Ship:Facing:ForeVector / (rcsForceFore / Ship:Mass))).
            set Ship:Control:Top       to min(1, max(-1, -rlvVel * Ship:Facing:TopVector  / (rcsForceTop  / Ship:Mass))).
        }

        // VecDraw(V(0, 0, 0), sset * 10, RGB(1, 0, 0), "TAR A", 1, True).

        // print approachStatus + " " + turnDist + " " + expVelNorm + " " + tset.
        print approachStatus + " " + rlvVelMag + " " + minDescendDist + " " + rlvPosDist.

        wait 0.1.
    }
}

// 用 RCS 对接
function Docking {
    parameter maxVel.

    Notify("if not safe to docking, move first. Then set the Target docker as Target. Then will start docking.").

    local tarPort to Target.
    if tarPortTag <> "" {
        set tarPort to Target:PartsTagged(tarPortTag)[0].
    } else {
        wait until Target:HasSuffix("Ship").
        set tarPort to Target.
    }
    // wait until Ship:ControlPart:HasSuffix("Ship").
    
    if ctlPortTag <> "" {
        Ship:PartsTagged(ctlPortTag)[0]:ControlFrom().
    }
    local ctlPart to Ship:ControlPart.

    local accRatio to min(1, max(0.01, 2 / rcsForceFore)).

    SAS OFF.
    RCS OFF.
    
    local tarDir to LookDirUp(-tarPort:PortFacing:Vector, tarPort:PortFacing:TopVector).
    WaitAttitudeStable(tarDir).

    RCS ON.

    local dockingState to 1.
    local distance to 1.

    local tset to 0.
    local sset to Ship:Facing.
    lock Throttle to tset.
    lock Steering to sset.

    until False {
        ClearVecDraws().

        local tarPos to tarPort:NodePosition.
        if dockingState = 1 {
            // 目标位置为目标前方 distance 距离处的点
            set tarPos to tarPos + tarPort:PortFacing:Vector * distance.
        }
        local tarVel to tarPort:Ship:Velocity:Orbit.
        local ctlPos to ctlPart:NodePosition.
        local ctlVel to ctlPart:Ship:Velocity:Orbit.

        // 与目标位置的距离
        local rlvPos to tarPos - ctlPos.
        local rlvPosDist to rlvPos:Mag.
        local rlvPosVec to rlvPos:Normalized.
        // VecDraw(V(0, 2, 0), rlvPos, RGB(1, 0, 0), "POS", 1, True).
        if rlvPosDist < 0.1 {
            set dockingState to 2.
        }

        // 与目标的相对速度
        local rlvVel to tarVel - ctlVel.
        local rlvVelMag to rlvVel:Mag.
        // VecDraw(V(0, -2, 0), -rlvVel, RGB(1, 0, 0), "REL V", 1, True).

        // 期望的接近速度
        local expVelNorm to max(0.1, min(maxVel, sqrt(max(0, 2 * (rlvPosDist - 1) * (rcsForceFore / Ship:Mass) * accRatio)))).
        local expVel to rlvPosVec * expVelNorm.
        // VecDraw(V(0, -2, 0), expVel, RGB(0, 1, 0), "EXP V", 1, True).

        // 与期望接近速度的差
        local expVelOffset to expVel + rlvVel.
        local expAcc to expVelOffset * 5.

        // VecDraw(V(0, 0, 0), expVelOffset:Normalized, RGB(1, 0, 0), "TAR A", 5, True).

        set sset to LookDirUp(-tarPort:PortFacing:Vector, tarPort:PortFacing:TopVector).
        set Ship:Control:StarBoard to min(1, max(-1, expAcc * Ship:Facing:StarVector / (rcsForceStar / Ship:Mass))).
        set Ship:Control:Fore      to min(1, max(-1, expAcc * Ship:Facing:ForeVector / (rcsForceFore / Ship:Mass))).
        set Ship:Control:Top       to min(1, max(-1, expAcc * Ship:Facing:TopVector  / (rcsForceTop  / Ship:Mass))).

        wait 0.01.

        if tarPort:State <> "Ready" {
            Notify("Docking success.").
            UnlockControl().
            ClearVecDraws().
            Break.
        }
    }
}
