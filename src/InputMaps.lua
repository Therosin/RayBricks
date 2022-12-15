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
