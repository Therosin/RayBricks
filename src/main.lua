-- Copyright (C) 2022 Theros < MisModding | SvalTek >
-- 
-- This file is part of BrickGame.
-- 
-- BrickGame is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- BrickGame is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with BrickGame.  If not, see <http://www.gnu.org/licenses/>.
---@diagnostic disable: lowercase-global
local Utils = require "Utils"
local SimpleState = require "SimpleState"
local Events = require "Events"
local JsonData = require "JsonData"
local inspect = require "inspect"
---@type Brick
local Brick = require "Brick"
---@type Paddle
local Paddle = require "Paddle"
---@type Ball
local Ball = require "Ball"
--- Custom Log function
function Log(...) print(string.format("[RayBricks::%s] %s", tostring(GetTime()), string.format(...))) end

--------------------------------------------------------------------------------
--- Game Config
--------------------------------------------------------------------------------
-- ─── General ─────────────────────────────────────────────────────────────────
local screenWidth = 900
local screenHeight = 550
-- ─── Bricks ──────────────────────────────────────────────────────────────────
local brickWidth = 50
local brickHeight = 20
-- ─── Player Paddle ───────────────────────────────────────────────────────────
local paddleLength = 50
local paddleHeight = 10
local paddleColor = DARKBLUE
local defaultPaddleSpeed = 6
local paddleSafeZone = 2
-- ─── Ball ────────────────────────────────────────────────────────────────────
local defaultBallSpeed = 3
local defaultBallDirection = 90
local ballRadius = 8
local ballColor = RED

--------------------------------------------------------------------------------
--- Game Variables
--------------------------------------------------------------------------------
GameEvents = Events.new()

-- ─── Paddle ──────────────────────────────────────────────────────────────────
local paddleSpeed = 6
local paddlePositionX = screenWidth / 2 - paddleLength / 2;
local paddlePositionY = screenHeight - 30;

-- ─── Ball ────────────────────────────────────────────────────────────────────
local ballPositionX = 0;
local ballPositionY = 0;
local ballDirection = 90;
local ballSpeed = 3;
local isBallOnPaddle = false;
local isBallOnScreen = false;

-- ─── Bricks ──────────────────────────────────────────────────────────────────
local brickTypes = require "BrickTypes"
local brickMap = {rows = 8, columns = 12, bricks = {}}
local brickMapWidth = brickMap.columns * brickWidth
local brickMapHeight = brickMap.rows * brickHeight
local brickMapPosX = screenWidth / 2 - brickMapWidth / 2
local brickMapPosY = 40

local GameMenu = require "GameMenus"
local InputMaps = require "InputMaps"
--------------------------------------------------------------------------------
--- Game State
--------------------------------------------------------------------------------

GameState = SimpleState({
	["GameStart"] = function(state)
		-- disable input
		state:Set("GamePlay.InputEnabled", false)
		--- Generate a new level
		GameEvents:fire("LevelGenerate")
		--- Reset the game state
		GameEvents:fire("GameReset")
		--- Start the game
		state("InGame")
	end,
	["GameOver"] = function(state)
		state:Set("GamePlay.InputMap", InputMaps.Menu)
		state:Set("GamePlay.InputEnabled", true)
	end,
	["InGame"] = function(state)
		state:Set("GamePlay.InputMap", InputMaps.GamePlay)
		state:Set("GamePlay.InputEnabled", true)
		GameEvents:fire("GamePlay:ReleasePaddle")
	end,
	["GamePaused"] = function(state)
		state:Set("Game.isPaused", true)
	end
}, {
	Game = {
		CurrentMenu = nil,
		CurrentMenuSelection = 1,
		Debug = false,
		isPaused = false,
	},
	GamePlay = {InputEnabled = false, InputMap = {}},
	GameState = {PlayerName = "Player", Level = 1, Score = 0, Lives = 3, HighScores = {}}
})

--------------------------------------------------------------------------------
--- Messages
--------------------------------------------------------------------------------
local gameMessages = {
	MainMenu = [[
	Welcome to BrickGame!
	Press UP / DOWN to select a menu item.
	Press Space to choose.
	Press Escape to exit the game.
	]],
	PauseMenu = [[
	Game Paused!
	Press UP / DOWN to select a menu item.
	Press Space to choose.
	Press Escape to exit the game.
	]],
	GameStart = [[
	Welcome to BrickGame!
	Press Space to start the game.
	Press Escape to exit the game.
	]],
	GameOver = [[
	Game Over!
	Press Space to restart the game.
	Press Escape to exit the game.
	]],
	GameWin = [[
	You Win!
	Press Space to restart the game.
	Press Escape to exit the game.
	]],
	About = [[
	BrickGame is a simple game written in Lua using Raylib.
	
	Author: Theros
	GitHub: https://github.com/therosin/RayBricks
	]]
}

local logMessages = {
	GameStart = "Game Started.",
	GameOver = "Game Over - Score: '%d'.",
	GameWin = "Game Won: Score: '%d'.",
	GameExit = "Game Shutting Down... Reason: '%s'.",
	GameReset = "Resetting Game State.",
	ShowAboutScreen = "Showing About Screen...",
	HideAboutScreen = "Hiding About Screen..."
}

--------------------------------------------------------------------------------
--- Game Menus
--------------------------------------------------------------------------------
local GameMenus = {}

local MainMenu = GameMenu("MainMenu", gameMessages.MainMenu, 20, 150, 50, 600, 400)
GameMenus["MainMenu"] = MainMenu
MainMenu:AddOption("StartGame", "Start Game", 20):SetAction(function()
	Log("Starting Game...")
	-- GameState:Set("Game.CurrentMenu", nil)
	GameEvents:fire("GameStart")
end)

MainMenu:AddOption("ShowAboutScreen", "About", 20):SetAction(function()
	Log("Showing About Screen...")
	GameEvents:fire("ShowAboutScreen")
end)

MainMenu:AddOption("ExitGame", "Exit Game", 20):SetAction(function()
	Log("Quitting Game...")
	GameEvents:fire("GameQuit", "User Exit")
end)

local AboutScreen = GameMenu("AboutScreen", gameMessages.About, 20, 150, 50, 600, 400)
GameMenus["AboutScreen"] = AboutScreen
AboutScreen:AddOption("HideAboutScreen", "Back", 20, nil, 270):SetAction(function()
	Log("Returning to Main Menu...")
	GameEvents:fire("HideAboutScreen")
end)

local PauseMenu = GameMenu("PauseMenu", gameMessages.PauseMenu, 20, 150, 50, 600, 400)
GameMenus["PauseMenu"] = PauseMenu
PauseMenu:AddOption("ResumeGame", "Resume Game", 20):SetAction(function()
	Log("Resuming Game...")
	GameEvents:fire("GameResume")
end)

PauseMenu:AddOption("ExitGame", "Exit Game", 20):SetAction(function()
	Log("Quitting Game...")
	GameEvents:fire("GameQuit", "User Exit")
end)

local GameOverMenu = GameMenu("GameOverMenu", gameMessages.GameOver, 20, 150, 50, 600, 400)
GameMenus["GameOverMenu"] = GameOverMenu
GameOverMenu:AddOption("RestartGame", "Restart Game", 20):SetAction(function()
	Log("Restarting Game...")
	GameEvents:fire("GameReset")
	GameEvents:fire("GameStart")
end)

--------------------------------------------------------------------------------
--- Game Events
--------------------------------------------------------------------------------

GameEvents:register("GameStart", function()
	GameState:Set("Game.CurrentMenu", nil)
	GameState("GameStart")
end)

GameEvents:register("GamePause", function()
	GameState:Set("GamePlay.InputEnabled", false)
	GameEvents:fire("ShowPauseMenu")
end)

GameEvents:register("GameResume", function()
	GameState:Set("Game.CurrentMenu", nil)
	GameState("InGame")
end)

GameEvents:register("GameReset", function()
	GameState:Set("GamePlay.InputEnabled", false)
	GameEvents:fire("PaddleReset")
	GameEvents:fire("BallReset")
	GameEvents:fire("Player:ResetScore")
	GameEvents:fire("Player:ResetLives")
	GameEvents:fire("LevelGenerate")
end)

GameEvents:register("Player:ResetScore", function()
	GameState:Set("GameState.Score", 0)
end)

GameEvents:register("Player:ResetLives", function()
	GameState:Set("GameState.Lives", 3)
end)

GameEvents:register("Player:GiveLife", function(amount)
	GameState:Set("GameState.Lives", GameState:Get("GameState.Lives") + (amount or 1))
end)

GameEvents:register("Player:Kill", function()
	GameState:Set("GameState.Lives", GameState:Get("GameState.Lives") - 1)
	GameEvents:fire("GameReset")
end)

GameEvents:register("Player:Score", function(amount)
	GameState:Set("GameState.Score", GameState:Get("GameState.Score") + (amount or 1))
end)

GameEvents:register("GameOver", function()
	GameState("GameOver")
	GameEvents:fire("ShowGameOverScreen")
end)

GameEvents:register("GameSave", function()
	--- disable input while saving
	GameState:Set("GamePlay.InputEnabled", false)
	local gameData = {
		PlayerName = GameState:Get("GameState.PlayerName"),
		Level = GameState:Get("GameState.Level"),
		Score = GameState:Get("GameState.Score"),
		Lives = GameState:Get("GameState.Lives"),
		HighScores = GameState:Get("GameState.HighScores")
	}
	JsonData:Save("./game-save.json", gameData)
end)

GameEvents:register("GameLoad", function()
	--- disable input while loading
	GameState:Set("GamePlay.InputEnabled", false)
	local gameData = JsonData:Load("./game-save.json")
	if gameData then
		GameState:Set("GameState.PlayerName", gameData.PlayerName)
		GameState:Set("GameState.Level", gameData.Level)
		GameState:Set("GameState.Score", gameData.Score)
		GameState:Set("GameState.Lives", gameData.Lives)
		GameState:Set("GameState.HighScores", gameData.HighScores)
	end
end)

GameEvents:register("GameQuit", function(reason)
	GameState:Set("GamePlay.InputEnabled", false)
	print("Game Quit:", reason)
	CloseWindow()
end)

GameEvents:register("ShowMainMenu", function()
	GameState:Set("GamePlay.InputMap", InputMaps.Menu)
	GameState:Set("GamePlay.InputEnabled", true)
	GameState:Set("Game.CurrentMenu", "MainMenu")
end)

GameEvents:register("HideMainMenu", function()
	GameState:Set("GamePlay.InputMap", InputMaps.GamePlay)
	GameState:Set("GamePlay.InputEnabled", true)
	GameState:Set("Game.CurrentMenu", nil)
end)

GameEvents:register("ShowAboutScreen", function()
	GameState:Set("GamePlay.InputMap", InputMaps.Menu)
	GameState:Set("Game.CurrentMenu", "AboutScreen")
end)

GameEvents:register("HideAboutScreen", function()
	GameState:Set("GamePlay.InputMap", InputMaps.Menu)
	GameState:Set("Game.CurrentMenu", "MainMenu")
end)

GameEvents:register("ShowPauseMenu", function()
	GameState:Set("GamePlay.InputMap", InputMaps.Menu)
	GameState("GamePaused")
	GameState:Set("Game.CurrentMenu", "PauseMenu")
	GameState:Set("GamePlay.InputEnabled", true)
end)

GameEvents:register("ShowGameOverScreen", function()
	GameState:Set("GamePlay.InputMap", InputMaps.Menu)
	GameState:Set("Game.CurrentMenu", "GameOverMenu")
	GameState:Set("GamePlay.InputEnabled", true)
end)

GameEvents:register("Menu:MoveUp", function()
	local currentMenuSelection = GameState:Get("Game.CurrentMenuSelection")
	GameState:Set("Game.CurrentMenuSelection", currentMenuSelection - 1)
end)

GameEvents:register("Menu:MoveDown", function()
	local currentMenuSelection = GameState:Get("Game.CurrentMenuSelection")
	GameState:Set("Game.CurrentMenuSelection", currentMenuSelection + 1)
end)

GameEvents:register("Menu:Select", function()
	local currentMenu = GameState:Get("Game.CurrentMenu")
	local currentMenuSelection = GameState:Get("Game.CurrentMenuSelection")
	local menu = GameMenus[currentMenu] ---@type GameMenu.Menu
	if menu then menu:SetSelectedOptionByIndex(currentMenuSelection):ExecuteSelectedOption() end
	GameState:Set("Game.CurrentMenuSelection", 1)
end)

--------------------------------------------------------------------------------

--- generate bricks
local OnBrickHit = function(brick)
	Log("Brick Hit %s, %s is %s - Health %s", brick.row, brick.column, brick.type.Kind, brick.health)
end

local OnBrickDestroy = function(brick)
	Log("Brick Destroyed %s, %s is %s - Health %s", brick.row, brick.column, brick.type.Kind, brick.health)
	local score = GameState:Get("GameState.Score")
	GameState:Set("GameState.Score", score + brick.type.Score)
	ballSpeed = ballSpeed + 0.5
	paddleSpeed = paddleSpeed + 0.2
end

local function generateBricks()
	brickMap.bricks = {}
	local rowCount = brickMap.rows
	--- multiplier is used to increase brick chances, its based on the number of rows
	local multiplier = 0.4
	if rowCount > 5 then multiplier = 0.7 end
	--- higher numbered rows have lower quality bricks

	for iRow = 1, rowCount do
		local row = {}
		for i = 1, brickMap.columns do
			local brickType = Utils.RandomWeightedChoice(brickTypes, multiplier)
			local brick = Brick(iRow, i, brickWidth, brickHeight, brickType, OnBrickHit, OnBrickDestroy)
			Log("Generated Brick %s, %s is %s", brick.row, brick.column, brick.type.Kind)
			table.insert(row, brick)
		end
		Log("Generated Row %s: %i bricks", iRow, #row)
		table.insert(brickMap.bricks, row)
	end
end

GameEvents:register("LevelGenerate", function()
	GameState:Set("GamePlay.InputEnabled", false)
	generateBricks()
	GameState:Set("GamePlay.InputEnabled", true)
end)

GameEvents:register("BrickDestroyed", function(destroyedBrick)
	local brickScore = destroyedBrick.Score
	local score = GameState:Get("GameState.Score")
	GameState:Set("GameState.Score", score + brickScore)

	local bricksRemaining = 0
	for rowIdx, row in ipairs(brickMap.bricks) do
		for colIdx, brick in ipairs(row) do
			if brick.Health > 0 then bricksRemaining = bricksRemaining + 1 end
		end
	end
	if bricksRemaining == 0 then
		GameEvents:fire("LevelComplete")
	end
end)

--- draw bricks
function drawBricks(x, y)
	--- x,y is the position of the top left corner of the brick map
	for rowIdx, row in ipairs(brickMap.bricks) do
		for colIdx, brick in ipairs(row) do
			local brickPosX = x + (brick.length * brick.column)
			local brickPosY = y + (brick.height * brick.row)
			DrawRectangle(brickPosX, brickPosY, brick.length, brick.height, brick.colour)
			DrawRectangleLines(brickPosX, brickPosY, brick.length, brick.height, brick.outlineColour)
		end
	end
end

-- check if the ball is colliding with a brick
local function checkBrickCollision(ball)
	for rowIdx, row in ipairs(brickMap.bricks) do
		for colIdx, brick in ipairs(row) do
			local brickPosX = brickMapPosX + (brick.length * brick.column)
			local brickPosY = brickMapPosY + (brick.height * brick.row)
			local brickRect = Rectangle(brickPosX, brickPosY, brick.length, brick.height)
			if CheckCollisionCircleRec(ball.position, ball.radius, brickRect) then
				if brick.isAlive then
					brick:Hit()
					-- deflect the ball off the brick
					ballDirection = (ballDirection + math.random(-5, 5)) * -1
					return true, string.format("Ball collided with brick %s, %s", brick.row, brick.column)
				end
			end
		end
	end
end

-- ─── Playerpaddle ────────────────────────────────────────────────────────────
local playerPaddle = Paddle:new(paddlePositionX, paddlePositionY, paddleLength, paddleHeight, paddleColor, paddleSpeed, paddleSafeZone)

local function drawPlayerPaddle()
	--  Draw the players paddle
	DrawRectangleV(playerPaddle.position, playerPaddle.size, playerPaddle.colour)
	return string.format("Paddle Position: X:%i Y:%i isFrozen:%s", playerPaddle.position.x, playerPaddle.position.y, tostring(playerPaddle.isFrozen))
end

--- check paddle collision
--- if the paddle hits a wall it will bounce back in the opposite direction
function checkPaddleCollision()
	if (playerPaddle.position.x + paddleLength > screenWidth) then
		playerPaddle.isOnRightWall = true
		playerPaddle.position.x = screenWidth - paddleLength - 5
		return
	elseif (playerPaddle.position.x < 0) then
		playerPaddle.isOnLeftWall = true
		playerPaddle.position.x = 5
		return
	end
	playerPaddle.isOnRightWall = false
	playerPaddle.isOnLeftWall = false
end

GameEvents:register("GamePlay:MoveLeft", function()
	playerPaddle:MoveLeft()
end)

GameEvents:register("GamePlay:MoveRight", function()
	playerPaddle:MoveRight()
end)

GameEvents:register("GamePlay:FreezePaddle", function()
	playerPaddle:Freeze()
end)

GameEvents:register("GamePlay:ReleasePaddle", function()
	playerPaddle:UnFreeze()
end)

GameEvents:register("PaddleReset", function()
	paddleSpeed = defaultPaddleSpeed
	playerPaddle:ResetPosition()
end)

-- ─── Playerball ──────────────────────────────────────────────────────────────
local playerBall = Ball:new(ballRadius, ballColor, ballSpeed)

GameEvents:register("GamePlay:FreezeBall", function()
	playerBall:Freeze()
end)

GameEvents:register("GamePlay:ReleaseBall", function()
	playerBall:Unfreeze()
end)

GameEvents:register("BallReset", function()
	ballSpeed = defaultBallSpeed
	ballDirection = defaultBallDirection
	ballPositionX = paddlePositionX + paddleLength / 2;
	ballPositionY = paddlePositionY - ballRadius - 2;
	playerBall:Move(ballPositionX, ballPositionY)
	GameEvents:fire("GamePlay:FreezeBall")
end)


local function drawPlayerBall(direction, speed, colour)
	local angle = math.rad(direction)
	local ballX, ballY = playerBall.position.x, playerBall.position.y

	if playerBall.isFrozen then
		--- move the players ball to the center of the paddle
		local paddleX = playerPaddle.position.x
		ballX = paddleX + paddleLength / 2
		playerBall.position = Vector2(ballX, ballY)
	else
		ballX = ballX + speed * math.cos(angle)
		ballY = ballY - speed * math.sin(angle)
		playerBall:Move(ballX, ballY)
	end

	--- Draw the players ball at its new position
	DrawCircleV(playerBall.position, playerBall.radius, colour)
	return string.format("Ball Position: X:%s Y:%s isFrozen: %s", tostring(ballX), tostring(ballY), tostring(playerBall.isFrozen))
end

--- check ball collision
local function checkBallCollision()
	local paddlePosition = playerPaddle.position
	local ballPosition = playerBall.position
	local collision;

	paddleRect = Rectangle(paddlePosition.x, paddlePosition.y, paddleLength + paddleSafeZone, paddleHeight)

	-- check if ball hits paddle
	if CheckCollisionCircleRec(playerBall.position, ballRadius, paddleRect) then
		collision = "Paddle"
		isBallOnPaddle = true
		-- deflect the ball off the paddle based on where it hits
		---ballDirection = playerBall:CalculateBounceAngle(playerPaddle)
		ballDirection = (360 - ballDirection) + Ball:CalculateBounceAngle(playerPaddle) % 360
	else
		isBallOnPaddle = false
	end

	-- check if ball hits walls
	if (ballPosition.x + ballRadius > screenWidth) then -- if ball hits right wall
		collision = "RightWall"
		ballDirection = (180 - ballDirection) + math.random(-5, 5)
	elseif (ballPosition.x - ballRadius < 0) then -- if ball hits left wall
		collision = "LeftWall"
		ballDirection = (180 - ballDirection) + math.random(-5, 5)
	elseif (ballPosition.y - ballRadius < 0) then -- if ball hits top wall
		collision = "TopWall"
		ballDirection = (360 - ballDirection) + math.random(-5, 5)
	elseif (ballPosition.y + ballRadius) > screenHeight then -- if ball hits bottom wall
		collision = "BottomWall"
		isBallOnScreen = false
		local playerLives = GameState:Get("GameState.Lives") - 1
		GameState:Set("GameState.Lives", playerLives)
		if (playerLives > 0) then
			Log("Player lost a life, %i lives remain", playerLives)
			GameEvents:fire("BallReset")
			GameEvents:fire("PaddleReset")
		else
			Log("Player has no lives left, game over")
			GameEvents:fire("GameOver")
		end
	end

	return string.format("Ball Colliding: %s Ball Direction: %s", tostring(collision), tostring(ballDirection))
end

-- ─── Scores ──────────────────────────────────────────────────────────────────
local function drawScores()
	Utils.DrawTextBox(10, 10, 160, 40, Fade(DARKBLUE, 0.5), SKYBLUE, 13, {
		-- 1st line
		string.format("- Current Score: %i", GameState:Get("GameState.Score")),
		-- 2nd line
		string.format("- Lives Remain : %i", GameState:Get("GameState.Lives"))
	}, RAYWHITE)
end

local function drawDebug()
	Utils.DrawTextBox(10, 60, 185, 250, Fade(DARKBLUE, 0.6), SKYBLUE, 16, {
		-- 1st line
		string.format("- Ball Pos: %s, %s", tostring(playerBall.position.x), tostring(playerBall.position.y)),
		-- 2nd line
		string.format("- Ball Dir: %s", tostring(ballDirection)),
		-- 3rd line
		string.format("- Ball Speed: %s", tostring(ballSpeed)),
		-- 4th line
		string.format("- Ball Radius: %s", tostring(ballRadius)),
		-- 5th line
		string.format("- Ball OnPaddle: %s", tostring(isBallOnPaddle)),
		-- 6th line
		string.format("- Paddle Pos: %s", tostring(playerPaddle.position.x)),
		-- 7th line
		string.format("- Paddle Length: %s", tostring(playerPaddle.size.x)),
		-- 8th line
		string.format("- Paddle Speed: %s", tostring(paddleSpeed)),
		-- 9th line
		string.format("- Paddle R Wall: %s", tostring(playerPaddle.isOnRightWall)),
		-- 10th line
		string.format("- Paddle L Wall: %s", tostring(playerPaddle.isOnLeftWall)),
		-- 11th line
		string.format("- Ball OnScreen: %s", tostring(isBallOnScreen)),
		-- 12th line
		string.format("- InputEnabled: %s", tostring(GameState:Get("GamePlay.InputEnabled"))),
		-- 13th line
		string.format("- CurrentMenu: %s", tostring(GameState:Get("Game.CurrentMenu"))),
		-- 14th line
		string.format("- MenuSelection: %s", tostring(GameState:Get("Game.CurrentMenuSelection"))),
	}, RAYWHITE)
end

local function drawMenu()
	local currentMenu = GameState:Get("Game.CurrentMenu")
	local currentMenuSelection = GameState:Get("Game.CurrentMenuSelection")
	print(currentMenu)
	print(currentMenuSelection)
	if not currentMenu then return end
	if currentMenu == "MainMenu" then
		return pcall(MainMenu.Draw, MainMenu, currentMenuSelection)
	elseif currentMenu == "PauseMenu" then
		return pcall(PauseMenu.Draw, PauseMenu, currentMenuSelection)
	elseif currentMenu == "AboutScreen" then
		return pcall(AboutScreen.Draw, AboutScreen, currentMenuSelection)
	elseif currentMenu == "GameOverMenu" then
		return pcall(GameOverMenu.Draw, GameOverMenu, currentMenuSelection)
	end

end

local function HandleInput()
	local input, inputType;
	if GameState:Get("GamePlay.InputEnabled") then
		local InputHandler = GameState:Get("GamePlay.InputMap")
		if InputHandler then input, inputType = InputHandler() end
	else
		input, inputType = false, "Input Disabled"
	end
	-- ─── Debug ─────────── ─────────────────────────────────────────────────────
	if (IsKeyDown(KEY_F11)) then
		input = true
		inputType = "Debug"
		local isDebug = not GameState:Get("Game.Debug")
		GameState:Set("Game.Debug", isDebug)
	end
	return input, inputType
end

-- ─── Main Loop ────────────────────────────────────────────────────────────────
local function MainLoop()
	while not WindowShouldClose() do
		HideCursor()
		print("INPUT:", HandleInput())
		-- ─── Drawing ─────────────────────────────────────────────────────────
		BeginDrawing()
		ClearBackground(RAYWHITE)
		if (GameState:Get("Game.Debug")) then drawDebug() end
		drawMenu()
		if (GameState() == "InGame") then
			drawBricks(brickMapPosX, brickMapPosY)
			drawPlayerPaddle()
			checkPaddleCollision()
			checkBallCollision()
			checkBrickCollision(playerBall)
			drawPlayerBall(ballDirection, ballSpeed, ballColor)
			drawScores()
		end
		EndDrawing()
	end
end

-- ─── Main ─────────────────────────────────────────────────────────────────────
InitWindow(screenWidth, screenHeight, "Bricks")
SetTargetFPS(60)
GameEvents:fire("ShowMainMenu")
MainLoop()
CloseWindow();
