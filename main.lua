---@diagnostic disable: undefined-global

local screenWidth = 900
local screenHeight = 550

InitWindow(screenWidth, screenHeight, "Bricks")
SetTargetFPS(60)


-- ─── Game Variables ────────────────────────────────────────────────────────────
local gameScore = 0
local playerLives = 3

-- ─── Player Ball ─────────────────────────────────────────────────────────────
local ballPosition = Vector2(screenWidth/2, screenHeight/2)
local ballSpeed = Vector2(0, 0)
local ballRadius = 50
local ballColor = Color(255, 0, 0, 255)

-- ─── Bricks ───────────────────────────────────────────────────────────────────
local brickWidth = 50
local brickHeight = 20
--- brick colours format is {brickColor, outlineColor}
local brickColours = {
    {RED, BLACK},
    {BLUE, BLACK},
    {GREEN, BLACK},
    {YELLOW, BLACK},
    {ORANGE, BLACK},
}




--- generate bricks
local brickMap = {
    rows = 5, columns = 8,
    bricks = {}
}

for i = 1, brickMap.rows do
    for j = 1, brickMap.columns do
        local brick = {
            x = brickWidth + (j - 1) * brickWidth, -- x position of brick
            y = brickWidth + (i - 1) * brickHeight, -- y position of brick
            width = brickWidth, -- width of brick in pixels
            height = brickHeight, -- height of brick in pixels
            color = brickColours[i][1],
            outlineColor = brickColours[i][2],
            isAlive = true
        }
        table.insert(brickMap.bricks, brick)
    end
end

--- draw bricks
function drawBricks(x,y)
    --- x,y is the position of the top left corner of the brick map
    for i = 1, #brickMap.bricks do
        local brick = brickMap.bricks[i]
        if not brick.isAlive then break end
        DrawRectangle(x + brick.x, y + brick.y, brick.width+2, brick.height+2, brick.color)
        DrawRectangleLines(x + brick.x, y + brick.y, brick.width+2, brick.height+2, brick.outlineColor)
    end
end









-- has the player started the game
local player_start = false


-- ─── Player Paddle ───────────────────────────────────────────────────────────
local paddlePositionX = screenWidth/2
local paddlePositionY = 35
local paddleLength = 100
local paddleColor = DARKBLUE
local paddleSpeed = 1
local isPaddleOnRightWall = false
local isPaddleOnLeftWall = false

--- draw paddle
function drawPaddle(x, len)
    DrawRectangle(x, screenHeight - paddlePositionY, len, 30, paddleColor)
end

--- check paddle collision
--- if the paddle hits a wall it will bounce back in the opposite direction
function checkPaddleCollision()
    if (paddlePositionX + paddleLength > screenWidth) then
        isPaddleOnRightWall = true
        paddlePositionX = screenWidth - paddleLength - 5
        return
    elseif (paddlePositionX < 0) then
        isPaddleOnLeftWall = true
        paddlePositionX = 5
        return
    end
    isPaddleOnRightWall = false
    isPaddleOnLeftWall = false
end

-- ─── Ball ────────────────────────────────────────────────────────────────────
local ballPosition = Vector2(paddlePositionX + paddleLength/2, screenHeight - 50)
local ballSpeed = 0
local ballRadius = 15
local ballColor = RED
-- direction of ball in degrees with 0 being right and 90 being up
local ballDirection = 45
local isBallOnPaddle = true

--- draw ball
function drawBall(direction, speed, color)
    local angle = math.rad(direction)

    ballPosition.x = ballPosition.x + speed * math.cos(angle)
    ballPosition.y = ballPosition.y - speed * math.sin(angle)

    DrawCircleV(ballPosition, ballRadius, color)
end

--- check ball collision
function checkBallCollision()

    -- check if ball hits paddle
    if (ballPosition.y + ballRadius > screenHeight - 40) then
        if (ballPosition.x > paddlePositionX and ballPosition.x < paddlePositionX + paddleLength) then
            isBallOnPaddle = true
            ballDirection = 360 - ballDirection
        else
            isBallOnPaddle = false
        end
    end

    if (ballPosition.x + ballRadius > screenWidth) then -- if ball hits right wall
        ballDirection = 180 - ballDirection
    elseif (ballPosition.x - ballRadius < 0) then -- if ball hits left wall
        ballDirection = 180 - ballDirection
    elseif (ballPosition.y - ballRadius < 0) then -- if ball hits top wall
        ballDirection = 360 - ballDirection
    elseif (ballPosition.y + ballRadius > screenHeight) then -- if ball hits bottom wall
        playerLives = playerLives - 1
        resetGame()
    end
end


-- ─── Scores ──────────────────────────────────────────────────────────────────

function drawScores()
    DrawRectangle( 10, 10, 160, 40, Fade(DARKBLUE, 0.5))
    DrawRectangleLines( 10, 10, 160, 40, SKYBLUE)

    DrawText(string.format("- Current Score: %i", gameScore), 10, 15, 16, RAYWHITE)
    DrawText(string.format("- Lives Remain : %i", playerLives), 10, 30, 16, RAYWHITE)
end



local showGameStart = true
function drawGameStart()
    if (not showGameStart) then return end
    DrawRectangle(screenWidth/2 - 210, screenHeight/2 - 20, 410, 40, Fade(DARKBLUE, 0.5))
    DrawRectangleLines(screenWidth/2 - 210, screenHeight/2 - 20, 410, 40, SKYBLUE)
    DrawText("PRESS SPACE TO START", screenWidth/2 - 205, screenHeight/2 - 15, 30, RAYWHITE)
end


function resetGame()
    -- reset ball
    ballPosition = Vector2(paddlePositionX + paddleLength/2, screenHeight - 50)
    ballSpeed = 0
    --- reset paddle
    paddlePositionX = screenWidth/2
    showGameStart = true
    player_start = false
end




local isDebug = false

function drawDebug()
    DrawRectangle( 10, 60, 180, 190, Fade(DARKBLUE, 0.5))
    DrawRectangleLines( 10, 60, 180, 190, SKYBLUE)
    DrawText(string.format("- Ball Pos: %s, %s", tostring(ballPosition.x), tostring(ballPosition.y)), 10, 65, 16, RAYWHITE)
    DrawText(string.format("- Ball Dir: %i", ballDirection), 10, 80, 16, RAYWHITE)
    DrawText(string.format("- Ball Speed: %i", ballSpeed), 10, 95, 16, RAYWHITE)
    DrawText(string.format("- Ball Radius: %i", ballRadius), 10, 110, 16, RAYWHITE)
    DrawText(string.format("- Ball OnPaddle: %s", tostring(isBallOnPaddle)), 10, 125, 16, RAYWHITE)
    DrawText(string.format("- Paddle Pos: %i", paddlePositionX), 10, 140, 16, RAYWHITE)
    DrawText(string.format("- Paddle Length: %i", paddleLength), 10, 155, 16, RAYWHITE)
    DrawText(string.format("- Paddle Speed: %i", paddleSpeed), 10, 170, 16, RAYWHITE)
    DrawText(string.format("- Paddle R Wall: %s", tostring(isPaddleOnRightWall)), 10, 185, 16, RAYWHITE)
    DrawText(string.format("- Paddle L Wall: %s", tostring(isPaddleOnLeftWall)), 10, 200, 16, RAYWHITE)
end






while not WindowShouldClose() do
    --- Update ---
    if (IsKeyDown(KEY_RIGHT)) then paddlePositionX = paddlePositionX + 3 * paddleSpeed end
    if (IsKeyDown(KEY_LEFT)) then paddlePositionX = paddlePositionX - 3 * paddleSpeed end
    if (not player_start) then
        if (IsKeyDown(KEY_SPACE)) then
            player_start = true
            ballSpeed = 2
            showGameStart = false
        end

        --- make the ball move with the paddle
        ballPosition.x = paddlePositionX + paddleLength/2
    end

    --- super not secret debug screen
    if (IsKeyDown(KEY_F1)) then isDebug = not isDebug end

    BeginDrawing()
        if (isDebug) then drawDebug() end
        ClearBackground(RAYWHITE)
        drawBricks(screenWidth/5.5,20)
        checkPaddleCollision()
        drawPaddle(paddlePositionX, paddleLength)
        checkBallCollision()
        drawBall(ballDirection, ballSpeed, ballColor)
        drawScores()
        drawGameStart()
    EndDrawing()
end
CloseWindow()
