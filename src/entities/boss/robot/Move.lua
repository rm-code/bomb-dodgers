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

local Move = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Move.new(fsm, entity)
    local self = {};

    local direction = 'e';
    local lastRow;
    local missileTimer = 3;
    local minionTimer = 0;

    local function newDirection(direction, adjTiles)
        local ndir;
        if direction == 's' or direction == 'n' then
            ndir = adjTiles['e']:isPassable() and 'e' or 'w';
        elseif direction == 'e' or direction == 'w' then
            ndir = love.math.random(0, 1) == 0 and 'n' or 's';
        end
        return ndir;
    end

    function self:enter()
        lastRow = entity:getY();
    end

    function self:update(dt)
        local adjTiles = entity:getAdjacentTiles();

        if adjTiles[direction] then
            if math.abs(entity:getY() - lastRow) >= 2 then
                direction = newDirection(direction, adjTiles);
                lastRow = entity:getY();
            end

            if not entity:move(dt, direction) then
                direction = newDirection(direction, adjTiles);
            end
        end

        missileTimer = missileTimer - dt;
        if missileTimer <= 0 and entity:getMissileCount() == 0 then
            entity:shoot();
            missileTimer = 3;
        end

        minionTimer = minionTimer - dt;
        if minionTimer <= 0 and entity:getMinionCount() == 0 then
            entity:releaseMinions();
            minionTimer = 3;
        end
    end

    function self:exit()
        direction = 'e';
        missileTimer = 3;
        minionTimer = 0;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Move;

--==================================================================================================
-- Created 22.09.14 - 05:12                                                                        =
--==================================================================================================