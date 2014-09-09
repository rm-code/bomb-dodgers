--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Evade = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Evade.new(manager, npc)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local npc = npc;
    local manager = manager;

    -- ------------------------------------------------
    -- Private Function
    -- ------------------------------------------------

    ---
    -- Checks the tiles around the npc if they are safe
    -- and passable or not.
    -- @param adjTiles - The tiles to check.
    -- @return True if the tiles are passable and safe.
    --
    local function checkAdjacentTiles(adjTiles)
        for _, tile in pairs(adjTiles) do
            if tile:isPassable() and tile:isSafe() then
                return true;
            end
        end
    end

    ---
    -- Searches for a safe tile near to the npc.
    -- @param adjTiles -- The tiles to check.
    --
    local function evadeBombs(adjTiles)
        local bestDirection;
        local shortest = 10000;

        -- Look for a path to a safe tile.
        for dir, tile in pairs(adjTiles) do
            -- Ignore impassable tiles.
            if tile:isPassable() then
                local checkedTiles = 1;

                local currentlyCheckedTile = tile;
                local adjTiles = currentlyCheckedTile:getAdjacentTiles();
                local nextTile = adjTiles[dir];

                -- Check the next tile in the same direction.
                while not currentlyCheckedTile:isSafe() do

                    -- Check the adjacent tiles of the current tile to see if there
                    -- is a quick escape outside of the direct bomb path.
                    if checkAdjacentTiles(adjTiles) then
                        break;
                    else
                        checkedTiles = checkedTiles + 1;

                        currentlyCheckedTile = nextTile;
                        adjTiles = currentlyCheckedTile:getAdjacentTiles();
                        nextTile = adjTiles[dir];
                    end
                end

                -- If the tile is passable and not dangerous compare it
                -- to previously checked tiles and see if it would provide
                -- a shorter way.
                if currentlyCheckedTile:isPassable() and checkedTiles < shortest then
                    shortest = checkedTiles;
                    bestDirection = dir;
                end
            end
        end

        return bestDirection;
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:enter() end

    function self:exit() end

    ---
    -- Checks for a new direction and moves the npc
    -- until a safe tile is reached.
    --
    function self:update(dt)
        local direction = evadeBombs(npc:getAdjacentTiles());
        if direction then
            npc:move(dt, direction);
        end

        if npc:getTile():isSafe() then
            manager:switch('idle');
        end
    end

    -- ------------------------------------------------
    -- Return Object
    -- ------------------------------------------------

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Evade;

--==================================================================================================
-- Created 13.08.14 - 18:16                                                                        =
--==================================================================================================