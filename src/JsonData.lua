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
