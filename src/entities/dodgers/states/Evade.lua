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

local Constants = require('src/Constants');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Evade = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Evade.new(fsm, npc)
    local self = {};

    local direction;
    local prevDirection;

    local function checkAdjacentTiles(adjTiles)
        for _, tile in pairs(adjTiles) do
            if tile:isPassable() and tile:isSafe() then
                return true;
            end
        end
    end

    local function evadeBombs(adjTiles)
        local bestDirection;
        local shortest;

        -- Look for a path to a safe tile.
        for dir, tile in pairs(adjTiles) do
            if tile:isPassable() and dir ~= prevDirection then
                local checkedTiles = 1;

                local adjTiles = tile:getAdjacentTiles();

                -- Check the next tile in the same direction.
                while not tile:isSafe() do

                    -- Check the adjacent tiles of the current tile to see if there
                    -- is a quick escape outside of the direct bomb path.
                    if checkAdjacentTiles(adjTiles) then
                        break;
                    else
                        checkedTiles = checkedTiles + 1;

                        tile = adjTiles[dir];
                        adjTiles = tile:getAdjacentTiles();
                    end
                end

                -- If the tile is passable and not dangerous compare it
                -- to previously checked tiles and see if it would provide
                -- a shorter way.
                if not shortest or (tile:isPassable() and checkedTiles < shortest) then
                    shortest = checkedTiles;
                    bestDirection = dir;
                end
            end
        end
        return bestDirection;
    end

    local function isSafeMove(dir)
        local adjTiles = npc:getAdjacentTiles();
        if adjTiles[dir] and adjTiles[dir]:getContentType() ~= Constants.CONTENT.EXPLOSION then
            return true;
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

    function self:enter()
        direction = evadeBombs(npc:getAdjacentTiles());
        prevDirection = getPrevDirection(direction);
    end

    function self:update(dt)
        direction = evadeBombs(npc:getAdjacentTiles());
        if direction and isSafeMove(direction) then
            prevDirection = getPrevDirection(direction);
            npc:move(dt, direction);
        end

        if npc:getTile():isSafe() then
            fsm:switch('move');
        end
    end

    function self:exit()
        direction = nil;
        prevDirection = nil;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Evade;

--==================================================================================================
-- Created 22.09.14 - 05:20                                                                        =
--==================================================================================================
