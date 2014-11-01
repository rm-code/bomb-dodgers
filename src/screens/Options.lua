--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local ScreenScaler = require('lib/ScreenScaler');
local ResourceManager = require('lib/ResourceManager');
local Button = require('src/ui/Button');
local ButtonManager = require('src/ui/ButtonManager');
local InputManager = require('lib/InputManager');
local ProfileHandler = require('src/profile/ProfileHandler');
local SoundManager = require('lib/SoundManager');
local PaletteSwitcher = require('lib/colswitcher/PaletteSwitcher');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Options = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};
local music = {};
local options = {};

ResourceManager.register(Options);

function Options.loadSounds()
    options['select'] = ResourceManager.loadSound('res/snd/select.wav', 'static');
    options['select']:setRelative(true);
    options['beep'] = ResourceManager.loadSound('res/snd/beep.wav', 'static');
    options['beep']:setRelative(true);
end

function Options.loadImages()
    images['options'] = ResourceManager.loadImage('res/img/ui/options.png');
    images['fullscreen'] = ResourceManager.loadImage('res/img/ui/fullscreen.png');
    images['vsync'] = ResourceManager.loadImage('res/img/ui/vsync.png');
    images['back'] = ResourceManager.loadImage('res/img/ui/back.png');
    images['shaders'] = ResourceManager.loadImage('res/img/ui/shaders.png');
    images['music'] = ResourceManager.loadImage('res/img/ui/music.png');
    images['sound'] = ResourceManager.loadImage('res/img/ui/sound.png');
    images['on'] = ResourceManager.loadImage('res/img/ui/on.png');
    images['off'] = ResourceManager.loadImage('res/img/ui/off.png');
    images[0] = ResourceManager.loadImage('res/img/ui/p00.png');
    images[1] = ResourceManager.loadImage('res/img/ui/p01.png');
    images[2] = ResourceManager.loadImage('res/img/ui/p02.png');
    images[3] = ResourceManager.loadImage('res/img/ui/p03.png');
    images[4] = ResourceManager.loadImage('res/img/ui/p04.png');
    images[5] = ResourceManager.loadImage('res/img/ui/p05.png');
    images[6] = ResourceManager.loadImage('res/img/ui/p06.png');
    images[7] = ResourceManager.loadImage('res/img/ui/p07.png');
    images[8] = ResourceManager.loadImage('res/img/ui/p08.png');
    images[9] = ResourceManager.loadImage('res/img/ui/p09.png');
    images[10] = ResourceManager.loadImage('res/img/ui/p10.png');
    images['modes'] = {
        ResourceManager.loadImage('res/img/ui/windowed.png');
        ResourceManager.loadImage('res/img/ui/scale.png');
        ResourceManager.loadImage('res/img/ui/stretched.png');
    }
    images['+'] = ResourceManager.loadImage('res/img/ui/plus.png');
    images['-'] = ResourceManager.loadImage('res/img/ui/minus.png');
end

function Options.loadMusic()
    music['main'] = ResourceManager.loadMusic('res/music/main.ogg', 'static');
    music['main']:setRelative(true);
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Options.new()
    local self = Screen.new();

    local buttons;
    local profile;
    local offset = 24;

    local function increaseScale()
        ScreenScaler.increaseScale();
        profile.scaleX, profile.scaleY = ScreenScaler.getScale();
        ProfileHandler.save(profile);
        PaletteSwitcher.init('lib/colswitcher/palettes.png', 'lib/colswitcher/palette.fs');
    end

    local function decreaseScale()
        ScreenScaler.decreaseScale();
        profile.scaleX, profile.scaleY = ScreenScaler.getScale();
        ProfileHandler.save(profile);
        PaletteSwitcher.init('lib/colswitcher/palettes.png', 'lib/colswitcher/palette.fs');
    end

    local function toggleFullscreen()
        ScreenScaler.changeMode();
        profile.mode = ScreenScaler.getMode();
        ProfileHandler.save(profile);
        PaletteSwitcher.init('lib/colswitcher/palettes.png', 'lib/colswitcher/palette.fs');
    end

    local function toggleShaders()
        if not love.graphics.isSupported('shader') then
            return;
        end
        profile.shaders = not profile.shaders;
        ProfileHandler.save(profile);
        PaletteSwitcher.setActive(profile.shaders);
    end

    local function toggleVsync()
        ScreenScaler.toggleVSync();
        profile.vsync = ScreenScaler.hasVSync();
        ProfileHandler.save(profile);
        PaletteSwitcher.init('lib/colswitcher/palettes.png', 'lib/colswitcher/palette.fs');
    end

    local function adjustSound()
        profile.sfx = profile.sfx == 10 and 0 or profile.sfx + 1;
        SoundManager.setVolume('sfx', profile.sfx / 10);
        ProfileHandler.save(profile);
    end

    local function adjustMusic()
        profile.music = profile.music == 10 and 0 or profile.music + 1;
        SoundManager.setVolume('music', profile.music / 10);
        SoundManager.play(music['main'], 'music', 0, 0, 0);
        ProfileHandler.save(profile);
    end

    local function back()
        ScreenManager.switch(MainMenu.new());
    end

    local function handleInput()
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
        profile = ProfileHandler.load();

        buttons = ButtonManager.new();

        buttons:register(Button.new(images['vsync'], 64, offset + 64, 3, 3, toggleVsync));
        buttons:register(Button.new(images['fullscreen'], 64, offset + 112, 3, 3, toggleFullscreen));
        buttons:register(Button.new(images['+'], 416, offset + 160, 3, 3, increaseScale));
        buttons:register(Button.new(images['-'], 448, offset + 160, 3, 3, decreaseScale));
        buttons:register(Button.new(images['shaders'], 64, offset + 208, 3, 3, toggleShaders));
        buttons:register(Button.new(images['music'], 64, offset + 256, 3, 3, adjustMusic));
        buttons:register(Button.new(images['sound'], 64, offset + 304, 3, 3, adjustSound));
        buttons:register(Button.new(images['back'], 64, offset + 368, 3, 3, back));
        buttons:select(1);
    end

    function self:draw()
        love.graphics.setColor(215, 232, 148);
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight());
        love.graphics.setColor(255, 255, 255);

        love.graphics.draw(images['options'], 164, 16, 0, 3, 3);
        love.graphics.draw(profile.vsync and images['on'] or images['off'], 416, offset + 64, 0, 3, 3);
        love.graphics.draw(images['modes'][profile.mode], 416, offset + 112, 0, 3, 3);
        love.graphics.draw(profile.shaders and images['on'] or images['off'], 416, offset + 208, 0, 3, 3);
        love.graphics.draw(images[profile.music], 416, offset + 256, 0, 3, 3);
        love.graphics.draw(images[profile.sfx], 416, offset + 304, 0, 3, 3);
        buttons:draw();
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