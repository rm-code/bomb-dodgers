--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local Arena = require('src/arena/Arena');
local Player = require('src/entities/dodgers/Player');
local InputManager = require('lib/InputManager');
local Camera = require('lib/Camera');
local Constants = require('src/Constants');
local ResourceManager = require('lib/ResourceManager');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');
local ProfileHandler = require('src/profile/ProfileHandler');
local Door = require('src/arena/objects/Door');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local LevelMenu = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};
local music = {};

ResourceManager.register(LevelMenu);

function LevelMenu.loadImages()
    images['lvl1'] = ResourceManager.loadImage('res/img/ui/preview_lvl_1.png');
    images['lvl2'] = ResourceManager.loadImage('res/img/ui/preview_lvl_2.png');
    images['lvl3'] = ResourceManager.loadImage('res/img/ui/missing.png');
    images['lvl4'] = ResourceManager.loadImage('res/img/ui/missing.png');
    images['lvl5'] = ResourceManager.loadImage('res/img/ui/missing.png');
    images['lvl6'] = ResourceManager.loadImage('res/img/ui/missing.png');
end

function LevelMenu.loadMusic()
    music['loadLevel'] = ResourceManager.loadMusic('res/music/loadLevel.ogg', 'static');
    music['loadLevel']:setRelative(true);
    music['main'] = ResourceManager.loadMusic('res/music/main.ogg', 'static');
    music['main']:setRelative(true);
    music['main']:setLooping(true);
end

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local TILESIZE = Constants.TILESIZE;

local DOOR_POSITIONS = {
    { x = 7, y = 4 },
    { x = 9, y = 4 },
    { x = 7, y = 10 },
    { x = 9, y = 10 },
    { x = 7, y = 16 },
    { x = 9, y = 16 },
}

local TELEPORTER_POSITIONS = {
    { x = 2, y = 2 },
    { x = 10, y = 2 },
    { x = 2, y = 8 },
    { x = 10, y = 8 },
    { x = 2, y = 14 },
    { x = 10, y = 14 },
}

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function LevelMenu.new()
    local self = Screen.new();

    local arena;
    local player;
    local camera;
    local waveShader;
    local blurShader;
    local blurAmount = 0.2;
    local profile;
    local timer = 1;
    local nextLevel;
    local canvas;

    local function loadLevel(level)
        canvas = love.graphics.newCanvas();
        canvas:renderTo(function()
            self:draw();
        end);

        if music['main']:isPlaying() then
            music['main']:stop();
        end

        music['loadLevel']:play();
        nextLevel = level;
    end

    local function placeDoors(arena)
        local grid = arena:getGrid()
        for i = 1, #DOOR_POSITIONS do
            local door = DOOR_POSITIONS[i];
            grid[door.x][door.y]:addContent(Door.new(door.x, door.y, profile['door' .. i]));
        end
    end

    local function doesCollide(x1, y1, w1, h1, x2, y2, w2, h2)
        return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1;
    end

    local function enterTeleporter()
        -- Take the center of the player sprite for the collision detection.
        local px, py, pw, ph = player:getRealX() + TILESIZE * 0.5, player:getRealY() + TILESIZE * 0.5, 0, 0;
        local tx, ty, tw, th;

        for i = 1, #TELEPORTER_POSITIONS do
            local teleporter = TELEPORTER_POSITIONS[i];
            tx, ty, tw, th = teleporter.x * TILESIZE, teleporter.y * TILESIZE, 5 * TILESIZE, 5 * TILESIZE;

            if doesCollide(px, py, pw, ph, tx, ty, tw, th) then
                loadLevel(i);
            end
        end
    end

    function self:init()
        arena = Arena.new();
        arena:init('res/arenas/layout_LevelMenu.lua', true);

        camera = Camera.new();
        camera:setZoom(2.0);

        waveShader = love.graphics.newShader('res/shader/wave.fs');
        blurShader = love.graphics.newShader('res/shader/blur.fs');

        player = Player.new(arena, 8, 2);
        player:setCamera(camera);

        profile = ProfileHandler.load();
        ProfileHandler.save(profile);

        placeDoors(arena);
    end

    local function handleInput()
        if InputManager.hasCommand('COL') then
            PaletteSwitcher.nextPalette();
        end
    end

    function self:update(dt)
        if nextLevel then
            timer = timer - dt;
            if timer <= 0 then
                ScreenManager.switch(LevelSwitcher.new(nextLevel));
                return;
            end
            blurAmount = blurAmount + dt;
            blurShader:send('radius', blurAmount);
            return;
        end

        arena:update(dt);
        player:update(dt);

        handleInput();
        enterTeleporter(player);

        waveShader:send('time', love.timer.getTime());
    end

    function self:draw()
        if not nextLevel then
            PaletteSwitcher.set();
            camera:set();
            arena:draw();
            PaletteSwitcher.unset();

            love.graphics.setShader(waveShader);
            for i = 1, #TELEPORTER_POSITIONS do
                love.graphics.draw(images['lvl' .. i], TILESIZE * TELEPORTER_POSITIONS[i].x, TILESIZE * TELEPORTER_POSITIONS[i].y);
            end
            love.graphics.setShader();

            PaletteSwitcher.set();
            player:draw();
            PaletteSwitcher.unset();
            camera:unset();
        else
            love.graphics.setShader(blurShader);
            love.graphics.draw(canvas);
            love.graphics.setShader();
        end
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return LevelMenu;

--==================================================================================================
-- Created 12.09.14 - 00:33                                                                        =
--==================================================================================================