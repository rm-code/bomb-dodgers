--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local UpgradeManager = require('src/upgrades/UpgradeManager');
local PlayerManager = require('src/entities/PlayerManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Walk = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Walk.new(manager, npc)
    local self = {};

    local npc = npc;
    local manager = manager;

    local tarX, tarY;
    local targetDir;
    local targetTile;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function aquireTarget(x, y)
        local playerX, playerY = PlayerManager.getClosestPlayer(x, y);
        local upgradeX, upgradeY = UpgradeManager.getClosestUpgrade(x, y);

        if upgradeX and upgradeY then
            if math.abs(x - upgradeX) + math.abs(y - upgradeY) < math.abs(x - playerX) + math.abs(y - playerY) then
                return upgradeX, upgradeY;
            end
        end

        return playerX, playerY;
    end

    ---
    -- This function returns the coordinates of a nearby player or upgrade,
    -- which can then be used to find a path for walking to that target.
    -- @param x
    -- @param y
    --
    local function getBestTile(tarX, tarY)
        local adjTiles = npc:getAdjacentTiles();
        local bestDir;
        local bestTile;
        local cost = 10000;

        for dir, tile in pairs(adjTiles) do
            if tile:isPassable() and tile:isSafe() and tile ~= npc:getPreviousTile() then

                local ncost = math.abs(tile:getX() - tarX) + math.abs(tile:getY() - tarY);
                if ncost < cost then
                    cost = ncost;
                    bestDir = dir;
                    bestTile = tile;
                end
            end
        end

        return bestTile, bestDir;
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:enter()
        print('Enter: Walk');

        -- Aquire new target which we will try to move to.
        tarX, tarY = aquireTarget(npc:getX(), npc:getY());
        targetTile, targetDir = getBestTile(tarX, tarY)
        npc:setPreviousTile(npc:getTile());
    end

    function self:update(dt)
        local curTile = npc:getTile();

        if not targetTile then
            manager:switch('idle');
        elseif targetTile ~= curTile then
            npc:move(targetDir);
            return;
        else
            manager:switch('idle');
        end
    end

    function self:exit()
        tarX, tarY = nil;
        targetDir = nil;
        targetTile = nil;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Walk;

--==================================================================================================
-- Created 13.08.14 - 18:09                                                                        =
--==================================================================================================