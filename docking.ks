ClearScreen.

local rcsForceFore to 1.
local rcsForceStar to 1.
local rcsForceTop  to 1.

local turnTime to 0.

local tset to 0.
local sset to Ship:Facing:Vector.
lock Throttle to tset.
lock Steering to sset.

local ctlPart to Ship:ControlPart.
if not Target:HasSuffix("Ship") {
    Approch(ctlPart, Target).
}
Docking(ctlPart).

function UnlockEverything {
    set tset to 0.
    unlock Throttle.
    unlock Steering.
    set Ship:Control:StarBoard to 0.
    set Ship:Control:Fore      to 0.
    set Ship:Control:Top       to 0.
}

function Notify {
    parameter str.

    HudText(str, 5, 2, 20, White, False).
    print str.
}

function WaitAttitudeStableWithParam {
    parameter dir.
    parameter cosValue1.
    parameter cosValue2.

    Notify("Wait for stable.").

    local last1 to Ship:Facing:StarVector.
    local last2 to Ship:Facing:ForeVector.
    local last3 to Ship:Facing:TopVector.
    local n to 0.
    local c to 0.
    until n > 10 {
        LOCK STEERING to dir.
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
    return c / 10 - 1.
}

function WaitAttitudeStable {
    parameter dir.
    Notify("Wait for stable.").
    return waitAttitudeStableWithParam(dir, 0.99995, -1).
}

function WaitAttitudeStableStrict {
    parameter dir.
    Notify("Wait for strict stable.").
    return waitAttitudeStableWithParam(dir, 0.999998, 0.999998).
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
function Approch {
    parameter ctlPart.
    parameter tarPort.
    parameter maxVel.
    parameter accRatio.

    if (tarPort:Position - ctlPart:NodePosition):Mag < 200 and
       (tarPort:Velocity:Orbit - ctlPart:Ship:Velocity:Orbit):Mag < 20 {
        return.
    }

    local distance to 30.
    local approchStatus to 1.

    TestTurnTime().

    SAS OFF.
    RCS OFF.

    Notify("Start approching.").

    until False {
        ClearVecDraws().

        // 目标位置为目标前方 distance 距离处的点
        local tarPos to tarPort:Position.
        local ctlPos to ctlPart:NodePosition.
        local tarVel to tarPort:Velocity:Orbit.
        local ctlVel to ctlPart:Ship:Velocity:Orbit.

        // 与目标位置的距离
        local rlvPos to tarPos - ctlPos.
        local rlvPosDist to rlvPos:Mag - distance.
        local rlvPosVec to rlvPos:Normalized.
        VecDraw(V(0, 2, 0), rlvPos, RGB(1, 0, 0), "POS", 1, True).

        // 与目标的相对速度
        local rlvVel to tarVel - ctlVel.
        local rlvVelNorm to rlvVel:Mag.
        VecDraw(V(0, -2, 0), -rlvVel, RGB(1, 0, 0), "REL V", 1, True).

        local thrustAcc to Ship:AvailableThrust / Ship:Mass.
        local minDescendDist to rlvVel ^ 2 / thrustAcc / 2.

        local expVelNorm to min(100, sqrt(2 * rlvPosDist * thrustAcc) * accRatio).
        local expVel to rlvPosVec * expVelNorm.
        VecDraw(V(0, -2, 0), expVel, RGB(0, 1, 0), "EXP V", 1, True).

        // 与期望接近速度的差
        local expVelOffset to expVel + rlvVel.
        local expVelOffsetNorm to expVelOffset:Mag.

        // local tarVec to rlvPos:Normalized.
        local tarVec to expVelOffset:Normalized.
        VecDraw(V(0, 0, 0), tarVec * 10, RGB(1, 0, 0), "TAR A", 10, True).

        if approchStatus = 1 {
            if rlvPosDist < minDescendDist + rlvVel * rlvPosVec * turnTime {
                set approchStatus to 2.
            }
        } else if approchStatus = 2 {
            if rlvPosDist < minDescendDist {
                set approchStatus to 3.
            }
        } else {
            if rlvPosDist < 1 and expVelNorm < 0.1 and expVelOffsetNorm < 0.1 {
                UnlockEverything().
                SAS ON.
                Notify("Approching finished.").
                ClearVecDraws().
                Break.
            }
        }

        if approchStatus = 2 {
            set tset to 0.
            set sset to -rlvPosVec.
        } else {
            // 达到期望接近速度时对准目标位置
            if expVelOffsetNorm > max(1, expVelNorm / 10) and expVelNorm > 1 {
                set sset to facingVec.
            }

            // 角度接近时开始机动
            if facingVec * ctlPart:PortFacing:Vector > 0.99 {
                set tset to expVelOffsetNorm / thrustAcc.
            } else {
                set tset to 0.
            }
        }

        wait 0.01.
    }
}

// 用 RCS 对接
function Docking {
    parameter ctlPart.

    Notify("if not safe to docking, move first. Then set the Target docker as Target. Then will start docking.").
    wait until Target:HasSuffix("Ship").

    SAS OFF.
    RCS ON.

    local tarPort to Target.
    local dockingState to 1.
    local distance to 1.

    until False {
        ClearVecDraws().

        // 目标位置为目标前方 distance 距离处的点
        local tarPos to tarPort:NodePosition.
        if dockingState = 1 {
            set tarPos to tarPort:NodePosition + tarPort:PortFacing:Vector * distance.
        }
        local tarVel to tarPort:Ship:Velocity:Orbit.
        local ctlPos to ctlPart:NodePosition.
        local ctlVel to ctlPart:Ship:Velocity:Orbit.

        // 与目标位置的距离
        local rlvPos to tarPos - ctlPos.
        local rlvPosDist to rlvPos:Mag.
        local rlvPosVec to rlvPos:Normalized.
        VecDraw(V(0, 2, 0), rlvPos, RGB(1, 0, 0), "POS", 1, True).
        if rlvPosDist < 0.1 {
            set dockingState to 2.
        }

        // 与目标的相对速度
        local rlvVel to tarVel - ctlVel.
        local rlvVelNorm to rlvVel:Mag.
        VecDraw(V(0, -2, 0), -rlvVel, RGB(1, 0, 0), "REL V", 1, True).

        // 期望的接近速度
        set expVelNorm to max(0.1, min(10, min(rlvPosDist / 10, sqrt(rlvPosDist * rcsAccFore) / 2))).
        set expVel to rlvPosVec * expVelNorm.
        VecDraw(V(0, -2, 0), expVel, RGB(0, 1, 0), "EXP V", 1, True).

        // 与期望接近速度的差
        set expVelOffset to expVel + rlvVel.

        VecDraw(V(0, 0, 0), expVelOffset:Normalized, RGB(1, 0, 0), "TAR A", 5, True).

        LOCK STEERING to LOOKDIRUP(-tarPort:PortFacing:Vector, tarPort:PortFacing:TopVector).
        set Ship:Control:STARBOARD to expVelOffset * Ship:Facing:StarVector / rcsAccStar.
        set Ship:Control:FORE      to expVelOffset * Ship:Facing:ForeVector / rcsAccFore.
        set Ship:Control:TOP       to expVelOffset * Ship:Facing:TopVector  / rcsAccTop.

        wait 0.01.

        if Target:STATE <> "Ready" {
            Notify("Docking success.").
            unlockEverything().
            CLEARVECDRAWS().
            Break.
        }
    }
}
