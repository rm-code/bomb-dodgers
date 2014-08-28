local PaletteSwitcher = {};

local shader = love.graphics.newShader('res/shaders/gb.fs');
local palettes = require('lib/Palettes');
local curPalette = 1;
local colors = palettes[curPalette].colors;

function PaletteSwitcher.set()
    love.graphics.setShader(shader);
    shader:send('PALETTE', colors.black, colors.white, colors.lgrey, colors.dgrey);
end

function PaletteSwitcher.unset()
    love.graphics.setShader();
end

local function setPalette(pal)
    print('Switch palette to: ' .. pal.name);
    colors = pal.colors;
end

function PaletteSwitcher.nextPalette()
    curPalette = curPalette == #palettes and 1 or curPalette + 1;
    setPalette(palettes[curPalette]);
end

function PaletteSwitcher.previousPalette()
    curPalette = curPalette == 1 and #palettes or curPalette - 1;
    setPalette(palettes[curPalette]);
end

return PaletteSwitcher;

--==================================================================================================
-- Created 02.09.14 - 16:25                                                                        =
--==================================================================================================