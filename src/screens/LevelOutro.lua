--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local ResourceManager = require('lib/ResourceManager');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');
local AniMAL = require('lib/AniMAL');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local LevelOutro = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};
local sounds = {};
local anims = {};

ResourceManager.register(LevelOutro);

function LevelOutro.loadImages()
    images['round1'] = ResourceManager.loadImage('res/img/ui/round1.png');
    images['round2'] = ResourceManager.loadImage('res/img/ui/round2.png');
    images['round3'] = ResourceManager.loadImage('res/img/ui/round3.png');
    images['x'] = ResourceManager.loadImage('res/img/ui/x.png');
    images['o'] = ResourceManager.loadImage('res/img/ui/o.png');
    images['loser'] = ResourceManager.loadImage('res/img/ui/loser.png');
    images['winner'] = ResourceManager.loadImage('res/img/ui/winner.png');
    anims['loser'] = AniMAL.new(images['loser'], 50, 50, 0.4);
    anims['loser']:setScale(4, 4);
    anims['winner'] = AniMAL.new(images['winner'], 50, 50, 0.4);
    anims['winner']:setScale(4, 4);
end

function LevelOutro.loadSounds()
    sounds['lose'] = ResourceManager.loadSound('res/snd/lose.wav', 'static');
    sounds['lose']:setRelative(true);
    sounds['win'] = ResourceManager.loadSound('res/snd/win.wav', 'static');
    sounds['win']:setRelative(true);
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function LevelOutro.new(level, scores)
    local self = Screen.new();

    local timer = 4;
    local anim;
    local one, two, three;
    local sw, sh;

    function self:init()
        sw, sh = love.graphics.getDimensions();

        anim = scores[#scores] == 'player' and anims['winner'] or anims['loser'];

        if scores[1] then
            one = scores[1] == 'player' and images['o'] or images['x'];
        end
        if scores[2] then
            two = scores[2] == 'player' and images['o'] or images['x'];
        end
        if scores[3] then
            three = scores[3] == 'player' and images['o'] or images['x'];
        end

        if scores[#scores] == 'player' then
            sounds['win']:play();
        else
            sounds['lose']:play();
        end
    end

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            ScreenManager.pop();
        end

        anim:update(dt);
    end

    function self:draw()
        PaletteSwitcher.set();
        love.graphics.rectangle('fill', 0, 0, sw, sh);
        love.graphics.draw(images['round1'], 192, 32, 0, 2, 2);
        love.graphics.draw(images['round2'], 288, 32, 0, 2, 2);
        love.graphics.draw(images['round3'], 384, 32, 0, 2, 2);

        if one then
            love.graphics.draw(one, 192, 112, 0, 2, 2);
        end
        if two then
            love.graphics.draw(two, 288, 112, 0, 2, 2);
        end
        if three then
            love.graphics.draw(three, 384, 112, 0, 2, 2);
        end

        anim:draw(220, 200);

        PaletteSwitcher.unset();
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return LevelOutro;

--==================================================================================================
-- Created 15.09.14 - 12:52                                                                        =
--==================================================================================================