--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 Robert Machmer                                             --
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