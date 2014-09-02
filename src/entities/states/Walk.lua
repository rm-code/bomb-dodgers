local Constants = require('src/Constants');
local State = require('src/entities/states/State');
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
    local self = State.new();

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
            if math.abs(playerY - y) <= blastRadius then
                return true;
            end
        elseif playerY == y then
            if math.abs(playerX - x) <= blastRadius then
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
            return love.math.random(0, 1) == 0 and 'n' or love.math.random(0, 1) == 0 and 'e' or 'w';
        elseif curX == tarX and curY < tarY then
            return love.math.random(0, 1) == 0 and 's' or love.math.random(0, 1) == 0 and 'e' or 'w';
        elseif curX > tarX and curY == tarY then
            return love.math.random(0, 1) == 0 and 'w' or love.math.random(0, 1) == 0 and 'n' or 's';
        elseif curX < tarX and curY == tarY then
            return love.math.random(0, 1) == 0 and 'e' or love.math.random(0, 1) == 0 and 'n' or 's';
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

    function self:enter()
        -- print("Enter state: Walk");
    end

    function self:update(dt)
        local tile = npc:getTile();
        local adjTiles = npc:getAdjacentTiles();
        local x, y = npc:getPosition();
        local radius = npc:getBlastRadius();

        if not tile:isSafe() then
            manager:switch('evade');
            return;
        end

        if isGoodToPlant(adjTiles, x, y, radius) and isSafeToPlant(adjTiles) then
            npc:plantBomb();
            return;
        end

        local tarX, tarY = aquireTarget(x, y);
        local direction = getDirection(x, y, tarX, tarY);
        if direction and adjTiles[direction]:isSafe() then
            npc:move(direction);
        end
    end

    function self:exit()
        -- print("Exit state: Walk");
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