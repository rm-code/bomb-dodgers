local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local StateManager = require('src/entities/states/StateManager');
local Idle = require('src/entities/states/Idle');
local Walk = require('src/entities/states/Walk');
local Evade = require('src/entities/states/Evade');
local AniMAL = require('lib/AniMAL');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local NPC = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local anim_idleN = love.graphics.newImage('res/img/enemy/idle_north.png');
local anim_idleS = love.graphics.newImage('res/img/enemy/idle_south.png');
local anim_walkS = love.graphics.newImage('res/img/enemy/walk_south.png');
local anim_walkN = love.graphics.newImage('res/img/enemy/walk_north.png');
local anim_walkW = love.graphics.newImage('res/img/enemy/walk_west.png');
local anim_walkE = love.graphics.newImage('res/img/enemy/walk_east.png');

local anim = {
    idleN = AniMAL.new(anim_idleN, TILESIZE, TILESIZE, 0.2);
    idleS = AniMAL.new(anim_idleS, TILESIZE, TILESIZE, 0.2);
    walkN = AniMAL.new(anim_walkN, TILESIZE, TILESIZE, 0.2);
    walkS = AniMAL.new(anim_walkS, TILESIZE, TILESIZE, 0.2);
    walkE = AniMAL.new(anim_walkE, TILESIZE, TILESIZE, 0.2);
    walkW = AniMAL.new(anim_walkW, TILESIZE, TILESIZE, 0.2);
}

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function NPC.new(arena, x, y)
    local self = Entity.new(arena, x, y, anim);

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local fsm = StateManager.new();

    local states = {};
    states.idle = Idle.new(fsm, self);
    states.walk = Walk.new(fsm, self);
    states.evade = Evade.new(fsm, self);

    fsm:initStates(states);
    fsm:switch('idle');

    local prevTile;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(dt)
        fsm:update(dt);

        if self:getTile():getContentType() == Constants.CONTENT.EXPLOSION then
            self:kill();
        end

        self:updateCounters(dt);
        self:updateAnimation(dt);
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