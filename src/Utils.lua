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
