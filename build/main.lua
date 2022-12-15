_G['package'] = { preload = {} };function require(pkg) return package.preload[pkg]() end; 
do
local _ENV = _ENV
package.preload[ "Ball" ] = function( ... ) local arg = _G.arg;
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
    return angle
end


return Ball
end
end

do
local _ENV = _ENV
package.preload[ "Brick" ] = function( ... ) local arg = _G.arg;
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
end
end

do
local _ENV = _ENV
package.preload[ "BrickTypes" ] = function( ... ) local arg = _G.arg;
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
return {
	{Kind = "Lightweight", Health = 1, Colour = GRAY, OutlineColour = BLACK, weight = 0.5, Score = 1},
	{Kind = "Normal", Health = 2, Colour = DARKGRAY, OutlineColour = BLACK, weight = 0.3, Score = 1},
	{Kind = "Heavy", Health = 3, Colour = BROWN, OutlineColour = BLACK, weight = 0.2, Score = 2},
	{Kind = "Hardened", Health = 4, Colour = DARKBROWN, OutlineColour = DARKGRAY, weight = 0.2, Score = 3},
	{Kind = "Super", Health = 5, Colour = GOLD, OutlineColour = DARKBROWN, weight = 0.1, Score = 5}
}
end
end

do
local _ENV = _ENV
package.preload[ "Events" ] = function( ... ) local arg = _G.arg;
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
    _DESCRIPTION = "A simple event system for Lua",
    _VERSION = "0.1.0",
    _AUTHOR = "Theros < MisModding | SvalTek >",
}

---@return Events
function _M.new()
    ---@class Events
    local self = {}
    local events = {}

    function self:register(event, callback)
        if not events[event] then
            events[event] = {}
        end
        table.insert(events[event], callback)
    end

    function self:unregister(event, callback)
        if not events[event] then
            return
        end
        for i, evt in ipairs(events[event]) do
            if evt == callback then
                table.remove(events[event], i)
                break
            end
        end
    end

    function self:fire(event, ...)
        if not events[event] then
            return
        end
        for i, evt in ipairs(events[event]) do
            evt(...)
        end
    end

    return self
end

return _M
end
end

do
local _ENV = _ENV
package.preload[ "GameMenus" ] = function( ... ) local arg = _G.arg;
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

local function addVector2(a, b)
    return Vector2(a.x + b.x, a.y + b.y)
end

local function subVector2(a, b)
    return Vector2(a.x - b.x, a.y - b.y)
end



---@class GameMenu.MenuOption
---@field name string
---@field position Vector2
---@field size Vector2
---@field background Color
---@field border Color
---@field borderWidth number
---@field text string
---@field textColour Color
---@field textSize number
---@field action function
---@overload fun(self, name:string, text?: string, textSize?:number, x?:number, y?:number, width?: number, height?: number ):GameMenu.MenuOption
local MenuOption = setmetatable({}, {
    __name = "GameMenu.MenuOption",
    __tostring = function(self)
        return getmetatable(self).__name
    end,
    __call = function(self, ...)
        local instance = setmetatable({}, {
            __index = self,
            __name = "Instance<GameMenu.MenuOption>",
            __tostring = function(i)
                return getmetatable(i).__name
            end
        })
        return instance:new(...)
    end
})

-- ─── GameMenu.MenuOption Constructor ────────────────────────────────────────────────────
function MenuOption:new(name, text, textSize, x, y, width, height)
    self.name = name
    self.position = Vector2(x or 0, y or 0)
    self.text = text or "MENU_OPTION_TEXT_UNSET"
    self.textColour = RAYWHITE
    self.textSize = textSize or 20
    --- use the provided height or calculate it from the text size + 10
    height = height or self.textSize + 10
    self.size = Vector2(width or 200, height)
    self.background = Fade(BLUE, 0.5)
    self.borderColour = SKYBLUE
    self.borderWidth = 1
    self.selectedBorderColour = RED
    self.action = function()
        Log("Menu Option Action Unset for: %s", self.name)
    end
    return self
end

--- Set The Text of the menu option
---@param text string
---@return GameMenu.MenuOption
function MenuOption:SetText(text)
    self.text = text
    return self
end

--- Set the text size of the menu option
---@param textSize number
---@return GameMenu.MenuOption
function MenuOption:SetTextSize(textSize)
    self.textSize = textSize
    return self
end

--- Set the text colour of the menu option
---@param colour Color
---@return GameMenu.MenuOption
function MenuOption:SetTextColour(colour)
    self.textColour = colour
    return self
end

--- Set the position of the menu option
---@param x number
---@param y number
---@return GameMenu.MenuOption
function MenuOption:SetPosition(x, y)
    self.position = Vector2(x, y)
    return self
end

--- Set the size of the menu option
---@param width number
---@param height number
---@return GameMenu.MenuOption
function MenuOption:SetSize(width, height)
    self.size = Vector2(width, height)
    return self
end

--- Set the action to be performed when the option is selected
---@param action function
---@return GameMenu.MenuOption
function MenuOption:SetAction(action)
    self.action = action
    return self
end

--- Set the background colour of the menu option
---@param colour Color
---@return GameMenu.MenuOption
function MenuOption:SetBackgroundColour(colour)
    self.background = colour
    return self
end

--- Set the border colour of the menu option
---@param colour Color
---@return GameMenu.MenuOption
function MenuOption:SetBorderColour(colour)
    self.borderColour = colour
    return self
end

function MenuOption:SetSelectedBorderColour(colour)
    self.selectedBorderColour = colour
    return self
end

--- Set the border width of the menu option
---@param width number
---@return GameMenu.MenuOption
function MenuOption:SetBorderWidth(width)
    self.borderWidth = width
    return self
end

--- Draw the menu option
---@param selected boolean
function MenuOption:Draw(selected)
    local debugMenuOption = GameState:Get("Game.Debug")
    if debugMenuOption then
        print(string.format("Drawing Menu Option: %s posX: %s posY: %s sizeX: %s sizeY: %s background: %s border: %s borderWidth: %s",
            self.name,
            self.position.x,
            self.position.y,
            self.size.x,
            self.size.y,
            ColorToInt(self.background),
            ColorToInt(self.borderColour),
            self.borderWidth
        ))
    end
    DrawRectangleRec(Rectangle(self.position.x, self.position.y, self.size.x, self.size.y), self.background)
    if debugMenuOption then
        print(string.format("Drawing Menu Option Border: %s posX: %s posY: %s sizeX: %s sizeY: %s border: %s borderWidth: %s",
            self.name,
            self.position.x,
            self.position.y,
            self.size.x,
            self.size.y,
            ColorToInt(self.borderColour),
            self.borderWidth
        ))
    end
    DrawRectangleLinesEx(Rectangle(self.position.x, self.position.y, self.size.x, self.size.y), self.borderWidth, selected and self.selectedBorderColour or self.borderColour)
    if debugMenuOption then
        print(string.format("Drawing Menu Option Text: %s posX: %s posY: %s sizeX: %s sizeY: %s text: %s textColour: %s textSize: %s",
            self.name,
            self.position.x,
            self.position.y,
            self.size.x,
            self.size.y,
            self.text,
            ColorToInt(self.textColour),
            self.textSize
        ))
    end
    DrawText(self.text, self.position.x + self.size.x / 2 - MeasureText(self.text, self.textSize) / 2, self.position.y + self.size.y / 2 - self.textSize / 2, self.textSize, self.textColour)
end


---@class GameMenu.Menu
---@field name string
---@field position Vector2
---@field size Vector2
---@field background Color
---@field border Color
---@field borderWidth number
---@field text string
---@field textColour Color
---@field textSize number
---@field options GameMenu.MenuOption[]
---@field selectedOption? number
---@field selectedBorderColour Color
---@overload fun(name:string, text?: string, textSize?:number, x?:number, y?:number, width?: number, height?: number ):GameMenu.Menu
local Menu = setmetatable({}, {
    __name = "GameMenu.Menu",
    __tostring = function(self)
        return getmetatable(self).__name
    end,
    __call = function(self, ...)
        local instance = setmetatable({}, {
            __index = self,
            __name = "Instance<GameMenu.Menu>",
            __tostring = function(i)
                return getmetatable(i).__name
            end
        })
        return instance:new(...)
    end
})

-- ─── GameMenu.Menu Constructor ────────────────────────────────────────────────────
function Menu:new(name, text, textSize, x, y, width, height)
    self.name = name
    self.position = Vector2(x or 0, y or 0)
    --- use the provided width or calculate it from the text length and size + 10
    width = width or MeasureText(self.text, self.textSize) + 10
    --- use the provided height or calculate it from the text size + 10
    height = height or self.textSize + 10
    self.size = Vector2(width, height)
    self.background = Fade(BLACK, 0.5)
    self.borderColour = RAYWHITE
    self.borderWidth = 2
    self.text = text or "MENU_TEXT_UNSET"
    self.textSize = textSize or 20
    self.textColour = RAYWHITE
    self.options = {}
    local MenuCenter = Vector2(self.position.x + self.size.x / 2, self.position.y + self.size.y / 2)
    self.optionOffsetX = subVector2(MenuCenter, Vector2(100,0)).x
    self.optionOffsetY = subVector2(MenuCenter, Vector2(0, self.textSize)).y
    self.selectedOption = nil
    return self
end

--- Set The Text of the menu
---@param text string
---@return GameMenu.Menu
function Menu:SetText(text)
    self.text = text
    return self
end

--- Set the text size of the menu
---@param textSize number
---@return GameMenu.Menu
function Menu:SetTextSize(textSize)
    self.textSize = textSize
    return self
end

--- Set the text colour of the menu
---@param colour Color
---@return GameMenu.Menu
function Menu:SetTextColour(colour)
    self.textColour = colour
    return self
end

--- Set the position of the menu
---@param x number
---@param y number
---@return GameMenu.Menu
function Menu:SetPosition(x, y)
    self.position = Vector2(x, y)
    return self
end

--- Set the size of the menu
---@param width number
---@param height number
---@return GameMenu.Menu
function Menu:SetSize(width, height)
    self.size = Vector2(width, height)
    return self
end

--- Set the background colour of the menu
---@param colour Color
---@return GameMenu.Menu
function Menu:SetBackgroundColour(colour)
    self.background = colour
    return self
end

--- Set the border colour of the menu
---@param colour Color
---@return GameMenu.Menu
function Menu:SetBorderColour(colour)
    self.borderColour = colour
    return self
end

--- Set the border width of the menu
---@param width number
---@return GameMenu.Menu
function Menu:SetBorderWidth(width)
    self.borderWidth = width
    return self
end

--- Create a new menu option and add it to the menu
---@return GameMenu.MenuOption
function Menu:AddOption(name, text, textSize, x, y, width, height)
    local position = Vector2(x or self.optionOffsetX, y or self.optionOffsetY)
    local option = MenuOption(name, text, textSize, position.x, position.y, width, height)
    self.optionOffsetY = self.optionOffsetY + option.size.y + 1
    table.insert(self.options, option)
    return option
end

--- Remove a menu option from the menu
---@param name string
---@return GameMenu.MenuOption?
function Menu:RemoveOption(name)
    for i, option in ipairs(self.options) do
        if option.name == name then
            table.remove(self.options, i)
            self.optionOffsetY = self.optionOffsetY - option.size.y
            return option
        end
    end
end

--- Get a menu option from the menu
---@param name string
---@return GameMenu.MenuOption?
function Menu:GetOption(name)
    for _, option in ipairs(self.options) do
        if option.name == name then
            return option
        end
    end
end

--- Get the index of a menu option from the menu
---@param name string
---@return number?
function Menu:GetOptionIndex(name)
    for i, option in ipairs(self.options) do
        if option.name == name then
            return i
        end
    end
end

--- Get an option from the menu by index
---@param index number
---@return GameMenu.MenuOption?
function Menu:GetOptionByIndex(index)
    return self.options[index]
end

--- Get the number of options in the menu
---@return number
function Menu:GetOptionCount()
    return #self.options
end

--- Set the selected option of the menu
---@param name string
---@return GameMenu.Menu
function Menu:SetSelectedOption(name)
    self.selectedOption = self:GetOptionIndex(name)
    return self
end

--- Set the selected option of the menu by index
---@param index number
---@return GameMenu.Menu
function Menu:SetSelectedOptionByIndex(index)
    self.selectedOption = index
    return self
end

--- Get the selected option of the menu
---@return GameMenu.MenuOption?
function Menu:GetSelectedOption()
    return self:GetOptionByIndex(self.selectedOption)
end

--- execute the selected option
---@return GameMenu.Menu
function Menu:ExecuteSelectedOption()
    local option = self:GetSelectedOption()
    if option then
        option:action()
    end
    return self
end

--- Draw the menu
---@return GameMenu.Menu
function Menu:Draw(menuSelection)
    local debugMenu = GameState:Get("Game.Debug")
    if menuSelection ~= nil then
        self:SetSelectedOptionByIndex(menuSelection)
    end
    if debugMenu then
        print(string.format("Drawing Menu: %s posX: %s posY: %s sizeX: %s sizeY: %s background: %s border: %s borderWidth: %s",
            self.name,
            self.position.x,
            self.position.y,
            self.size.x,
            self.size.y,
            ColorToInt(self.background),
            ColorToInt(self.borderColour),
            self.borderWidth
        ))
    end
    DrawRectangleV(self.position, self.size, self.background)
    if debugMenu then
        print(string.format("Drawing Menu Border: %s posX: %s posY: %s sizeX: %s sizeY: %s border: %s borderWidth: %s",
            self.name,
            self.position.x,
            self.position.y,
            self.size.x,
            self.size.y,
            ColorToInt(self.borderColour),
            self.borderWidth
        ))
    end
    DrawRectangleLinesEx(
        Rectangle(self.position.x, self.position.y, self.size.x, self.size.y),
        self.borderWidth,
        self.borderColour
    )
    local textPosition = addVector2(self.position,Vector2(15, 15))
    if debugMenu then
        print(string.format("Drawing Menu Text: %s posX: %s posY: %s size: %s colour: %s",
            self.name,
            textPosition.x,
            textPosition.y,
            self.textSize,
            ColorToInt(self.textColour)
        ))
    end
    DrawText(self.text, textPosition.x, textPosition.y, self.textSize, self.textColour)
    for _, option in ipairs(self.options) do
        option:Draw(self.selectedOption == self:GetOptionIndex(option.name))
    end
    return self
end  

return Menu
end
end

do
local _ENV = _ENV
package.preload[ "InputMaps" ] = function( ... ) local arg = _G.arg;
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

return {
	Menu = function()
        --- Menu Selection
        if (IsKeyPressed(KEY_SPACE)) then
            GameEvents:fire("Menu:Select")
            return true, "Menu:Select"
        elseif (IsKeyPressed(KEY_UP)) then
            GameEvents:fire("Menu:MoveUp")
            return true, "Menu:MoveUp"
        elseif (IsKeyPressed(KEY_DOWN)) then
            GameEvents:fire("Menu:MoveDown")
            return true, "Menu:MoveDown"
        end

        --- Quit Game
        if (IsKeyPressed(KEY_ESCAPE)) then
            GameEvents:fire("GameQuit", "User Requested Quit")
            return true, "GameQuit"
        end
        return false, "no input"
    end,
	GamePlay = function()
        --- Player Movement
        if (IsKeyPressed(KEY_SPACE)) then
            GameEvents:fire("GamePlay:ReleaseBall")
            return true, "GamePlay:ReleaseBall"
        elseif (IsKeyDown(KEY_LEFT)) then
            GameEvents:fire("GamePlay:MoveLeft")
            return true, "GamePlay:MoveLeft"
        elseif (IsKeyDown(KEY_RIGHT)) then
            GameEvents:fire("GamePlay:MoveRight")
            return true, "GamePlay:MoveRight"
        end

        --- Regenerate Level
        if (IsKeyPressed(KEY_R)) then
            GameEvents:fire("LevelGenerate")
            return true, "LevelGenerate"
        end

        --- Pause Game
        if (IsKeyPressed(KEY_F1)) then
            GameEvents:fire("GamePause")
            return true, "GamePause"
        end
        return false, "no input"
	end
}
end
end

do
local _ENV = _ENV
package.preload[ "JsonData" ] = function( ... ) local arg = _G.arg;
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

local function JsonEnc(t)
    local function serialize(tbl)
        local tmp = {}
        for k, v in pairs(tbl) do
            local key = type(k) == "number" and "[" .. k .. "]" or k
            local val = type(v) == "table" and serialize(v) or type(v) == "string" and '"' .. v .. '"' or v
            tmp[#tmp + 1] = key .. "=" .. val
        end
        return "{" .. table.concat(tmp, ",") .. "}"
    end
    return serialize(t)
end

local function JsonDEC(json)
    local function deserialize(str)
        local tbl = {}
        for k, v in string.gmatch(str, "([%w_]+)=([%w_]+)") do
            tbl[k] = v
        end
        return tbl
    end
    return deserialize(json)
end

local JsonData = {}

function JsonData:New()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end


function JsonData:Load(path)
    local enc_data = LoadFileText(path)
    local data = false
    if enc_data then
        data = DecodeDataBase64(enc_data, #enc_data)
    end 
    return data and JsonDEC(data)
end

function JsonData:Save(path, data)
    data = JsonEnc(data)
    local enc_data = EncodeDataBase64(data, #data)
    SaveFileText(path, enc_data)
end


return JsonData
end
end

do
local _ENV = _ENV
package.preload[ "Paddle" ] = function( ... ) local arg = _G.arg;
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
end
end

do
local _ENV = _ENV
package.preload[ "SimpleState" ] = function( ... ) local arg = _G.arg;
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
local _M = {__DESCRIPTION = "Super Simple State Machine", __VERSION = "0.1.0", __AUTHOR = "Theros < MisModding | SvalTek >"}

local function split(str, sep)
	local fields = {}
	local pattern = string.format("([^%s]+)", sep)
	str:gsub(pattern, function(c) fields[#fields + 1] = c end)
	return fields
end

-- ─── SimpleState ───────────────────────────────────────────────────────────────
--[[
    SimpleState is a simple state machine that can be used to manage the state of
    a game object. It is designed to be used with the RayBricks game, but
    can be used with any Lua project.

    Usage:
    local SimpleState = require("SimpleState")

    GameState = SimpleState({
        StartGame = function(state, playerName, playerSave)
            local settings = state:LoadSettings(playerName, playerSave)
            state("LoadLevel", settings)
        end,
        LoadLevel = function(state, settings)
            game:LoadLevel(settings.level)
            game:StartLevel(settings.playerName, settings.playerSave)
        end,
        EndGame = function(state,...)
            game:EndGame(...)
        end,
    })

    GameState:Set("Settings.Debug", true)
    GameState("StartGame", "Theros", "Save1")
]]

---@class SimpleState
--- Simple State Machine
---@field new fun(...):SimpleState
---@field Get fun(self,key:string):any  # Get a value from the state cache
---@field Set fun(self,key:string, value:any) # Set a value in the state cache
---@overload fun(self,...):SimpleState
local SimpleState = setmetatable({}, {
	__name = "SimpleState",
	__tostring = function(self) return getmetatable(self).__name end,
	__call = function(self, ...)
		local instance = setmetatable({}, {__index = self, __name = "Instance<SimpleState>", __tostring = function(i) return getmetatable(i).__name end})
		return instance:new(...)
	end
})

-- ─── SimpleState Constructor ────────────────────────────────────────────────────
function SimpleState:new(schema, cache)
	local state = {}
	for k, v in pairs(schema) do state[k] = v end
	local state_cache = {}
	for k, v in pairs(cache) do state_cache[k] = v end
	local CurrentState = nil

	local instance = {}
	setmetatable(instance, {
		__index = self,
		__call = function(inst, ...)
			local args = {...}
			if #args == 0 then return CurrentState end
			local state_name = args[1]
			if state[state_name] then
				table.remove(args, 1)
				CurrentState = state_name
				state[state_name](inst, table.unpack(args))
			else
				error("State '" .. state_name .. "' does not exist")
			end
		end
	})

	function instance:Get(key)
		local keys = split(key, ".")
		local value = state_cache
		for _, k in ipairs(keys) do
			value = value[k]
			if not value then return nil end
		end
		return value
	end

	function instance:Set(key, value)
		local keys = split(key, ".")
		local cache = state_cache
		for i, k in ipairs(keys) do
			if i == #keys then
				cache[k] = value
			else
				cache[k] = cache[k] or {}
				cache = cache[k]
			end
		end
	end

	return instance
end

----- tests
-- local GameState = SimpleState({
-- 	StartGame = function(state, playerName, playerSave) state("LoadLevel", {level = 1, playerName = playerName, playerSave = playerSave}) end,
-- 	LoadLevel = function(state, settings)
-- 		print(state(), settings.level, settings.playerName, settings.playerSave)
-- 		state("EndGame", 100, "You Win!")
-- 	end,
-- 	EndGame = function(state, score, message) print(state(), "Score: " .. tostring(score), message) end
-- }, {Settings = {Debug = false}})

-- GameState:Set("Settings.Debug", true)
-- GameState("StartGame", "Theros", "Save1")
-- print(GameState:Get("Settings.Debug"))
-- print(GameState())

return setmetatable(_M, {__call = function(_, ...) return SimpleState(...) end})
end
end

do
local _ENV = _ENV
package.preload[ "Utils" ] = function( ... ) local arg = _G.arg;
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
    _DESCRIPTION = "RayBricks Utils",
    _VERSION = "0.0.1",
    _AUTHOR = "Theros < MisModding | SvalTek >",
}


function _M.DrawTextBox(x, y, width, height, backgroundColor, outlineColor, textSize, text, textColour)
	DrawRectangle(x, y, width, height, backgroundColor)
	DrawRectangleLines(x, y, width, height, outlineColor)
	if type(text) == "table" then
		for i = 1, #text do
			DrawText(text[i], x + 10, y + 10 + (textSize * (i - 1)), textSize, textColour)
		end
	else
		DrawText(text, x + 10, y + 10, textSize, textColour)
	end
end


--- Randomly choose a weighted choice from a table of choices
-- you can optionally pass a multiplier to increase the weight of each choice
--- @param choices table
--- @param multiplier? number
--- @return table
function _M.RandomWeightedChoice(choices, multiplier)
	local totalWeight = 0
	for _, choice in pairs(choices) do
		totalWeight = totalWeight + (choice.weight * (multiplier or 1))
	end
	local random = math.random() * totalWeight
	local choice = nil
	for _, choice in pairs(choices) do
		random = random - (choice.weight * (multiplier or 1))
		if random <= 0 then
			return choice
		end
	end
	return choice
end

return _M
end
end

do
local _ENV = _ENV
package.preload[ "inspect" ] = function( ... ) local arg = _G.arg;
local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local math = _tl_compat and _tl_compat.math or math; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table
local inspect = {Options = {}, }

















inspect._VERSION = 'inspect.lua 3.1.0'
inspect._URL = 'http://github.com/kikito/inspect.lua'
inspect._DESCRIPTION = 'human-readable representations of tables'
inspect._LICENSE = [[
  MIT LICENSE

  Copyright (c) 2022 Enrique García Cota

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
inspect.KEY = setmetatable({}, { __tostring = function() return 'inspect.KEY' end })
inspect.METATABLE = setmetatable({}, { __tostring = function() return 'inspect.METATABLE' end })

local tostring = tostring
local rep = string.rep
local match = string.match
local char = string.char
local gsub = string.gsub
local fmt = string.format

local function rawpairs(t)
   return next, t, nil
end



local function smartQuote(str)
   if match(str, '"') and not match(str, "'") then
      return "'" .. str .. "'"
   end
   return '"' .. gsub(str, '"', '\\"') .. '"'
end


local shortControlCharEscapes = {
   ["\a"] = "\\a", ["\b"] = "\\b", ["\f"] = "\\f", ["\n"] = "\\n",
   ["\r"] = "\\r", ["\t"] = "\\t", ["\v"] = "\\v", ["\127"] = "\\127",
}
local longControlCharEscapes = { ["\127"] = "\127" }
for i = 0, 31 do
   local ch = char(i)
   if not shortControlCharEscapes[ch] then
      shortControlCharEscapes[ch] = "\\" .. i
      longControlCharEscapes[ch] = fmt("\\%03d", i)
   end
end

local function escape(str)
   return (gsub(gsub(gsub(str, "\\", "\\\\"),
   "(%c)%f[0-9]", longControlCharEscapes),
   "%c", shortControlCharEscapes))
end

local function isIdentifier(str)
   return type(str) == "string" and not not str:match("^[_%a][_%a%d]*$")
end

local flr = math.floor
local function isSequenceKey(k, sequenceLength)
   return type(k) == "number" and
   flr(k) == k and
   1 <= (k) and
   k <= sequenceLength
end

local defaultTypeOrders = {
   ['number'] = 1, ['boolean'] = 2, ['string'] = 3, ['table'] = 4,
   ['function'] = 5, ['userdata'] = 6, ['thread'] = 7,
}

local function sortKeys(a, b)
   local ta, tb = type(a), type(b)


   if ta == tb and (ta == 'string' or ta == 'number') then
      return (a) < (b)
   end

   local dta = defaultTypeOrders[ta] or 100
   local dtb = defaultTypeOrders[tb] or 100


   return dta == dtb and ta < tb or dta < dtb
end

local function getKeys(t)

   local seqLen = 1
   while rawget(t, seqLen) ~= nil do
      seqLen = seqLen + 1
   end
   seqLen = seqLen - 1

   local keys, keysLen = {}, 0
   for k in rawpairs(t) do
      if not isSequenceKey(k, seqLen) then
         keysLen = keysLen + 1
         keys[keysLen] = k
      end
   end
   table.sort(keys, sortKeys)
   return keys, keysLen, seqLen
end

local function countCycles(x, cycles)
   if type(x) == "table" then
      if cycles[x] then
         cycles[x] = cycles[x] + 1
      else
         cycles[x] = 1
         for k, v in rawpairs(x) do
            countCycles(k, cycles)
            countCycles(v, cycles)
         end
         countCycles(getmetatable(x), cycles)
      end
   end
end

local function makePath(path, a, b)
   local newPath = {}
   local len = #path
   for i = 1, len do newPath[i] = path[i] end

   newPath[len + 1] = a
   newPath[len + 2] = b

   return newPath
end


local function processRecursive(process,
   item,
   path,
   visited)
   if item == nil then return nil end
   if visited[item] then return visited[item] end

   local processed = process(item, path)
   if type(processed) == "table" then
      local processedCopy = {}
      visited[item] = processedCopy
      local processedKey

      for k, v in rawpairs(processed) do
         processedKey = processRecursive(process, k, makePath(path, k, inspect.KEY), visited)
         if processedKey ~= nil then
            processedCopy[processedKey] = processRecursive(process, v, makePath(path, processedKey), visited)
         end
      end

      local mt = processRecursive(process, getmetatable(processed), makePath(path, inspect.METATABLE), visited)
      if type(mt) ~= 'table' then mt = nil end
      setmetatable(processedCopy, mt)
      processed = processedCopy
   end
   return processed
end

local function puts(buf, str)
   buf.n = buf.n + 1
   buf[buf.n] = str
end



local Inspector = {}










local Inspector_mt = { __index = Inspector }

local function tabify(inspector)
   puts(inspector.buf, inspector.newline .. rep(inspector.indent, inspector.level))
end

function Inspector:getId(v)
   local id = self.ids[v]
   local ids = self.ids
   if not id then
      local tv = type(v)
      id = (ids[tv] or 0) + 1
      ids[v], ids[tv] = id, id
   end
   return tostring(id)
end

function Inspector:putValue(v)
   local buf = self.buf
   local tv = type(v)
   if tv == 'string' then
      puts(buf, smartQuote(escape(v)))
   elseif tv == 'number' or tv == 'boolean' or tv == 'nil' or
      tv == 'cdata' or tv == 'ctype' then
      puts(buf, tostring(v))
   elseif tv == 'table' and not self.ids[v] then
      local t = v

      if t == inspect.KEY or t == inspect.METATABLE then
         puts(buf, tostring(t))
      elseif self.level >= self.depth then
         puts(buf, '{...}')
      else
         if self.cycles[t] > 1 then puts(buf, fmt('<%d>', self:getId(t))) end

         local keys, keysLen, seqLen = getKeys(t)

         puts(buf, '{')
         self.level = self.level + 1

         for i = 1, seqLen + keysLen do
            if i > 1 then puts(buf, ',') end
            if i <= seqLen then
               puts(buf, ' ')
               self:putValue(t[i])
            else
               local k = keys[i - seqLen]
               tabify(self)
               if isIdentifier(k) then
                  puts(buf, k)
               else
                  puts(buf, "[")
                  self:putValue(k)
                  puts(buf, "]")
               end
               puts(buf, ' = ')
               self:putValue(t[k])
            end
         end

         local mt = getmetatable(t)
         if type(mt) == 'table' then
            if seqLen + keysLen > 0 then puts(buf, ',') end
            tabify(self)
            puts(buf, '<metatable> = ')
            self:putValue(mt)
         end

         self.level = self.level - 1

         if keysLen > 0 or type(mt) == 'table' then
            tabify(self)
         elseif seqLen > 0 then
            puts(buf, ' ')
         end

         puts(buf, '}')
      end

   else
      puts(buf, fmt('<%s %d>', tv, self:getId(v)))
   end
end




function inspect.inspect(root, options)
   options = options or {}

   local depth = options.depth or (math.huge)
   local newline = options.newline or '\n'
   local indent = options.indent or '  '
   local process = options.process

   if process then
      root = processRecursive(process, root, {}, {})
   end

   local cycles = {}
   countCycles(root, cycles)

   local inspector = setmetatable({
      buf = { n = 0 },
      ids = {},
      cycles = cycles,
      depth = depth,
      level = 0,
      newline = newline,
      indent = indent,
   }, Inspector_mt)

   inspector:putValue(root)

   return table.concat(inspector.buf)
end

setmetatable(inspect, {
   __call = function(_, root, options)
      return inspect.inspect(root, options)
   end,
})

return inspect
end
end

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
local paddleHeight = 20
local paddleColor = DARKBLUE
local paddleSpeed = 5
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
local paddlePositionX = screenWidth / 2 - paddleLength / 2;
local paddlePositionY = screenHeight - 50;
local isPaddleOnRightWall;
local isPaddleOnLeftWall;

-- ─── Ball ────────────────────────────────────────────────────────────────────
local ballPositionX = 0;
local ballPositionY = 0;
local ballDirection = 90;
local ballSpeed = 3;
local isBallOnPaddle = false;
local isBallOnScreen = false;

-- ─── Bricks ──────────────────────────────────────────────────────────────────
local brickTypes = require "BrickTypes"
local brickMap = {rows = 5, columns = 8, bricks = {}}
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
	local score = GameState:Get("GameState.Score")
	GameState:Set("GameState.Score", score + brick.type.Score)
	ballSpeed = ballSpeed + 0.5
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

	-- check if ball hits paddle
	if (ballPosition.y + ballRadius > paddlePosition.y + 1) then
		if (ballPosition.x > paddlePosition.x - paddleSafeZone and ballPosition.x < (paddlePosition.x + paddleLength) + paddleSafeZone) then
			collision = "Paddle"
			isBallOnPaddle = true
			-- deflect the ball off the paddle based on where it hits
			ballDirection = playerBall:CalculateBounceAngle(playerPaddle)
		else
			isBallOnPaddle = false
		end
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
	local GameState = GameState:Get("GameState")
	Utils.DrawTextBox(10, 60, 185, 190, Fade(DARKBLUE, 0.6), SKYBLUE, 16, {
		-- 1st line
		string.format("- Ball Pos: %s, %s", tostring(ballPositionX), tostring(ballPositionX)),
		-- 2nd line
		string.format("- Ball Dir: %i", ballDirection),
		-- 3rd line
		string.format("- Ball Speed: %i", ballSpeed),
		-- 4th line
		string.format("- Ball Radius: %i", ballRadius),
		-- 5th line
		string.format("- Ball OnPaddle: %s", tostring(isBallOnPaddle)),
		-- 6th line
		string.format("- Paddle Pos: %i", paddlePositionX),
		-- 7th line
		string.format("- Paddle Length: %i", paddleLength),
		-- 8th line
		string.format("- Paddle Speed: %i", paddleSpeed),
		-- 9th line
		string.format("- Paddle R Wall: %s", tostring(isPaddleOnRightWall)),
		-- 10th line
		string.format("- Paddle L Wall: %s", tostring(isPaddleOnLeftWall)),
		-- 11th line
		string.format("- Ball OnScreen: %s", tostring(isBallOnScreen))
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
		if (GameState:Get("GamePlay.Debug")) then drawDebug() end
		print(drawMenu())
		if (GameState() == "InGame") then
			drawBricks(brickMapPosX, brickMapPosY)
			print(drawPlayerPaddle())
			print(checkBallCollision())
			print(checkBrickCollision(playerBall))
			print(drawPlayerBall(ballDirection, ballSpeed, ballColor))
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
