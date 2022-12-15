---@diagnostic disable: undefined-global
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
---@class Paddle
--- Simple BrickGame Paddle class
---@field initialPosition Vector2
---@field position Vector2
---@field size Vector2
---@field colour any
---@field speed number
---@field safeZone number
---@field isFrozen boolean
---@field isOnLeftWall boolean
---@field isOnRightWall boolean
---@overload fun(self,...):Paddle
local Paddle = setmetatable({}, {
	__name = "Paddle",
	__tostring = function(self) return getmetatable(self).__name end,
	__call = function(self, ...)
		local instance = setmetatable({}, {__index = self, __name = "Instance<Paddle>", __tostring = function(i) return getmetatable(i).__name end})
		return instance:new(...)
	end
})

-- ─── Paddle Constructor ────────────────────────────────────────────────────
---@param x number
---@param y number
---@param Length number
---@param Height number
---@param Color? any
---@param Speed? number
---@param SafeZone? number
function Paddle:new(x, y, Length, Height, Color, Speed, SafeZone)
	self.initialPosition = Vector2(x, y)
	self.position = Vector2(x, y)
    self.size = Vector2(Length, Height)
	self.colour = Color or WHITE
	self.speed = Speed or 5
	self.safeZone = SafeZone or 3
	self.isFrozen = false
	self.isOnLeftWall = false
	self.isOnRightWall = false
	return self
end

-- ─── Paddle Methods ───────────────────────────────────────────────────────

--- Move the paddle to the left
---@param speedMult? number
function Paddle:MoveLeft(speedMult)
	if not self.isFrozen then if not self.isOnLeftWall then self.position.x = self.position.x - self.speed * (speedMult or 1) end end
end

--- Move the paddle to the right
---@param speedMult? number
function Paddle:MoveRight(speedMult)
	if not self.isFrozen then if not self.isOnRightWall then self.position.x = self.position.x + self.speed * (speedMult or 1) end end
end

function Paddle:Grow(px,py)
    self.size = self.size + Vector2(px, py)
end

function Paddle:Shrink(px,py)
    self.size = self.size - Vector2(px, py)
end

function Paddle:ResetSize()
    self.size = Vector2(100, 20)
end

function Paddle:ResetPosition()
    self.position = self.initialPosition
end

function Paddle:Reset()
	self:ResetSize()
	self:ResetPosition()
end

function Paddle:Freeze() self.isFrozen = true end

function Paddle:UnFreeze() self.isFrozen = false end

function Paddle:setColour(color) self.colour = color end

return Paddle
