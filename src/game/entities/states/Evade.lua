local Constants = require('src/Constants');
local State = require('src/game/entities/states/State');

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

    local function checkNeighbours(neighbours)
        for _, neighbour in pairs(neighbours) do
            if neighbour:isPassable() and neighbour:isSafe() then
                return true;
            end
        end
    end

    local function evadeBombs(npc)
        local adjTiles = npc:getAdjacentTiles();

        local bestDirection;
        local shortest = 10000;

        for dir, tile in pairs(adjTiles) do
            -- Ignore impassable tiles.
            if tile:isPassable() then
                local checkedTiles = 1;

                local currentTile = tile;
                local neighbours = currentTile:getNeighbours();
                local nextTile = neighbours[dir];

                -- Check the next tile in the same direction.
                while not currentTile:isSafe() do

                    -- Check the adjacent tiles of the current tile to see if there
                    -- is a quick escape outside of the direct bomb path.
                    if checkNeighbours(neighbours) then
                        break;
                    else
                        checkedTiles = checkedTiles + 1;

                        currentTile = nextTile;
                        neighbours = currentTile:getNeighbours();
                        nextTile = neighbours[dir];
                    end
                end

                -- If the tile is passable and not dangerous compare it
                -- to previously checked tiles and see if it would provide
                -- a shorter way.
                if currentTile:isPassable() and checkedTiles < shortest then
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
        npc:move(direction);

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