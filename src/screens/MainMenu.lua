--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local Arena = require('src/arena/Arena');
local Player = require('src/entities/dodgers/Player');
local Button = require('src/ui/Button');
local ButtonManager = require('src/ui/ButtonManager');
local InputManager = require('lib/InputManager');
local Camera = require('lib/Camera');
local Constants = require('src/Constants');
local ResourceManager = require('lib/ResourceManager');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');

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
    images['button'] = ResourceManager.loadImage('res/img/ui/button.png');
    images['logo'] = ResourceManager.loadImage('res/img/ui/logo.png');
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

    local arena;
    local player;
    local buttons;
    local camera;
    local sw, sh;

    local function start()
        ScreenManager.switch(LevelMenu.new());
    end

    local function options()
    end

    local function exit()
    end

    function self:init()
        arena = Arena.new();
        arena:init('res/arenas/layout_MainMenu.lua', true);

        camera = Camera.new();
        camera:setZoom(2.0);

        player = Player.new(arena, 2, 2);

        buttons = ButtonManager.new();
        buttons:register(Button.new(images['button'], 128, 64, start));
        buttons:register(Button.new(images['button'], 128, 96, options));
        buttons:register(Button.new(images['button'], 128, 128, exit));

        music['main']:play();

        sw, sh = love.graphics.getDimensions();
    end

    local function handleInput()
        if InputManager.hasCommand('SELECT') then
            buttons:press();
        elseif InputManager.hasCommand('COL') then
            PaletteSwitcher.nextPalette();
        end
    end

    local function select()
        if player:getY() == 2 then
            buttons:select(1)
        elseif player:getY() == 3 then
            buttons:select(2)
        elseif player:getY() == 4 then
            buttons:select(3)
        end
    end

    function self:update(dt)
        arena:update(dt);
        player:update(dt);

        select();
        handleInput();

        camera:track(player:getRealX() + Constants.TILESIZE * 2.5, player:getRealY(), 6, dt);

        buttons:update(dt);
    end

    function self:draw()
        PaletteSwitcher.set();
--        love.graphics.setColor(255, 255, 255);
        love.graphics.rectangle('fill', 0, 0, sw, sh);
        camera:set();
        arena:draw();
        player:draw();

        love.graphics.draw(images['logo'], Constants.TILESIZE * 2.0, -64, 0, 2, 2);

        buttons:draw();
        camera:unset();

        PaletteSwitcher.unset();
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