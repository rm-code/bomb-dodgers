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

local Random = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Random.new(fsm, npc)
    local self = {};

    local results = {};
    local timer = 0.5;
    local direction;
    local prevDirection;
    local possibleMove = true;
    local curTile;
    local walkedTiles = 0;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function getRndDirection(curD, preD)
        -- Clear results table.
        for i = 1, #results do
            results[i] = nil;
        end

        local adjTiles = npc:getAdjacentTiles();
        for dir, tile in pairs(adjTiles) do
            if dir ~= curD and dir ~= preD and tile:isPassable() and tile:isSafe() and dir ~= prevDirection then
                -- Store valid directions in table.
                results[#results + 1] = dir;
            end
        end

        -- Randomly return one of the valid directions.
        if #results > 0 then
            return results[love.math.random(1, #results)];
        end
    end

    local function getPrevDirection(curDirection)
        if curDirection == 'n' then
            return 's';
        elseif curDirection == 's' then
            return 'n';
        elseif curDirection == 'e' then
            return 'w';
        elseif curDirection == 'w' then
            return 'e';
        end
    end

    local function findAltRoute()
        if love.math.random(0, 1) == 0 then
            local tmp = getRndDirection(direction, prevDirection);
            if tmp then
                direction = tmp;
                prevDirection = getPrevDirection(direction);
            end
        end
    end

    local function isSafeMove(dir)
        local adjTiles = npc:getAdjacentTiles();
        if adjTiles[dir] and adjTiles[dir]:isSafe() then
            return true;
        end
    end

    local function tryToPlant()
        local adjTiles = npc:getAdjacentTiles();
        if npc:isSafeToPlant(adjTiles) and npc:isGoodToPlant(adjTiles, npc:getX(), npc:getY(), npc:getBlastRadius()) then
            npc:plantBomb();
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:enter()
        direction = getRndDirection();
        prevDirection = getPrevDirection(direction);
        curTile = npc:getTile();
    end

    function self:update(dt)
        if not npc:getTile():isSafe() then
            fsm:switch('evade');
        end

        if walkedTiles > 10 then
            fsm:switch('move');
        end

        if possibleMove and isSafeMove(direction) then
            possibleMove = npc:move(dt, direction);
        else
            direction = getRndDirection();
            if direction or timer <= 0 then
                prevDirection = getPrevDirection(direction);
                possibleMove = true;
                timer = 0.5;
            else
                timer = timer - dt;
                npc:move();
            end
        end

        if npc:getTile() ~= curTile then
            findAltRoute();
            curTile = npc:getTile();
            walkedTiles = walkedTiles + 1;

            tryToPlant();
        end
    end

    function self:exit()
        for i = 1, #results do
            results[i] = nil;
        end

        timer = 0.5;
        direction = nil;
        prevDirection = nil;
        possibleMove = true;
        curTile = nil;
        walkedTiles = 0;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Random;

--==================================================================================================
-- Created 22.09.14 - 05:20                                                                        =
--==================================================================================================
