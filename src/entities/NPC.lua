local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local StateManager = require('src/entities/states/StateManager');
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
    states.walk = Walk.new(fsm, self);
    states.evade = Evade.new(fsm, self);

    fsm:initStates(states);
    fsm:switch('walk');

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    local delay = 0;
    function self:update(dt)
        delay = delay + dt;

        if delay > 0.2 then
            fsm:update(dt);
            delay = 0;
        end

        if self:getTile():getContentType() == Constants.CONTENT.EXPLOSION then
            self:kill();
        end

        self:updateCounters(dt);
    end

    function self:draw()
        fsm:draw();
        love.graphics.setColor(255, 255, 255, self:getAlpha());
        love.graphics.draw(img, self:getX() * TILESIZE, self:getY() * TILESIZE);
        love.graphics.setColor(255, 255, 255, 255);
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