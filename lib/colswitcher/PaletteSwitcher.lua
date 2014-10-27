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

local PaletteSwitcher = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local index;
local lut;
local shader;

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

---
-- Circles to the next palette. If the last one is reached
-- it jumps back to the first one.
--
function PaletteSwitcher.next()
    index = index == lut:getHeight() - 1 and 0 or index + 1;
end

---
-- Circles to the previous palette. If the first one is reached
-- it jumps to the last palette instead.
--
function PaletteSwitcher.prev()
    index = index == 0 and lut:getHeight() - 1 or index - 1;
end

---
-- Initialise the palette switcher.
-- @param ppath - The path to the look up table.
-- @param spath - The path to the shader file.
--
function PaletteSwitcher.init(ppath, spath)
    index = 0;
    lut = love.graphics.newImage(ppath);
    lut:setFilter('nearest', 'nearest');
    shader = love.graphics.newShader(spath);
    shader:send('lut', lut);
    shader:send('palettes', lut:getHeight() - 1);
end

---
-- Makes the palette switcher active.
--
function PaletteSwitcher.set()
    love.graphics.setShader(shader);
    shader:send('index', index);
end

---
-- Makes the palette switcher inactive.
--
function PaletteSwitcher.unset()
    love.graphics.setShader();
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return PaletteSwitcher;

--==================================================================================================
-- Created 02.09.14 - 16:25                                                                        =
--==================================================================================================