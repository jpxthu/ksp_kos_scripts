CLEARSCREEN.

SET thrustAcc TO 0.
SET thrustCrossVec TO V(0, 0, 0).
SET thrustFace TO TRUE.

SET rcsAccFore TO 0.
SET rcsAccStar TO 0.
SET rcsAccTop TO 0.

SET turnTime TO 0.

FUNCTION unlockEverything {
    SET THROTTLE TO 0.
    UNLOCK STEERING.
    UNLOCK THROTTLE.
    SET SHIP:CONTROL:STARBOARD TO 0.
    SET SHIP:CONTROL:FORE      TO 0.
    SET SHIP:CONTROL:TOP       TO 0.
}

FUNCTION notify {
    PARAMETER str.

    HUDTEXT(str, 5, 2, 20, WHITE, FALSE).
    PRINT str.
}

FUNCTION waitAttitudeStableWithParam {
    PARAMETER dir.
    PARAMETER cosValue1.
    PARAMETER cosValue2.

    notify("Wait for stable.").

    SET last1 TO SHIP:FACING:STARVECTOR.
    SET last2 TO SHIP:FACING:FOREVECTOR.
    SET last3 TO SHIP:FACING:TOPVECTOR.
    SET n TO 0.
    SET c TO 0.
    UNTIL n > 10 {
        LOCK STEERING TO dir.
        wait 0.1.
        SET cur1 TO SHIP:FACING:STARVECTOR.
        SET cur2 TO SHIP:FACING:FOREVECTOR.
        SET cur3 TO SHIP:FACING:TOPVECTOR.
        IF cur1 * last1 > cosValue1 AND
           cur2 * last2 > cosValue2 AND
           cur3 * last3 > cosValue2 {
            SET n TO n + 1.
        } ELSE {
            SET n TO 0.
        }
        SET c TO c + 1.
        SET last1 TO cur1.
        SET last2 TO cur2.
        SET last3 TO cur3.
    }
    RETURN c / 10 - 1.
}

FUNCTION waitAttitudeStable {
    PARAMETER dir.
    notify("Wait for stable.").
    RETURN waitAttitudeStableWithParam(dir, 0.99995, -1).
}

FUNCTION waitAttitudeStableStrict {
    PARAMETER dir.
    notify("Wait for strict stable.").
    RETURN waitAttitudeStableWithParam(dir, 0.999998, 0.999998).
}

// 测试旋转半周的时间
FUNCTION testTurnTime {
    WAIT 0.1.
    SAS OFF.
    RCS OFF.
    
    SET vec TO SHIP:FACING:VECTOR.
    waitAttitudeStable(vec).

    SAS OFF.
    RCS OFF.

    SET vec TO -1 * vec.
    
    notify("Turning test begin.").
    SET turnTime TO waitAttitudeStable(vec).
    // notify("Turning test end.").

    notify("Turning: " + turnTime).
}

// 测试火箭动力
FUNCTION testThrustAcc {
    PARAMETER ctlPort.
    PARAMETER tarPort.

    UNLOCK STEERING.
    SAS OFF.
    RCS OFF.
    SET vec TO SHIP:FACING.
    waitAttitudeStable(vec).

    SET testThrottle TO 1.
    SET testTime TO 1.

    notify("Thrust power test begin.").

    LOCK THROTTLE TO 0.
    SET vel0 TO ctlPort:SHIP:VELOCITY:ORBIT - tarPort:VELOCITY:ORBIT.
    LOCK THROTTLE TO testThrottle.
    WAIT testTime.
    LOCK THROTTLE TO 0.
    SET vel1 TO ctlPort:SHIP:VELOCITY:ORBIT - tarPort:VELOCITY:ORBIT.
    
    SET dv TO vel1 - vel0.
    SET thrustAcc TO dv:MAG / testThrottle / testTime.
    SET thrustVec TO dv:NORMALIZED.

    PRINT ctlPort:PORTFACING.
    PRINT ctlPort:PORTFACING:VECTOR.
    PRINT dv.
    SET xx TO ctlPort:PORTFACING.
    SET yy TO ctlPort:PORTFACING:VECTOR.
    SET zz TO dv.
    SET thrustCrossVec TO VCRS(dv:NORMALIZED, ctlPort:PORTFACING:VECTOR).
    SET thrustFace TO TRUE.//thrustCrossVec:MAG < 0.01.
    
    // notify("Thrust power test end.").
    notify("Acceleration when full throttle: " + thrustAcc).
}

// 测试 RCS 动力
FUNCTION testRcsAcc {
    PARAMETER ctlPort.
    PARAMETER tarPort.

    SAS OFF.
    RCS ON.
    SET fore TO SHIP:FACING.
    waitAttitudeStableStrict(fore).

    SET testThrottle TO 1.
    SET testTime TO 1.

    notify("RCS power test begin.").

    SET SHIP:CONTROL:FORE TO 0.
    SET vel0 TO ctlPort:SHIP:VELOCITY:ORBIT - tarPort:SHIP:VELOCITY:ORBIT.
    SET SHIP:CONTROL:FORE TO testThrottle.
    WAIT testTime.
    SET vel1 TO ctlPort:SHIP:VELOCITY:ORBIT - tarPort:SHIP:VELOCITY:ORBIT.
    SET SHIP:CONTROL:FORE TO -testThrottle.
    WAIT testTime.
    SET SHIP:CONTROL:FORE TO 0.
    SET dv TO vel1 - vel0.
    SET rcsAccFore TO dv:MAG / testThrottle / testTime.
    WAIT testTime.
    
    SET SHIP:CONTROL:STARBOARD TO 0.
    SET vel0 TO ctlPort:SHIP:VELOCITY:ORBIT - tarPort:SHIP:VELOCITY:ORBIT.
    SET SHIP:CONTROL:STARBOARD TO testThrottle.
    WAIT testTime.
    SET vel1 TO ctlPort:SHIP:VELOCITY:ORBIT - tarPort:SHIP:VELOCITY:ORBIT.
    SET SHIP:CONTROL:STARBOARD TO -testThrottle.
    WAIT testTime.
    SET SHIP:CONTROL:STARBOARD TO 0.
    SET dv TO vel1 - vel0.
    SET rcsAccStar TO dv:MAG / testThrottle / testTime.
    WAIT testTime.
    
    SET SHIP:CONTROL:TOP TO 0.
    SET vel0 TO ctlPort:SHIP:VELOCITY:ORBIT - tarPort:SHIP:VELOCITY:ORBIT.
    SET SHIP:CONTROL:TOP TO -testThrottle.
    WAIT testTime.
    SET vel1 TO ctlPort:SHIP:VELOCITY:ORBIT - tarPort:SHIP:VELOCITY:ORBIT.
    SET SHIP:CONTROL:TOP TO testThrottle.
    WAIT testTime.
    SET SHIP:CONTROL:TOP TO 0.
    SET dv TO vel1 - vel0.
    SET rcsAccTop TO dv:MAG / testThrottle / testTime.
    WAIT testTime.

    // notify("RCS power test end.").
    notify("Acceleration when full RCS: (" + rcsAccFore + ", " + rcsAccStar + ", " + rcsAccTop + ")").
}

FUNCTION dockingFaceDirection {
    PARAMETER targetVector.
    IF thrustFace {
        RETURN targetVector.
    }
    RETURN VCRS(targetVector, thrustCrossVec).
}

FUNCTION getTargetDockingPort {
    FOR d IN TARGET:DOCKINGPORTS {
        IF d:STATE = "Ready" {
            RETURN d.
        }
    }
}

// 用火箭接近
FUNCTION approch {
    PARAMETER ctlPort.
    PARAMETER tarPort.

    IF (tarPort:POSITION - ctlPort:NODEPOSITION):MAG < 200 AND
       (tarPort:VELOCITY:ORBIT - ctlPort:SHIP:VELOCITY:ORBIT):MAG < 20 {
        RETURN.
    }

    SET distance TO 20.
    
    testTurnTime().
    testThrustAcc(ctlPort, tarPort).

    SAS OFF.
    RCS OFF.

    notify("Start approching.").

    UNTIL FALSE {
        CLEARVECDRAWS().

        // 目标位置为目标前方 distance 距离处的点
        SET tarPos TO tarPort:POSITION.
        SET ctlPos TO ctlPort:NODEPOSITION.
        SET tarVel TO tarPort:VELOCITY:ORBIT.
        SET ctlVel TO ctlPort:SHIP:VELOCITY:ORBIT.
        
        // 与目标位置的距离
        SET rlvPos TO tarPos - ctlPos.
        SET rlvPosDist TO rlvPos:MAG - distance.
        SET rlvPosVec TO rlvPos:NORMALIZED.
        VECDRAW(V(0, 2, 0), rlvPos, RGB(1, 0, 0), "POS", 1, TRUE).

        // 与目标的相对速度
        SET rlvVel To tarVel - ctlVel.
        SET rlvVelNorm TO rlvVel:MAG.
        VECDRAW(V(0, -2, 0), -rlvVel, RGB(1, 0, 0), "REL V", 1, TRUE).

        // 期望的接近速度
        IF rlvPosDist < 1 {
            SET expVelNorm TO 0.
        } ELSE {
            SET temp TO rlvPosDist + rlvVel * rlvPosVec * turnTime * (rlvPosVec * ctlPort:PORTFACING:VECTOR + 1) / 2.
            SET expVelNorm TO MIN(100, MIN(temp / 10, SQRT(temp * thrustAcc) / 2)).
        }
        SET expVel TO rlvPosVec * expVelNorm.
        VECDRAW(V(0, -2, 0), expVel, RGB(0, 1, 0), "EXP V", 1, TRUE).

        // 与期望接近速度的差
        SET expVelOffset TO expVel + rlvVel.
        SET expVelOffsetNorm TO expVelOffset:MAG.

        // SET tarVec TO rlvPos:NORMALIZED.
        SET tarVec TO expVelOffset:NORMALIZED.
        SET facingVec TO dockingFaceDirection(tarVec).

        // 达到期望接近速度时对准目标位置
        IF expVelOffsetNorm > MAX(1, expVelNorm / 10) AND expVelNorm > 1 {
            LOCK STEERING TO facingVec:DIRECTION.
        }
        
        VECDRAW(V(0, 0, 0), tarVec * 10, RGB(1, 0, 0), "TAR A", 10, TRUE).
        IF NOT thrustFace {
            VECDRAW(V(0, 0, 0), facingVec * 10, RGB(0, 1, 0), "TAR F", 10, TRUE).
        }

        // 角度接近时开始机动
        IF facingVec * ctlPort:PORTFACING:VECTOR > 0.99 {
            LOCK THROTTLE TO expVelOffsetNorm / thrustAcc.
        } ELSE {
            LOCK THROTTLE TO 0.
        }

        WAIT 0.01.

        IF rlvPosDist < 1 AND expVelNorm < 0.1 AND expVelOffsetNorm < 0.1 {
            SET THROTTLE TO 0.
            UNLOCK STEERING.
            UNLOCK THROTTLE.
            notify("Approching finished.").
            CLEARVECDRAWS().
            BREAK.
        }
    }
}

// 用 RCS 对接
FUNCTION docking {
    PARAMETER ctlPort.

    notify("If not safe to docking, move first. Then set the target docker as target. Then will start docking.").
    WAIT UNTIL TARGET:HASSUFFIX("SHIP").

    testRcsAcc(ctlPort, TARGET).

    SAS OFF.
    RCS ON.

    SET tarPort TO TARGET.
    SET dockingState TO 1.
    SET distance TO 1.

    UNTIL FALSE {
        CLEARVECDRAWS().

        // 目标位置为目标前方 distance 距离处的点
        IF dockingState = 1 {
            SET tarPos TO tarPort:NODEPOSITION + tarPort:PORTFACING:VECTOR * distance.
        } ELSE {
            SET tarPos TO tarPort:NODEPOSITION.
        }
        SET tarVel TO tarPort:SHIP:VELOCITY:ORBIT.
        SET ctlPos TO ctlPort:NODEPOSITION.
        SET ctlVel TO ctlPort:SHIP:VELOCITY:ORBIT.
        
        // 与目标位置的距离
        SET rlvPos TO tarPos - ctlPos.
        SET rlvPosDist TO rlvPos:MAG.
        SET rlvPosVec TO rlvPos:NORMALIZED.
        VECDRAW(V(0, 2, 0), rlvPos, RGB(1, 0, 0), "POS", 1, TRUE).
        IF rlvPosDist < 0.1 {
            SET dockingState TO 2.
        }

        // 与目标的相对速度
        SET rlvVel To tarVel - ctlVel.
        SET rlvVelNorm TO rlvVel:MAG.
        VECDRAW(V(0, -2, 0), -rlvVel, RGB(1, 0, 0), "REL V", 1, TRUE).

        // 期望的接近速度
        SET expVelNorm TO MAX(0.1, MIN(10, MIN(rlvPosDist / 10, SQRT(rlvPosDist * rcsAccFore) / 2))).
        SET expVel TO rlvPosVec * expVelNorm.
        VECDRAW(V(0, -2, 0), expVel, RGB(0, 1, 0), "EXP V", 1, TRUE).

        // 与期望接近速度的差
        SET expVelOffset TO expVel + rlvVel.

        VECDRAW(V(0, 0, 0), expVelOffset:NORMALIZED, RGB(1, 0, 0), "TAR A", 5, TRUE).

        LOCK STEERING TO LOOKDIRUP(-tarPort:PORTFACING:VECTOR, tarPort:PORTFACING:TOPVECTOR).
        SET SHIP:CONTROL:STARBOARD TO expVelOffset * SHIP:FACING:STARVECTOR / rcsAccStar.
        SET SHIP:CONTROL:FORE      TO expVelOffset * SHIP:FACING:FOREVECTOR / rcsAccFore.
        SET SHIP:CONTROL:TOP       TO expVelOffset * SHIP:FACING:TOPVECTOR  / rcsAccTop.

        WAIT 0.01.

        IF TARGET:STATE <> "Ready" {
            notify("Docking success.").
            unlockEverything().
            CLEARVECDRAWS().
            BREAK.
        }
    }
}

unlockEverything().
SET ctlPort TO SHIP:CONTROLPART.
// testThrustAcc(ctlPort, TARGET).
IF NOT TARGET:HASSUFFIX("SHIP") {
    approch(ctlPort, TARGET).
}
docking(ctlPort).
