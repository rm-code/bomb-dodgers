--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local PaletteSwitcher = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local shader = love.graphics.newShader('res/shader/gb.fs');
local palettes = require('src/colswitcher/Palettes');
local curPalette = 1;
local colors = palettes[curPalette].colors;

-- ------------------------------------------------
-- Local Functions
-- ------------------------------------------------

---
-- Sets the current palette to a new one.
-- @param pal - The palette to which to switch.
--
local function setPalette(pal)
    print('Switch palette to: ' .. pal.name);
    colors = pal.colors;
end

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

---
-- Makes the palette switcher active.
--
function PaletteSwitcher.set()
    love.graphics.setShader(shader);
    shader:send('PALETTE', colors.black, colors.dgrey, colors.lgrey, colors.white);
end

---
-- Makes the palette switcher inactive.
--
function PaletteSwitcher.unset()
    love.graphics.setShader();
end

---
-- Circles to the next palette. If the last one is reached
-- it jumps back to the first one.
--
function PaletteSwitcher.nextPalette()
    curPalette = curPalette == #palettes and 1 or curPalette + 1;
    setPalette(palettes[curPalette]);
end

---
-- Circles to the previous palette. If the first one is reached
-- it jumps to the last palette instead.
--
function PaletteSwitcher.previousPalette()
    curPalette = curPalette == 1 and #palettes or curPalette - 1;
    setPalette(palettes[curPalette]);
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return PaletteSwitcher;

--==================================================================================================
-- Created 02.09.14 - 16:25                                                                        =
--==================================================================================================