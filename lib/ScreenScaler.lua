local ScreenScaler = {};
local width = 640;
local height = 480;

local modes = {
    'windowed',
    'scaled',
    'stretched',
}

local mode = 1;
local scaleX = 1;
local scaleY = 1;
local offsetX = 0;
local offsetY = 0;
local vsync = true;

-- ------------------------------------------------
-- Private Functions
-- ------------------------------------------------

---
-- Calculates the offset that will be needed to place the scaled
-- drawing area in the center of the screen.
-- @param sw - Screen's width.
-- @param sh - Screen's height.
-- @param w - Drawing area's base width.
-- @param h - Drawing area's base height.
-- @param sx - The scale applied to the drawing area.
-- @param sy - The scale applied to the drawing area.
--
local function calcOffset(sw, sh, w, h, sx, sy)
    local ox, oy;
    ox = (sw - w * sx) * 0.5;
    oy = (sh - h * sy) * 0.5;
    return ox, oy;
end

---
-- @param mode
--
local function applyMode(mode)
    print('Switch to mode: ' .. mode);

    if mode == 'windowed' then
        love.window.setMode(width * scaleX, height * scaleY, { fullscreen = false, fullscreentype = 'desktop', vsync = vsync });
        offsetX, offsetY = 0, 0;
    else
        love.window.setMode(0, 0, { fullscreen = true, fullscreentype = 'desktop', vsync = vsync });
        local sw, sh = love.graphics.getDimensions();

        if mode == 'stretched' then
            scaleX = sw / width;
            scaleY = sh / height;
        end

        offsetX, offsetY = calcOffset(sw, sh, width, height, scaleX, scaleY);
    end
end

function ScreenScaler.init(nmode, nscaleX, nscaleY, nvsync)
    mode = nmode or mode;
    scaleX = nscaleX or scaleX;
    scaleY = nscaleY or scaleY;
    vsync = nvsync;

    applyMode(modes[mode]);
end

function ScreenScaler.toggleVSync()
    vsync = not vsync;
    applyMode(modes[mode]);
end

function ScreenScaler.changeMode()
    mode = mode == #modes and 1 or mode + 1;
    applyMode(modes[mode]);
end

function ScreenScaler.increaseScale()
    scaleX = scaleX + 0.25;
    scaleY = scaleY + 0.25;
    applyMode(modes[mode]);
end

function ScreenScaler.decreaseScale()
    scaleX = scaleX - 0.25;
    scaleY = scaleY - 0.25;
    applyMode(modes[mode]);
end

function ScreenScaler.push()
    love.graphics.push();
    love.graphics.translate(offsetX, offsetY);
    love.graphics.scale(scaleX, scaleY);
    love.graphics.setScissor(offsetX, offsetY, width * scaleX, height * scaleY);
end

function ScreenScaler.pop()
    love.graphics.setScissor();
    love.graphics.pop();
end

-- ------------------------------------------------
-- Getters
-- ------------------------------------------------

function ScreenScaler.getOffset()
    return offsetX, offsetY;
end

function ScreenScaler.getMode()
    return mode;
end

function ScreenScaler.hasVSync()
    return vsync;
end

function ScreenScaler.getScale()
    return scaleX, scaleY;
end

-- ------------------------------------------------
-- Setters
-- ------------------------------------------------

function ScreenScaler.setScale(nsx, nsy)
    scaleX = nsx;
    scaleY = nsy;
end

return ScreenScaler;

--==================================================================================================
-- Created 05.10.14 - 19:55                                                                        =
--==================================================================================================