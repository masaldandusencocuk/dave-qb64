' =====================================
' DAVE – CAHIT BERKAY EDITION (FINAL)
' QB64 SINGLE FILE – EXE READY
' =====================================

SCREEN 12
RANDOMIZE TIMER
_TITLE "Dave - Cahit Berkay Edition"

CONST TILE = 20
CONST GRAVITY = .8
CONST JUMP = 12
CONST MAXSPEED = 4
CONST VIEWW = 320
CONST LEVELW = 60
CONST FPS = 60

DIM px!, py!, vx!, vy!
DIM onGround%
px = 150: py = 200

DIM camX!
DIM lives%, score%
lives = 3

DIM level(LEVELW, 14)
DIM ex(3), ey(3), edir(3)

DIM liftX!, liftY!, liftDir!
liftX = 400: liftY = 220: liftDir = -1

DIM anim%, animT%
DIM soundOn%: soundOn = -1

CALL InitLevel
CALL InitEnemies
CALL Intro
CALL LevelJingle

DO
    _LIMIT FPS
    CLS

    CALL InputControl
    CALL Physics
    CALL Camera

    CALL DrawParallax
    CALL DrawLevel

    CALL UpdateLift
    CALL LiftCollision

    CALL UpdateEnemies
    CALL EnemyCollision

    CALL DrawEnemies
    CALL DrawLift
    CALL DrawPlayer
    CALL DrawHUD
    CALL AmbientLoop

    IF lives <= 0 THEN GameOver
LOOP

SUB InputControl
    k$ = INKEY$
    IF k$ = "a" THEN vx = vx - 1
    IF k$ = "d" THEN vx = vx + 1
    IF k$ = " " AND onGround THEN
        vy = -JUMP
        onGround = 0
        SOUND 880, .1
    END IF
    IF k$ = "" THEN vx = vx * .8
    IF vx > MAXSPEED THEN vx = MAXSPEED
    IF vx < -MAXSPEED THEN vx = -MAXSPEED
END SUB

SUB Physics
    vy = vy + GRAVITY
    IF vy > 10 THEN vy = 10
    px = px + vx
    py = py + vy
    onGround = 0
    IF py > 280 THEN
        lives = lives - 1
        ResetPlayer
    END IF
END SUB

SUB Camera
    camX = px - VIEWW / 2
    IF camX < 0 THEN camX = 0
    IF camX > LEVELW * TILE - VIEWW THEN camX = LEVELW * TILE - VIEWW
END SUB

SUB DrawPlayer
    LINE (px - camX, py)-(px - camX + 15, py + 15), 14, BF
    LINE (px - camX, py)-(px - camX + 15, py + 15), 0, B
END SUB

SUB InitLevel
    FOR x = 0 TO LEVELW
        level(x, 13) = 1
    NEXT
END SUB

SUB DrawLevel
    FOR x = camX \ TILE TO (camX + VIEWW) \ TILE
        FOR y = 0 TO 14
            IF level(x, y) = 1 THEN
                LINE (x * TILE - camX, y * TILE)-(x * TILE - camX + 19, y * TILE + 19), 7, BF
            END IF
        NEXT
    NEXT
END SUB

SUB InitEnemies
    FOR i = 1 TO 3
        ex(i) = 300 + i * 120
        ey(i) = 240
        edir(i) = 1
    NEXT
END SUB

SUB UpdateEnemies
    FOR i = 1 TO 3
        ex(i) = ex(i) + edir(i) * 2
        IF RND < .02 THEN edir(i) = -edir(i)
    NEXT
END SUB

SUB DrawEnemies
    FOR i = 1 TO 3
        LINE (ex(i) - camX, ey(i))-(ex(i) - camX + 15, ey(i) + 15), 4, BF
    NEXT
END SUB

SUB EnemyCollision
    FOR i = 1 TO 3
        IF ABS(px - ex(i)) < 14 AND ABS(py - ey(i)) < 14 THEN
            lives = lives - 1
            ResetPlayer
        END IF
    NEXT
END SUB

SUB UpdateLift
    liftY = liftY + liftDir
    IF liftY < 120 OR liftY > 220 THEN liftDir = -liftDir
END SUB

SUB DrawLift
    LINE (liftX - camX, liftY)-(liftX - camX + 40, liftY + 8), 9, BF
END SUB

SUB LiftCollision
    IF px + 12 > liftX AND px < liftX + 40 THEN
        IF py + 16 >= liftY AND py + 16 <= liftY + 6 THEN
            py = liftY - 16
            vy = 0
            onGround = -1
        END IF
    END IF
END SUB

SUB DrawHUD
    LOCATE 1, 1: PRINT "LIVES:"; lives
END SUB

SUB ResetPlayer
    px = 150: py = 200
    vx = 0: vy = 0
END SUB

SUB Intro
    CLS
    SOUND 392, .2: SOUND 440, .2: SOUND 466, .3
    LOCATE 10, 6: PRINT "DAVE - CAHIT BERKAY EDITION"
    LOCATE 12, 8: PRINT "PRESS SPACE"
    DO: LOOP UNTIL INKEY$ = " "
END SUB

SUB LevelJingle
    SOUND 880, .1: SOUND 988, .2
END SUB

SUB AmbientLoop
    STATIC t
    t = t + 1
    IF t MOD 180 = 0 THEN SOUND 196, .1
END SUB

SUB GameOver
    CLS
    SOUND 392, .4: SOUND 330, .6
    LOCATE 12, 12: PRINT "GAME OVER"
    SLEEP 2
    END
END SUB
