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
