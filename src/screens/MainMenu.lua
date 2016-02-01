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

local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local Button = require('src/ui/Button');
local ButtonManager = require('src/ui/ButtonManager');
local ResourceManager = require('lib/ResourceManager');
local Controls = require('src/Controls');
local InputManager = require('lib/InputManager');
local AniMAL = require('lib/AniMAL');
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

    local buttons;
    local sw, sh;

    local function start()
        ScreenManager.switch(LevelMenu.new());
    end

    local function options()
        ScreenManager.switch(Options.new());
    end

    local function exit()
        ScreenManager.switch(Modal.new(function() love.event.quit() end, function() ScreenManager.switch(MainMenu.new()) end));
    end

    local function handleInput(dt)
        if InputManager.hasCommand('UP') or InputManager.hasCommand('LEFT') then
            buttons:prev();
        elseif InputManager.hasCommand('DOWN') or InputManager.hasCommand('RIGHT') then
            buttons:next();
        end

        if InputManager.hasCommand('SELECT') then
            buttons:press();
        end

        if InputManager.hasCommand('BACK') then
            exit();
        end
    end

    function self:init()
        InputManager.clear();
        InputManager.setMap(Controls.MENU);

        buttons = ButtonManager.new();
        buttons:register(Button.new(images['start'], 172, 256, 3, 3, start));
        buttons:register(Button.new(images['options'], 172, 256 + 48, 3, 3, options));
        buttons:register(Button.new(images['exit'], 172, 256 + 96, 3, 3, exit));
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
        love.graphics.setColor(215, 232, 148);
        love.graphics.rectangle('fill', 0, 0, sw, sh);
        love.graphics.setColor(255, 255, 255);
        images['anim']:draw(40);
        buttons:draw();
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