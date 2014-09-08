--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local PlayerManager = require('src/entities/PlayerManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Idle = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Idle.new(manager, npc)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local npc = npc;
    local manager = manager;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    ---
    -- This function returns true, if the current tile is a good
    -- place to plant a bomb.
    -- @param npc
    --
    local function isGoodToPlant(adjTiles, x, y, blastRadius)
        -- Plant bombs next to soft walls.
        for _, tile in pairs(adjTiles) do
            if tile:getContentType() == Constants.CONTENT.SOFTWALL then
                return true;
            end
        end

        -- Plant bombs if player is in bomb's blast radius.
        local playerX, playerY = PlayerManager.getClosestPlayer(x, y);
        if playerX == x then
            if math.abs(playerY - y) < blastRadius then
                return true;
            end
        elseif playerY == y then
            if math.abs(playerX - x) < blastRadius then
                return true;
            end
        end
    end

    ---
    -- This function returns true, if it is safe to place a bomb on the
    -- current tile. Currently it only checks if at least one of the
    -- adjacent tiles is safe and therefore offers an escape route.
    -- @param npc
    --
    local function isSafeToPlant(adjTiles)
        for _, tile in pairs(adjTiles) do
            if tile:isSafe() and tile:isPassable() then
                return true;
            end
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:enter() end

    function self:exit() end

    function self:update(dt)
        local tile = npc:getTile();

        if not tile:isSafe() then
            manager:switch('evade');
            return;
        end

        local adjTiles = npc:getAdjacentTiles();
        local x, y = npc:getPosition();
        local radius = npc:getBlastRadius();

        if isGoodToPlant(adjTiles, x, y, radius) and isSafeToPlant(adjTiles) then
            npc:plantBomb();
            return;
        end

        -- Switch to walking state.
        manager:switch('walk');
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Idle;

--==================================================================================================
-- Created 06.09.14 - 09:32                                                                        =
--==================================================================================================