local Constants = require('src/Constants');
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

    local curTile;
    local tarTile;
    local curX, curY;
    local tarX, tarY;
    local tarDir;

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

    ---
    -- This function returns the coordinates of a nearby player or upgrade,
    -- which can then be used to find a path for walking to that target.
    -- @param x
    -- @param y
    --
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

    local function getDirection(curX, curY, tarX, tarY)
        if curX == tarX and curY == tarY then
            return;
        elseif curX == tarX and curY > tarY then
            return 'n';
        elseif curX == tarX and curY < tarY then
            return 's';
        elseif curX > tarX and curY == tarY then
            return 'e';
        elseif curX < tarX and curY == tarY then
            return 'w';
        elseif tarX < curX and tarY < curY then
            return love.math.random(0, 1) == 0 and 'n' or 'w';
        elseif tarX > curX and tarY < curY then
            return love.math.random(0, 1) == 0 and 'n' or 'e';
        elseif tarX < curX and tarY > curY then
            return love.math.random(0, 1) == 0 and 's' or 'w';
        elseif tarX > curX and tarY > curY then
            return love.math.random(0, 1) == 0 and 's' or 'e';
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(dt)
        local tile = npc:getTile();

        if not tile:isSafe() then
            tarTile = nil;
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


        -- If we haven't got a target yet, calculate a new one.
        if not tarTile then
            local tarX, tarY = aquireTarget(x, y);
            local direction = getDirection(x, y, tarX, tarY);

            -- Save the current and the target tile.
            curTile = tile;
            tarTile = adjTiles[direction];
            tarDir = direction;

            if tarTile:isSafe() then
                npc:move(tarDir);
                return;
            end
        elseif tarTile ~= curTile and tarTile:isSafe() then
            npc:move(tarDir);
            return;
        elseif tarTile == curTile then
            tarTile = nil;
        end
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