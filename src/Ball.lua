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
local _M = {
    _VERSION = "0.0.1",
    _DESCRIPTION = "BrickGame Ball class",
    _AUTHOR = "Theros < MisModding | SvalTek >",
}

---@class Ball
--- Simple BrickGame Ball class
---@field new fun(self,radius: number, colour: any, speed: number):Ball
---@field radius    number      # Ball radius
---@field colour     any         # Ball colour
---@field speed     number      # Ball speed
---@field position  Vector2     # Ball position
---@field isFrozen  boolean     # Ball is frozen
---@overload fun(self,radius: number, colour: any, speed: number):Ball
local Ball = setmetatable({}, {
    __name = "Ball",
    __tostring = function(self)
        return getmetatable(self).__name
    end,
    __call = function(self, ...)
        local instance = setmetatable({}, {
            __index = self,
            __name = "Instance<Ball>",
            __tostring = function(i)
                return getmetatable(i).__name
            end
        })
        return instance:new(...)
    end
})
-- ─── Ball Constructor ────────────────────────────────────────────────────
function Ball:new(radius, colour, speed)
    self.radius = radius
    self.colour = colour
    self.speed = speed
    self.position = Vector2(0, 0)
    self.isFrozen = false
    return self
end

-- ─── Ball Methods ───────────────────────────────────────────────────────

function Ball:Move(x,y)
    if not self.isFrozen then
        self.position.x = x
        self.position.y = y
    end
end

function Ball:Freeze()
    self.isFrozen = true
end

function Ball:Unfreeze()
    self.isFrozen = false
end

--- Calculate the angle the ball should bounce off the paddle
---@param paddle Paddle
---@return number
function Ball:CalculateBounceAngle(paddle)
    local paddleMiddle = paddle.position.x + (paddle.size.x / 2)
    local ballMiddle = self.position.x
    local distanceFromMiddle = (ballMiddle - paddleMiddle)
    local angle = distanceFromMiddle / (paddle.size.x / 2)
    if not GameState:Get("Game.Debug") then
        print(string.format("Ball middle: %s, Paddle middle: %s, DistanceFromMiddle: %s, Angle: %s", ballMiddle, paddleMiddle, distanceFromMiddle, angle))
    end
    return angle * -90
end


return Ball
