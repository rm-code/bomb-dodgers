--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local PlayerManager = require('src/entities/dodgers/PlayerManager');
local ResourceManager = require('lib/ResourceManager');
local AniMAL = require('lib/AniMAL');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Missile = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local anim;

-- Register module with resource manager.
ResourceManager.register(Missile);

---
-- Load images.
--
function Missile.loadImages()
    local img = ResourceManager.loadImage('res/img/boss/pew.png');
    anim = AniMAL.new(img, 24, 24, 0.2);
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Missile.new(arena, pos, x, y)
    local self = {};

    local radius = 60;
    local gridX, gridY = x, y;
    local realX, realY = gridX * 32, gridY * 32;
    local ox, oy = realX, realY;
    local dead = false;
    local angle = pos == 'n' and 0 or pos == 's' and 180 or pos == 'e' and 90 or pos == 'w' and 270;

    local function move(dt)
        realX = ox + radius * math.cos(math.rad(angle));
        realY = oy + radius * math.sin(math.rad(angle));

        gridX = math.floor((realX / Constants.TILESIZE) + 0.5);
        gridY = math.floor((realY / Constants.TILESIZE) + 0.5);
    end

    function self:update(dt)
        anim:update(dt);

        angle = angle + dt * 100;

        move(dt);

        -- Check for collision with player.
        local player = PlayerManager.getClosest(gridX, gridY);
        if player:getX() == gridX and player:getY() == gridY then
            player:setDead(true);
            return;
        end
    end

    function self:draw()
        anim:draw(realX, realY);
        -- love.graphics.setColor(0, 0, 0);
        -- love.graphics.rectangle('fill', gridX * 32, gridY * 32, 32, 32);
        -- love.graphics.setColor(255, 255, 255);
    end

    function self:isDead()
        return dead;
    end

    function self:setOrigin(x, y)
        ox, oy = x, y;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Missile;

--==================================================================================================
-- Created 26.09.14 - 15:54                                                                        =
--==================================================================================================