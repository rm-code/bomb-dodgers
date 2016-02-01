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

local Math = require('lib/Math');
local Constants = require('src/Constants');
local PlayerManager = require('src/entities/dodgers/PlayerManager');
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Minion = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Minion);

---
-- Load images.
--
function Minion.loadImages()
    images['minion'] = ResourceManager.loadImage('res/img/boss/minion.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Minion.new(arena, x, y)
    local self = {};

    local gridX, gridY = x, y;
    local realX, realY = gridX * 32, gridY * 32;
    local speed = 45;
    local dead = false;
    local validDirections = {};
    local prevTile;
    local lerpFactor = 18;

    local function rndDirection()
        local adjTiles = arena:getAdjacentTiles(gridX, gridY);

        for i = 1, #validDirections do
            validDirections[i] = nil;
        end

        for dir, tile in pairs(adjTiles) do
            if tile:isPassable() and tile ~= prevTile then
                validDirections[#validDirections + 1] = dir;
            end
        end

        return validDirections[love.math.random(1, #validDirections > 0 and #validDirections or 1)];
    end

    local function move(dt, dir)
        if dir == 'n' then
            realY = realY - 1 * speed * dt;
            realX = Math.lerp(realX, gridX * Constants.TILESIZE, lerpFactor * dt);
        elseif dir == 's' then
            realY = realY + 1 * speed * dt;
            realX = Math.lerp(realX, gridX * Constants.TILESIZE, lerpFactor * dt);
        elseif dir == 'e' then
            realX = realX + 1 * speed * dt;
            realY = Math.lerp(realY, gridY * Constants.TILESIZE, lerpFactor * dt);
        elseif dir == 'w' then
            realX = realX - 1 * speed * dt;
            realY = Math.lerp(realY, gridY * Constants.TILESIZE, lerpFactor * dt);
        end
    end

    local tmpX, tmpY;
    local dir = rndDirection();
    function self:update(dt)
        if arena:getTile(gridX, gridY):getContentType() == Constants.CONTENT.EXPLOSION then
            dead = true;
        end

        move(dt, dir);

        tmpX = math.floor((realX / Constants.TILESIZE) + 0.5);
        tmpY = math.floor((realY / Constants.TILESIZE) + 0.5);
        if tmpX ~= gridX or tmpY ~= gridY then
            prevTile = arena:getTile(gridX, gridY);
            gridX = tmpX;
            gridY = tmpY;
            dir = rndDirection();
        end

        -- Check for collision with player.
        local player = PlayerManager.getClosest(gridX, gridY);
        if player:getX() == gridX and player:getY() == gridY then
            player:setDead(true);
            return;
        end
    end

    function self:draw()
        love.graphics.draw(images.minion, realX, realY);
    end

    function self:isDead()
        return dead;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Minion;

--==================================================================================================
-- Created 26.09.14 - 16:30                                                                        =
--==================================================================================================