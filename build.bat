@echo off
rem Copyright (C) 2022 Theros < MisModding | SvalTek >
rem 
rem This file is part of RayBricks.
rem 
rem RayBricks is free software: you can redistribute it and/or modify
rem it under the terms of the GNU General Public License as published by
rem the Free Software Foundation, either version 3 of the License, or
rem (at your option) any later version.
rem 
rem RayBricks is distributed in the hope that it will be useful,
rem but WITHOUT ANY WARRANTY; without even the implied warranty of
rem MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem GNU General Public License for more details.
rem 
rem You should have received a copy of the GNU General Public License
rem along with RayBricks.  If not, see <http://www.gnu.org/licenses/>.

setlocal
set MODULES=SimpleState Events JsonData InputMaps GameMenus BrickTypes Brick Paddle Ball Utils inspect
set TOOLS_DIR=%~dp0/tools/
ECHO Using lua-amalg :: %TOOLS_DIR%
set RUN_DIR=%CD%
ECHO Running in :: %RUN_DIR%
set LUA_PATH="%RUN_DIR%/?.lua;%RUN_DIR%/src/?.lua;%RUN_DIR%/src/?/init.lua;%LUA_PATH%"
ECHO Using LUA_PATH :: %LUA_PATH%

rem to output as luac add  -t luac    before the -s flag
%TOOLS_DIR%lua.exe "%TOOLS_DIR%amalg.lua" -o "%RUN_DIR%\build\main.lua" -s %RUN_DIR%\src\main.lua %MODULES%
endlocal

rem package table fix
echo _G['package'] = { preload = {} };function require(pkg) return package.preload[pkg]() end; > .\build\main.lua.tmp
copy .\build\main.lua.tmp+.\build\main.lua .\build\main.lua.combined
move /Y .\build\main.lua.combined .\build\main.lua
del .\build\main.lua.tmp
ECHO :::FINISHED:::
