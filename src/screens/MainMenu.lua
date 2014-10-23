--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Controls = require('src/Controls');
local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local Button = require('src/ui/Button');
local ButtonManager = require('src/ui/ButtonManager');
local ResourceManager = require('lib/ResourceManager');
local InputManager = require('lib/InputManager');
local AniMAL = require('lib/AniMAL');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');
local SoundManager = require('lib/SoundManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local MainMenu = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};
local music = {};

ResourceManager.register(MainMenu);

function MainMenu.loadImages()
    images['start'] = ResourceManager.loadImage('res/img/ui/startgame.png');
    images['options'] = ResourceManager.loadImage('res/img/ui/options.png');
    images['exit'] = ResourceManager.loadImage('res/img/ui/exit.png');
    images['logo'] = ResourceManager.loadImage('res/img/ui/logo_anim.png');
    images['anim'] = AniMAL.new(images['logo'], 71, 25, 0.18);
    images['anim']:setScale(8, 8);
end

function MainMenu.loadMusic()
    music['main'] = ResourceManager.loadMusic('res/music/main.ogg', 'static');
    music['main']:setRelative(true);
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function MainMenu.new()
    local self = Screen.new();

    local paletteShader;
    local buttons;
    local sw, sh;

    local function start()
        ScreenManager.switch(LevelMenu.new());
    end

    local function options()
        ScreenManager.switch(Options.new());
    end

    local function exit()
        love.event.quit();
    end

    local function handleInput(dt)
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
        InputManager.clear();
        InputManager.setMap(Controls.MENU);

        paletteShader = PaletteSwitcher.new();

        buttons = ButtonManager.new();
        buttons:register(Button.new(images['start'],    172, 256, 3, 3, start));
        buttons:register(Button.new(images['options'],  172, 256 + 48, 3, 3, options));
        buttons:register(Button.new(images['exit'],     172, 256 + 96, 3, 3, exit));
        buttons:select(1);

        SoundManager.play(music['main'], 'music', 0, 0, 0);

        sw, sh = love.graphics.getDimensions();
    end

    function self:update(dt)
        images['anim']:update(dt);
        handleInput();
        buttons:update(dt);
    end

    function self:draw()
        paletteShader:set();
        love.graphics.setColor(215, 232, 148);
        love.graphics.rectangle('fill', 0, 0, sw, sh);
        love.graphics.setColor(255, 255, 255);
        images['anim']:draw(40);
        buttons:draw();
        paletteShader:unset();
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return MainMenu;

--==================================================================================================
-- Created 11.09.14 - 17:52                                                                        =
--==================================================================================================