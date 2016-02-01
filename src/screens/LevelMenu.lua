--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 - 2016 Robert Machmer                                      --
--                                                                               --
-- This software is provided 'as-is', without any express or implied             --
-- warranty. In no event will the authors be held liable for any damages         --
-- arising from the use of this software.                                        --
--                                                                               --
-- Permission is granted to anyone to use this software for any purpose,         --
-- including commercial applications, and to alter it and redistribute it        --
-- freely, subject to the following restrictions:                                --
--                                                                               --
--  1. The origin of this software must not be misrepresented; you must not      --
--      claim that you wrote the original software. If you use this software     --
--      in a product, an acknowledgment in the product documentation would be    --
--      appreciated but is not required.                                         --
--  2. Altered source versions must be plainly marked as such, and must not be   --
--      misrepresented as being the original software.                           --
--  3. This notice may not be removed or altered from any source distribution.   --
--                                                                               --
--===============================================================================--

local Controls = require('src/Controls');
local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local Arena = require('src/arena/Arena');
local Player = require('src/entities/dodgers/Player');
local InputManager = require('lib/InputManager');
local Camera = require('lib/Camera');
local Constants = require('src/Constants');
local ResourceManager = require('lib/ResourceManager');
local ProfileHandler = require('src/profile/ProfileHandler');
local Door = require('src/arena/objects/Door');
local Shader = require('lib/Shader');
local SoundManager = require('lib/SoundManager');

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
    images['lvl3'] = ResourceManager.loadImage('res/img/ui/preview_lvl_3.png');
    images['lvl4'] = ResourceManager.loadImage('res/img/ui/preview_lvl_4.png');
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
}

local TELEPORTER_POSITIONS = {
    { x = 2, y = 2 },
    { x = 10, y = 2 },
    { x = 2, y = 8 },
    { x = 10, y = 8 },
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
    local previews;
    local sw, sh;

    local function loadLevel(level)
        canvas = love.graphics.newCanvas();
        canvas:renderTo(function()
            self:draw();
        end);

        if music['main']:isPlaying() then
            music['main']:stop();
        end

        SoundManager.play(music['loadLevel'], 'music', 0, 0, 0);
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
        InputManager.clear();
        InputManager.setMap(Controls.LEVELMENU);

        arena = Arena.new();
        arena:init('res/arenas/layout_LevelMenu.lua', true);

        camera = Camera.new();
        camera:setScale(2, 2);
        camera:setBoundaries(Constants.TILESIZE, Constants.TILESIZE, 16 * Constants.TILESIZE, 14 * Constants.TILESIZE);

        waveShader = Shader.new('res/shader/wave.fs');
        blurShader = Shader.new('res/shader/blur.fs');

        player = Player.new(arena, 8, 2);
        player:setCamera(camera);

        profile = ProfileHandler.load();
        ProfileHandler.save(profile);

        placeDoors(arena);

        previews = love.graphics.newCanvas();

        sw, sh = love.graphics.getDimensions();
    end

    local function handleInput()
        if InputManager.hasCommand('BACK') then
            ScreenManager.switch(MainMenu.new());
        end
    end

    local function updatePreviews()
        previews:clear();
        waveShader:send('time', love.timer.getTime());
        previews:renderTo(function()
            waveShader:set();
            for i = 1, #TELEPORTER_POSITIONS do
                love.graphics.draw(images['lvl' .. i], TILESIZE * TELEPORTER_POSITIONS[i].x, TILESIZE * TELEPORTER_POSITIONS[i].y);
            end
            waveShader:unset();
        end);
    end

    function self:update(dt)
        updatePreviews();

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
    end

    function self:draw()
        if not nextLevel then
            love.graphics.rectangle('fill', 0, 0, sw, sh);
            camera:set();
            arena:draw();

            love.graphics.draw(previews);

            player:draw();
            camera:unset();
        else
            blurShader:set();
            love.graphics.draw(canvas);
            blurShader:unset();
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