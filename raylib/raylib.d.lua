-- Copyright (C) 2022 Theros < MisModding | SvalTek >
-- 
-- This file is part of RayBricks.
-- 
-- RayBricks is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- RayBricks is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with RayBricks.  If not, see <http://www.gnu.org/licenses/>.
---@meta RayLib-Lua-Sol definitions

--- Get time
---@return number
function GetTime() end


--- set the target fps
---@param fps number
function SetTargetFPS(fps) end


--- Init window
---@param width number
---@param height number
---@param title string
function InitWindow(width, height, title) end


--- Wait for window close event
function WindowShouldClose() end


--- Close window
function CloseWindow() end


--- Begin drawing
function BeginDrawing() end


--- End drawing
function EndDrawing() end


--- Clear background
---@param color any
function ClearBackground(color) end

--- Fade color
---@param color any
---@param alpha number
---@return any
function Fade(color, alpha) end


--- Hide the mouse cursor
function HideCursor() end


--- Show the mouse cursor
function ShowCursor() end


---@class Vector2
---@field x number
---@field y number

--- create a new Vector2
--- @param x number
--- @param y number
--- @return Vector2
function Vector2(x, y) end


---@class Vector3
---@field x number
---@field y number
---@field z number

--- create a new Vector3
--- @param x number
--- @param y number
--- @param z number
--- @return Vector3
function Vector3(x, y, z) end

---@class Rectangle
---@field x number
---@field y number
---@field width number
---@field height number

--- Create a new Rectangle
---@param x? number
---@param y? number
---@param width? number
---@param height? number
---@return Rectangle
function Rectangle(x, y, width, height) end


---@alias Texture any
