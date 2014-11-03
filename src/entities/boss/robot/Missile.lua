--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local PlayerManager = require('src/entities/dodgers/PlayerManager');
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Missile = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Missile);

---
-- Load images.
--
function Missile.loadImages()
    images['sprites'] = ResourceManager.loadImage('res/img/boss/missiles.png');
    images['n'] = love.graphics.newQuad(0, 0, 32, 32, images['sprites']:getDimensions());
    images['s'] = love.graphics.newQuad(32, 0, 32, 32, images['sprites']:getDimensions());
    images['e'] = love.graphics.newQuad(64, 0, 32, 32, images['sprites']:getDimensions());
    images['w'] = love.graphics.newQuad(96, 0, 32, 32, images['sprites']:getDimensions());
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Missile.new(arena, dir, x, y)
    local self = {};

    local gridX, gridY = x, y;
    local realX, realY = gridX * 32, gridY * 32;
    local speed = 150;
    local dead = false;
    local sprite = dir == 'n' and images.n or dir == 's' and images.s or dir == 'w' and images.w or dir == 'e' and images.e;

    local function move(dt, dir)
        if dir == 'n' then
            realY = realY - 1 * speed * dt;
        elseif dir == 's' then
            realY = realY + 1 * speed * dt;
        elseif dir == 'e' then
            realX = realX + 1 * speed * dt;
        elseif dir == 'w' then
            realX = realX - 1 * speed * dt;
        end

        gridX = math.floor((realX / Constants.TILESIZE) + 0.5);
        gridY = math.floor((realY / Constants.TILESIZE) + 0.5);
    end

    function self:update(dt)
        move(dt, dir);

        -- Check for collision with player.
        local player = PlayerManager.getClosest(gridX, gridY);
        if player:getX() == gridX and player:getY() == gridY then
            player:setDead(true);
            return;
        end

        if not arena:getTile(gridX, gridY) then
            dead = true;
        end
    end

    function self:draw()
        love.graphics.draw(images['sprites'], sprite, realX, realY);
    end

    function self:isDead()
        return dead;
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