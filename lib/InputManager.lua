--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

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
    for i, v in pairs(gpCommands) do
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