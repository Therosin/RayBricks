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
---@meta @class raylib.colors

--[[
      // Custom raylib color palette for amazing visuals
    #define LIGHTGRAY  (Color){ 200, 200, 200, 255 }        // Light Gray
    #define GRAY       (Color){ 130, 130, 130, 255 }        // Gray
    #define DARKGRAY   (Color){ 80, 80, 80, 255 }           // Dark Gray
    #define YELLOW     (Color){ 253, 249, 0, 255 }          // Yellow
    #define GOLD       (Color){ 255, 203, 0, 255 }          // Gold
    #define ORANGE     (Color){ 255, 161, 0, 255 }          // Orange
    #define PINK       (Color){ 255, 109, 194, 255 }        // Pink
    #define RED        (Color){ 230, 41, 55, 255 }          // Red
    #define MAROON     (Color){ 190, 33, 55, 255 }          // Maroon
    #define GREEN      (Color){ 0, 228, 48, 255 }           // Green
    #define LIME       (Color){ 0, 158, 47, 255 }           // Lime
    #define DARKGREEN  (Color){ 0, 117, 44, 255 }           // Dark Green
    #define SKYBLUE    (Color){ 102, 191, 255, 255 }        // Sky Blue
    #define BLUE       (Color){ 0, 121, 241, 255 }          // Blue
    #define DARKBLUE   (Color){ 0, 82, 172, 255 }           // Dark Blue
    #define PURPLE     (Color){ 200, 122, 255, 255 }        // Purple
    #define VIOLET     (Color){ 135, 60, 190, 255 }         // Violet
    #define DARKPURPLE (Color){ 112, 31, 126, 255 }         // Dark Purple
    #define BEIGE      (Color){ 211, 176, 131, 255 }        // Beige
    #define BROWN      (Color){ 127, 106, 79, 255 }         // Brown
    #define DARKBROWN  (Color){ 76, 63, 47, 255 }           // Dark Brown

    #define WHITE      (Color){ 255, 255, 255, 255 }        // White
    #define BLACK      (Color){ 0, 0, 0, 255 }              // Black
    #define BLANK      (Color){ 0, 0, 0, 0 }                // Transparent
    #define MAGENTA    (Color){ 255, 0, 255, 255 }          // Magenta
    #define RAYWHITE   (Color){ 245, 245, 245, 255 }        // Ray White
]]

---@class Color
---@field r number
---@field g number
---@field b number
---@field a number

--- Create a new Color
---@param r? number
---@param g? number
---@param b? number
---@param a? number
---@return Color
function Color(r, g, b, a) end

--- Convert a Color to an integer
---@param color Color
---@return number
function ColorToInt(color) end


--- GLOBALY DEFINED COLORS
--- These are defined in raylib.h

-- Color(200, 200, 200, 255) = LIGHTGRAY
_G.LIGHTGRAY = Color(200, 200, 200, 255)

-- Color(130, 130, 130, 255) = GRAY
_G.GRAY = Color(130, 130, 130, 255)

-- Color(80, 80, 80, 255) = DARKGRAY
_G.DARKGRAY = Color(80, 80, 80, 255)

-- Color(253, 249, 0, 255) = YELLOW
_G.YELLOW = Color(253, 249, 0, 255)

-- Color(255, 203, 0, 255) = GOLD
_G.GOLD = Color(255, 203, 0, 255)

-- Color(255, 161, 0, 255) = ORANGE
_G.ORANGE = Color(255, 161, 0, 255)

-- Color(255, 109, 194, 255) = PINK
_G.PINK = Color(255, 109, 194, 255)

-- Color(230, 41, 55, 255) = RED
_G.RED = Color(230, 41, 55, 255)

-- Color(190, 33, 55, 255) = MAROON
_G.MAROON = Color(190, 33, 55, 255)

-- Color(0, 228, 48, 255) = GREEN
_G.GREEN = Color(0, 228, 48, 255)

-- Color(0, 158, 47, 255) = LIME
_G.LIME = Color(0, 158, 47, 255)

-- Color(0, 117, 44, 255) = DARKGREEN
_G.DARKGREEN = Color(0, 117, 44, 255)

-- Color(102, 191, 255, 255) = SKYBLUE
_G.SKYBLUE = Color(102, 191, 255, 255)

-- Color(0, 121, 241, 255) = BLUE
_G.BLUE = Color(0, 121, 241, 255)

-- Color(0, 82, 172, 255) = DARKBLUE
_G.DARKBLUE = Color(0, 82, 172, 255)

-- Color(200, 122, 255, 255) = PURPLE
_G.PURPLE = Color(200, 122, 255, 255)

-- Color(135, 60, 190, 255) = VIOLET
_G.VIOLET = Color(135, 60, 190, 255)

-- Color(112, 31, 126, 255) = DARKPURPLE
_G.DARKPURPLE = Color(112, 31, 126, 255)

-- Color(211, 176, 131, 255) = BEIGE
_G.BEIGE = Color(211, 176, 131, 255)

-- Color(127, 106, 79, 255) = BROWN
_G.BROWN = Color(127, 106, 79, 255)

-- Color(76, 63, 47, 255) = DARKBROWN
_G.DARKBROWN = Color(76, 63, 47, 255)

-- Color(255, 255, 255, 255) = WHITE
_G.WHITE = Color(255, 255, 255, 255)

-- Color(0, 0, 0, 255) = BLACK
_G.BLACK = Color(0, 0, 0, 255)

-- Color(0, 0, 0, 0) = BLANK
_G.BLANK = Color(0, 0, 0, 0)

-- Color(255, 0, 255, 255) = MAGENTA
_G.MAGENTA = Color(255, 0, 255, 255)

-- Color(245, 245, 245, 255) = RAYWHITE
_G.RAYWHITE = Color(245, 245, 245, 255)
