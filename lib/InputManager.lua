--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 Robert Machmer                                             --
--                                                                               --
-- This software is provided 'as-is', without any express or implied             --
-- warranty. In no event will the authors be held liable for any damages         --
-- arising from the use of this software.                                        --
--                                                                               --
-- Permission is granted to anyone to use this software for any purpose,         --
-- including commercial applications, and to alter it and redistribute it        --
-- freely, subject to the following restrictions:                                --
--                                                                               --
--  1. The origin of this software must not be misrepresented; you must not      --
--      claim that you wrote the original software. If you use this software     --
--      in a product, an acknowledgment in the product documentation would be    --
--      appreciated but is not required.                                         --
--  2. Altered source versions must be plainly marked as such, and must not be   --
--      misrepresented as being the original software.                           --
--  3. This notice may not be removed or altered from any source distribution.   --
--                                                                               --
--===============================================================================--

local InputManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local map;

local gpCommands = {};
local keyCommands = {};

local gamepad;
local threshold = 0.3;

-- ------------------------------------------------
-- Local functions
-- ------------------------------------------------

---
-- @param axis
--
local function getAxisValue(axis)
    local lX = gamepad:getGamepadAxis('leftx');
    if axis == 'lXLeft' then
        return lX < 0 and -lX or 0;
    elseif axis == 'lXRight' then
        return lX > 0 and lX or 0;
    end

    local lY = gamepad:getGamepadAxis('lefty');
    if axis == 'lYUp' then
        return lY < 0 and -lY or 0;
    elseif axis == 'lYDown' then
        return lY > 0 and lY or 0;
    end

    local rX = gamepad:getGamepadAxis('rightx');
    if axis == 'rXLeft' then
        return rX < 0 and -rX or 0;
    elseif axis == 'rXRight' then
        return rX > 0 and rX or 0;
    end

    local rY = gamepad:getGamepadAxis('righty');
    if axis == 'rYUp' then
        return rY < 0 and -rY or 0;
    elseif axis == 'rYDown' then
        return rY > 0 and rY or 0;
    end

    if axis == 'lTrigger' then
        return gamepad:getGamepadAxis('triggerleft');
    end

    if axis == 'rTrigger' then
        return gamepad:getGamepadAxis('triggerright');
    end
end

---
--
local function updateGamepadAxes()
    for axis, map in pairs(map.gamepad.axes) do
        map.value = getAxisValue(axis);
        if not map.rep then
            if map.value > threshold and map.locked == false then
                map.locked = true;
                gpCommands[map.cmd] = true;
            elseif map.locked == true then
                gpCommands[map.cmd] = nil;
                if map.value < threshold then
                    map.locked = false;
                end
            end
        else
            if map.value > threshold then
                gpCommands[map.cmd] = true;
            else
                gpCommands[map.cmd] = nil;
            end
        end
    end
end

---
--
local function updateGamepadButtons()
    for button, map in pairs(map.gamepad.buttons) do
        if not map.rep then
            if gamepad:isGamepadDown(button) and map.locked == false then
                map.locked = true;
                gpCommands[map.cmd] = true;
            elseif map.locked == true then
                gpCommands[map.cmd] = nil;
                if not gamepad:isGamepadDown(button) then
                    map.locked = false;
                end
            else
                gpCommands[map.cmd] = nil;
            end
        else
            if gamepad:isGamepadDown(button) then
                gpCommands[map.cmd] = true;
            else
                gpCommands[map.cmd] = nil;
            end
        end
    end
end

---
--
local function updateKeyboardButtons()
    for button, map in pairs(map.keyboard) do
        if not map.rep then
            if love.keyboard.isDown(button) and map.locked == false then
                map.locked = true;
                keyCommands[map.cmd] = true;
            elseif map.locked == true then
                keyCommands[map.cmd] = nil;
                if not love.keyboard.isDown(button) then
                    map.locked = false;
                end
            else
                keyCommands[map.cmd] = nil;
            end
        else
            if love.keyboard.isDown(button) then
                keyCommands[map.cmd] = true;
            else
                keyCommands[map.cmd] = nil;
            end
        end
    end
end

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

---
-- Update the input. If a gamepad is connected we will
-- only use the gamepad's input, else we are going to use
-- the keyboard.
--
function InputManager.update()
    if gamepad then
        updateGamepadAxes();
        updateGamepadButtons();
    end
    updateKeyboardButtons();
end

---
-- A debug drawing function which shows all input.
--
function InputManager.draw()
    local cnt = 0;
    for i, v in pairs(keyCommands) do
        cnt = cnt + 1;
        love.graphics.print(i .. " " .. tostring(v), 20, 100 + cnt * 20);
    end
end

---
-- Use the joystick's input if one is connected.
-- @param joystick
--
function InputManager.addJoystick(joystick)
    gamepad = joystick;
end

---
-- Deactivate joystick.
-- @param joystick
--
function InputManager.removeJoystick(joystick)
    if joystick == gamepad then
        gamepad = nil;
    end
end

function InputManager.clear()
    keyCommands = {};
    gpCommands = {};
end

-- ------------------------------------------------
-- Getters
-- ------------------------------------------------

---
-- Use this to look for active commands.
-- @param cmd
--
function InputManager.hasCommand(cmd)
    if gpCommands[cmd] or keyCommands[cmd] then
        return true;
    else
        return false;
    end
end

function InputManager.setMap(nmap)
    map = nmap;
end

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

return InputManager;

--==================================================================================================
-- Created 13.07.14 - 22:02                                                                        =
--==================================================================================================