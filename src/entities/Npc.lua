--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local Dodger = require('src/entities/Dodger');
local StateManager = require('src/entities/states/StateManager');
local Move = require('src/entities/states/Move');
local Evade = require('src/entities/states/Evade');
local Random = require('src/entities/states/Random');
local AniMAL = require('lib/AniMAL');
local ResourceManager = require('lib/ResourceManager');
local NpcManager = require('src/entities/NpcManager');
local PlayerManager = require('src/entities/PlayerManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local NPC = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(NPC);

---
-- Load images.
--
function NPC.loadImages()
    images['idleN'] = ResourceManager.loadImage('res/img/enemy/idle_north.png');
    images['idleS'] = ResourceManager.loadImage('res/img/enemy/idle_south.png');
    images['walkN'] = ResourceManager.loadImage('res/img/enemy/walk_north.png');
    images['walkS'] = ResourceManager.loadImage('res/img/enemy/walk_south.png');
    images['walkE'] = ResourceManager.loadImage('res/img/enemy/walk_east.png');
    images['walkW'] = ResourceManager.loadImage('res/img/enemy/walk_west.png');

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

function NPC.new(arena, x, y)
    local self = Dodger.new(arena, x, y, images.anims);

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local fsm = StateManager.new();

    local states = {};
    states.move = Move.new(fsm, self);
    states.random = Random.new(fsm, self);
    states.evade = Evade.new(fsm, self);

    fsm:initStates(states);
    fsm:switch('move');

    local prevTile;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:isSafeToPlant(adjTiles)
        for _, tile in pairs(adjTiles) do
            if tile:isSafe() and tile:isPassable() then
                return true;
            end
        end
    end

    function self:isGoodToPlant(adjTiles, x, y, radius)
        -- Plant bombs next to soft walls.
        for _, tile in pairs(adjTiles) do
            if tile:getContentType() == Constants.CONTENT.SOFTWALL then
                return true;
            end
        end

        -- Plant bombs if player is in bomb's blast radius.
        local player = PlayerManager.getClosest(x, y);
        if player:getX() == x then
            if math.abs(player:getY() - y) < radius then
                return true;
            end
        elseif player:getY() == y then
            if math.abs(player:getX() - x) < radius then
                return true;
            end
        end
    end

    function self:update(dt)
        if self:getTile():getContentType() == Constants.CONTENT.EXPLOSION then
            self:setDead(true);
            return;
        end

        fsm:update(dt);

        self:takeUpgrade(self:getX(), self:getY());
        if self:isActive('snail') or self:isActive('bombdown') then
            self:pulse(dt);
        else
            self:setAlpha(255);
        end
        self:updateAnimation(dt);
        self:updateUpgrades(dt);
    end

    function self:draw()
        self:drawAnimation();
    end

    function self:setPreviousTile(nprevTile)
        prevTile = nprevTile;
    end

    function self:getPreviousTile()
        return prevTile;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return NPC;

--==================================================================================================
-- Created 31.07.14 - 00:47                                                                        =
--==================================================================================================