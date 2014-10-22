local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');
local ResourceManager = require('lib/ResourceManager');
local Button = require('src/ui/Button');
local ButtonManager = require('src/ui/ButtonManager');
local InputManager = require('lib/InputManager');
local ProfileHandler = require('src/profile/ProfileHandler');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Options = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

ResourceManager.register(Options);

function Options.loadImages()
    images['options'] = ResourceManager.loadImage('res/img/ui/options.png');
    images['scale'] = ResourceManager.loadImage('res/img/ui/scale.png');
    images['fullscreen'] = ResourceManager.loadImage('res/img/ui/fullscreen.png');
    images['vsync'] = ResourceManager.loadImage('res/img/ui/vsync.png');
    images['back'] = ResourceManager.loadImage('res/img/ui/back.png');
    images['shaders'] = ResourceManager.loadImage('res/img/ui/shaders.png');
    images['on'] = ResourceManager.loadImage('res/img/ui/on.png');
    images['off'] = ResourceManager.loadImage('res/img/ui/off.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Options.new()
    local self = Screen.new();

    local paletteShader;
    local buttons;
    local profile;

    local function changeScale()
        ProfileHandler.save(profile);
    end

    local function toggleFullscreen()
        profile.fullscreen = not profile.fullscreen;
        ProfileHandler.save(profile);
    end

    local function toggleShaders()
        if not love.graphics.isSupported('shader') then
            return;
        end
        profile.shaders = not profile.shaders;
        ProfileHandler.save(profile);
    end

    local function toggleVsync()
        profile.vsync = not profile.vsync;
        love.window.setMode(love.window.getWidth(), love.window.getHeight(), { vsync = profile.vsync });
        ProfileHandler.save(profile);
    end

    local function back()
        ScreenManager.switch(MainMenu.new());
    end

    local function handleInput()
        if InputManager.hasCommand('COL') then
            PaletteSwitcher.nextPalette();
        end

        if InputManager.hasCommand('UP') or InputManager.hasCommand('LEFT') then
            buttons:prev();
        elseif InputManager.hasCommand('DOWN') or InputManager.hasCommand('RIGHT') then
            buttons:next();
        end

        if InputManager.hasCommand('SELECT') then
            buttons:press();
        end
    end

    function self:init()
        paletteShader = PaletteSwitcher.new();

        profile = ProfileHandler.load();

        buttons = ButtonManager.new();
        buttons:register(Button.new(images['vsync'], 64, 160, 3, 3, toggleVsync));
        buttons:register(Button.new(images['fullscreen'], 64, 208, 3, 3, toggleFullscreen));
        buttons:register(Button.new(images['scale'], 64, 256, 3, 3, changeScale));
        buttons:register(Button.new(images['shaders'], 64, 304, 3, 3, toggleShaders));
        buttons:register(Button.new(images['back'], 64, 352, 3, 3, back));
        buttons:select(1);
    end

    function self:draw()
        paletteShader:set();
        love.graphics.setColor(215, 232, 148);
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight());
        love.graphics.setColor(255, 255, 255);

        love.graphics.draw(images['options'], 164, 16, 0, 3, 3);
        love.graphics.draw(profile.vsync and images['on'] or images['off'], 416, 160, 0, 3, 3);
        love.graphics.draw(profile.fullscreen and images['on'] or images['off'], 416, 208, 0, 3, 3);
        love.graphics.draw(profile.shaders and images['on'] or images['off'], 416, 304, 0, 3, 3);
        buttons:draw();

        paletteShader:unset();
    end

    function self:update(dt)
        handleInput();
        buttons:update(dt);
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Options;

--==================================================================================================
-- Created 05.10.14 - 12:29                                                                        =
--==================================================================================================