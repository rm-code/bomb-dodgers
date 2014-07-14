--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local ScreenManager = require('lib/screens/ScreenManager');

-- ------------------------------------------------
-- Screens
-- ------------------------------------------------

Game = require('src/screens/Game');

-- ------------------------------------------------
-- Local variables
-- ------------------------------------------------

local info = false;

-- ------------------------------------------------
-- Local functions
-- ------------------------------------------------

---
-- Check if the hardware supports certain features.
--
local function checkSupport()
    print("\n---- SUPPORTED ---- ");
    print("Canvas:         " .. tostring(love.graphics.isSupported('canvas')));
    print("PO2:            " .. tostring(love.graphics.isSupported('npot')));
    print("Subtractive BM: " .. tostring(love.graphics.isSupported('subtractive')));
    print("Shaders:        " .. tostring(love.graphics.isSupported('shader')));
    print("HDR Canvas:     " .. tostring(love.graphics.isSupported('hdrcanvas')));
    print("Multicanvas:    " .. tostring(love.graphics.isSupported('multicanvas')));
    print("Mipmaps:        " .. tostring(love.graphics.isSupported('mipmap')));
    print("DXT:            " .. tostring(love.graphics.isSupported('dxt')));
    print("BC5:            " .. tostring(love.graphics.isSupported('bc5')));
    print("SRGB:           " .. tostring(love.graphics.isSupported('srgb')));

    print("\n---- RENDERER  ---- ");
    local name, version, vendor, device = love.graphics.getRendererInfo()
    print(string.format("Name: %s \nVersion: %s \nVendor: %s \nDevice: %s", name, version, vendor, device));
end

-- ------------------------------------------------
-- Loading
-- ------------------------------------------------

function love.load()
    print("===================")
    print(string.format("Title: '%s'", getTitle()));
    print(string.format("Version: %.4d", getVersion()));
    print(string.format("Resolution: %dx%d", love.window.getDimensions()));

    -- Check the user's hardware.
    checkSupport();

    -- Start game on the main menu.
    ScreenManager:init(Game.new());
end

-- ------------------------------------------------
-- Periodical Updates
-- ------------------------------------------------

function love.update(dt)
    ScreenManager:update(dt);
end

function love.draw()
    local lg = love.graphics;
    local lt = love.timer;
    local format = string.format;

    ScreenManager:draw();
    if info then
        lg.print(format("FT: %.3f ms", 1000 * lt.getAverageDelta()), 10, love.window.getHeight() - 60);
        lg.print(format("FPS: %.3f fps", lt.getFPS()), 10, love.window.getHeight() - 40);
        lg.print(format("MEM: %.3f kb", collectgarbage("count")), 10, love.window.getHeight() - 20);
    end
end

-- ------------------------------------------------
-- Window
-- ------------------------------------------------

function love.resize(width, height)
    ScreenManager:resize(width, height);
end

function love.visible(visible)
    ScreenManager:visible(visible);
end

function love.focus(focus)
    ScreenManager:focus(focus);
end

-- ------------------------------------------------
-- Input
-- ------------------------------------------------

function love.keypressed(key)
    if key == 'f1' then
        info = not info;
    end

    ScreenManager:keypressed(key);
end

function love.keyreleased(key)
    ScreenManager:keyreleased(key);
end

function love.textinput(input)
    ScreenManager:textinput(input);
end

function love.mousepressed(x, y, button)
    ScreenManager:mousepressed(x, y, button);
end

function love.mousereleased(x, y, button)
    ScreenManager:mousereleased(x, y, button);
end

function love.mousefocus(focus)
    ScreenManager:mousefocus(focus);
end

-- ------------------------------------------------
-- Misc
-- ------------------------------------------------

function love.quit() end

--==================================================================================================
-- Created 14.07.14 - 02:51                                                                        =
--==================================================================================================