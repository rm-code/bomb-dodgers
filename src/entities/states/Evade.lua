local Constants = require('src/Constants');
local State = require('src/entities/states/State');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Evade = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Evade.new(manager, npc)
    local self = State.new();

    local npc = npc;
    local manager = manager;

    -- ------------------------------------------------
    -- Private Function
    -- ------------------------------------------------

    local function checkAdjacentTiles(adjTiles)
        for _, tile in pairs(adjTiles) do
            if tile:isPassable() and tile:isSafe() then
                return true;
            end
        end
    end

    local function evadeBombs(npc)
        local adjTiles = npc:getAdjacentTiles();

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

    function self:enter()
        -- print("Enter state: Evade");
    end

    function self:update()
        local direction = evadeBombs(npc);
        if direction then
            npc:move(direction);
        end

        if npc:getTile():isSafe() then
            manager:switch('walk');
        end
    end

    function self:exit()
        -- print("Exit state: Evade");
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Evade;

--==================================================================================================
-- Created 13.08.14 - 18:16                                                                        =
--==================================================================================================