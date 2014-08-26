local Constants = require('src/Constants');
local State = require('src/game/entities/states/State');
local UpgradeManager = require('src/game/upgrades/UpgradeManager');
local PlayerManager = require('src/game/entities/PlayerManager');

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

    local function findGoodBombPlace(npc)
        local adjTiles = npc:getAdjacentTiles();

        for _, tile in pairs(adjTiles) do
            if tile:getContentType() == Constants.CONTENT.SOFTWALL then
                return true;
            end
        end

        -- TODO check if player is in reach (ignore blocks in between?)
    end

    local function findSafeBombPlace(npc)
        return true;
    end

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
            return love.math.random(0, 1) == 0 and 'north' or love.math.random(0, 1) == 0 and 'east' or 'west';
        elseif curX == tarX and curY < tarY then
            return love.math.random(0, 1) == 0 and 'south' or love.math.random(0, 1) == 0 and 'east' or 'west';
        elseif curX > tarX and curY == tarY then
            return love.math.random(0, 1) == 0 and 'west' or love.math.random(0, 1) == 0 and 'north' or 'south';
        elseif curX < tarX and curY == tarY then
            return love.math.random(0, 1) == 0 and 'east' or love.math.random(0, 1) == 0 and 'north' or 'south';
        elseif tarX < curX and tarY < curY then
            return love.math.random(0, 1) == 0 and 'north' or 'west';
        elseif tarX > curX and tarY < curY then
            return love.math.random(0, 1) == 0 and 'north' or 'east';
        elseif tarX < curX and tarY > curY then
            return love.math.random(0, 1) == 0 and 'south' or 'west';
        elseif tarX > curX and tarY > curY then
            return love.math.random(0, 1) == 0 and 'south' or 'east';
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:enter()
        print("Enter state: Walk");
    end

    function self:update(dt)
        if not npc:getTile():isSafe() then
            manager:switch('evade');
        end

        if findGoodBombPlace(npc) and findSafeBombPlace(npc) then
            npc:plantBomb();
            return;
        end

        local tarX, tarY = aquireTarget(npc:getX(), npc:getY());
        local direction = getDirection(npc:getX(), npc:getY(), tarX, tarY);
        if direction and npc:getAdjacentTiles()[direction]:isSafe() then
            npc:move(direction);
        end
    end

    function self:exit()
        print("Exit state: Walk");
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