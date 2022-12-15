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
---@meta raylib-lua-sol text


--- Draw text
---@param text string
---@param x number
---@param y number
---@param textSize number
---@param textColor any
function DrawText(text, x, y, textSize, textColor) end

--- Draw text using a Vector2
---@param text string
---@param position Vector2
---@param textSize number
---@param textColor any
function DrawTextV(text, position, textSize, textColor) end
