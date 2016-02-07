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

local Constants = require( 'src.Constants' );
local PlayerManager = require( 'src.entities.dodgers.PlayerManager' );
local ResourceManager = require( 'lib.ResourceManager' );
local AniMAL = require( 'lib.AniMAL' );

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

function Missile.new(arena, dir, x, y)
    local self = {};

    local gridX, gridY = x, y;
    local realX, realY = gridX * 32, gridY * 32;
    local speed = 100;
    local dead = false;

    local function move(dt, dir)
        if dir == 'nw' then
            realY = realY - 1 * speed * dt;
            realX = realX - 1 * speed * dt;
        elseif dir == 'ne' then
            realY = realY - 1 * speed * dt;
            realX = realX + 1 * speed * dt;
        elseif dir == 'sw' then
            realY = realY + 1 * speed * dt;
            realX = realX - 1 * speed * dt;
        elseif dir == 'se' then
            realY = realY + 1 * speed * dt;
            realX = realX + 1 * speed * dt;
        end

        gridX = math.floor((realX / Constants.TILESIZE) + 0.5);
        gridY = math.floor((realY / Constants.TILESIZE) + 0.5);
    end

    function self:update(dt)
        anim:update(dt);

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
        anim:draw(realX, realY);
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
