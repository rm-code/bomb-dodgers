local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local StateManager = require('src/entities/states/StateManager');
local Idle = require('src/entities/states/Idle');
local Walk = require('src/entities/states/Walk');
local Evade = require('src/entities/states/Evade');

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

local img = love.graphics.newImage('res/img/enemy.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function NPC.new(arena, x, y)
    local self = Entity.new(arena, x, y);

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
    end

    function self:draw()
        love.graphics.setColor(255, 255, 255, self:getAlpha());
        love.graphics.draw(img, self:getRealX(), self:getRealY());
        love.graphics.setColor(255, 255, 255, 255);
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