--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local ResourceManager = require('lib/ResourceManager');
local Shader = require('lib/Shader');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local PaletteSwitcher = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local lut;

-- Register module with resource manager.
ResourceManager.register(PaletteSwitcher);

---
-- Load images.
--
function PaletteSwitcher.loadImages()
    lut = love.graphics.newImage('res/img/lut/palettes.png');
end

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local index = 0;

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

---
-- Circles to the next palette. If the last one is reached
-- it jumps back to the first one.
--
function PaletteSwitcher:nextPalette()
    index = index == lut:getHeight() - 1 and 0 or index + 1;
end

---
-- Circles to the previous palette. If the first one is reached
-- it jumps to the last palette instead.
--
function PaletteSwitcher:previousPalette()
    index = index == 0 and lut:getHeight() - 1 or index - 1;
end

function PaletteSwitcher.new()
    local self = {};

    local shader = Shader.new('res/shader/palette.fs');
    shader:send('lut', lut);

    ---
    -- Makes the palette switcher active.
    --
    function self:set()
        shader:set();
        shader:send('index', index);
        shader:send('palettes', lut:getHeight() - 1);
    end

    ---
    -- Makes the palette switcher inactive.
    --
    function self:unset()
        shader:unset();
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return PaletteSwitcher;

--==================================================================================================
-- Created 02.09.14 - 16:25                                                                        =
--==================================================================================================