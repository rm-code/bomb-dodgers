--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

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