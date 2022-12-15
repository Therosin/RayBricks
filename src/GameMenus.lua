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
