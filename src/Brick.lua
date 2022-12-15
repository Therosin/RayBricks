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
---@class Brick
--- Basic Brick class
---@overload fun(self,...):Brick
local Brick = setmetatable({}, {
	__name = "Brick",
	__tostring = function(self) return getmetatable(self).__name end,
	__call = function(self, ...)
		local instance = setmetatable({}, {__index = self, __name = "Instance<Brick>", __tostring = function(i) return getmetatable(i).__name end})
		return instance:new(...)
	end
})

-- ─── Brick Constructor ────────────────────────────────────────────────────
---@param row number                Brick X (row)
---@param column number             Brick Y (column)
---@param brickLength number        Brick Length
---@param brickHeight number        Brick Height
---@param type table                Brick Type
---@param OnHitCallback function    Brick On Hit Callback method
---@param OnDestroyCallback function Brick On Destroy Callback method
function Brick:new(row, column, brickLength, brickHeight, type, OnHitCallback, OnDestroyCallback)
	self.row = row
	self.column = column
	self.length = brickLength
	self.height = brickHeight
	self.type = type
	self.colour = type['Colour']
	self.outlineColour = type['OutlineColour']
	self.Health = type['Health']
	self.OnHit = OnHitCallback
	self.OnDestroy = OnDestroyCallback
	self.isAlive = true
	return self
end

-- ─── Brick Methods ───────────────────────────────────────────────────────
function Brick:Hit()
	self.Health = self.Health - 1
	if self.Health <= 0 then self:Destroy() end
	--- colour fades in 3 steps, 1/3, 2/3, 3/3
	local fade_level;
	--- work out the percentage of health missing
	local health_percentage = self.Health / self.type['Health']
	-- if 90% health remains fade by 1/3
	if health_percentage >= 0.9 then
		fade_level = 0.8
	-- if 60% health remains fade by 2/3
	elseif health_percentage >= 0.6 then
		fade_level = 0.4
	-- if 30% health remains fade by 3/3
	elseif health_percentage >= 0.3 then
		fade_level = 0.2
	-- if 0% health remains fade by 3/3
	elseif health_percentage >= 0.0 then
		fade_level = 0.0
		self.isAlive = false
	end

	self.colour = Fade(self.type['Colour'], fade_level)
	self.outlineColour = Fade(self.type['OutlineColour'], fade_level)
	return pcall(self.OnHit, self)
end

function Brick:Destroy()
	self.colour = Fade(self.type['Colour'], 0.0)
	self.outlineColour = Fade(self.type['OutlineColour'], 0.0)
	self.noCollide = true
	return pcall(self.OnDestroy, self)
end

return Brick
