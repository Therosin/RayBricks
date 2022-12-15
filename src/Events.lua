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
