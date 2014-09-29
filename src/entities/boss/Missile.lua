--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local PlayerManager = require('src/entities/PlayerManager');
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Missile = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local imgs = {};

-- Register module with resource manager.
ResourceManager.register(Missile);

---
-- Load images.
--
function Missile.loadImages()
    imgs['n'] = ResourceManager.loadImage('res/img/boss/missile_n.png');
    imgs['s'] = ResourceManager.loadImage('res/img/boss/missile_s.png');
    imgs['e'] = ResourceManager.loadImage('res/img/boss/missile_e.png');
    imgs['w'] = ResourceManager.loadImage('res/img/boss/missile_w.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Missile.new(arena, dir, x, y)
    local self = {};

    local gridX, gridY = x, y;
    local realX, realY = gridX * 32, gridY * 32;
    local speed = 200;
    local dead = false;
    local sprite = dir == 'n' and imgs.n or dir == 's' and imgs.s or dir == 'w' and imgs.w or dir == 'e' and imgs.e;

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
        love.graphics.draw(sprite, realX, realY);
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