--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local Dodger = require('src/entities/Dodger');
local InputManager = require('lib/InputManager');
local AniMAL = require('lib/AniMAL');
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Player = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Player);

---
-- Load images.
--
function Player.loadImages()
    images['idleN'] = ResourceManager.loadImage('res/img/player/idle_north.png');
    images['idleS'] = ResourceManager.loadImage('res/img/player/idle_south.png');
    images['walkN'] = ResourceManager.loadImage('res/img/player/walk_north.png');
    images['walkS'] = ResourceManager.loadImage('res/img/player/walk_south.png');
    images['walkE'] = ResourceManager.loadImage('res/img/player/walk_east.png');
    images['walkW'] = ResourceManager.loadImage('res/img/player/walk_west.png');

    images['anims'] = {
        idleN = AniMAL.new(images['idleN'], TILESIZE, TILESIZE, 0.2);
        idleS = AniMAL.new(images['idleS'], TILESIZE, TILESIZE, 0.2);
        walkN = AniMAL.new(images['walkN'], TILESIZE, TILESIZE, 0.2);
        walkS = AniMAL.new(images['walkS'], TILESIZE, TILESIZE, 0.2);
        walkE = AniMAL.new(images['walkE'], TILESIZE, TILESIZE, 0.2);
        walkW = AniMAL.new(images['walkW'], TILESIZE, TILESIZE, 0.2);
    };
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Player.new(arena, x, y)
    local self = Dodger.new(arena, x, y, images.anims);

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function handleInput(dt)
        if InputManager.hasCommand('UP') and InputManager.hasCommand('RIGHT') then
            self:move(dt, 'n', 'e');
        elseif InputManager.hasCommand('UP') and InputManager.hasCommand('LEFT') then
            self:move(dt, 'n', 'w');
        elseif InputManager.hasCommand('DOWN') and InputManager.hasCommand('RIGHT') then
            self:move(dt, 's', 'e');
        elseif InputManager.hasCommand('DOWN') and InputManager.hasCommand('LEFT') then
            self:move(dt, 's', 'w');
        elseif InputManager.hasCommand('UP') then
            self:move(dt, 'n');
        elseif InputManager.hasCommand('DOWN') then
            self:move(dt, 's');
        elseif InputManager.hasCommand('RIGHT') then
            self:move(dt, 'e');
        elseif InputManager.hasCommand('LEFT') then
            self:move(dt, 'w');
        else
            self:move(dt);
        end

        if InputManager.hasCommand('BOMB') then
            self:plantBomb();
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(dt)
        handleInput(dt);

        if self:getTile():getContent() and
                (self:getTile():getContentType() == CONTENT.EXPLOSION
                        or self:getTile():getContent():isHazardous()) then
            self:setDead(true);
            return;
        end

        self:takeUpgrade(self:getX(), self:getY());
        if self:isActive('snail') or self:isActive('bombdown') then
            self:pulse(dt);
        else
            self:setAlpha(255);
        end
        self:updateAnimation(dt);
        self:updateUpgrades(dt);
        self:updateCamera(dt);

        love.audio.setPosition(self:getRealX(), self:getRealY(), 0);
    end

    function self:draw()
        self:drawAnimation();
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Player; --==================================================================================================
-- Created 08.08.14 - 12:29                                                                        =
--==================================================================================================