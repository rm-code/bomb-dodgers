local Constants = require('src/Constants');
local Entity = require('src/game/entities/Entity');
local UpgradeManager = require('src/game/upgrades/UpgradeManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local NPC = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local img = love.graphics.newImage('res/img/dodger.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function NPC.new(arena, x, y)
    local self = Entity.new(arena, x, y);

    local adjTiles = self:getAdjacentTiles(self:getX(), self:getY());

    ---
    -- This determines where the target is in regard to the current position of the
    -- npc. If the target is at a diagonal location then we decide randomly which direction
    -- the npc picks.
    -- @param curX
    -- @param curY
    -- @param tarX
    -- @param tarY
    --
    local function findDirection(curX, curY, tarX, tarY)
        if curX == tarX and curY == tarY then
            return;
        elseif curX == tarX and curY > tarY then
            return 'north';
        elseif curX == tarX and curY < tarY then
            return 'south';
        elseif curX > tarX and curY == tarY then
            return 'west';
        elseif curX < tarX and curY == tarY then
            return 'east';
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

    local function walk(dir, adjTiles)
        if dir and adjTiles[dir]:isPassable()
                and adjTiles[dir]:getDanger() == 0
                and adjTiles[dir]:getContentType() ~= CONTENT.EXPLOSION then
            self:move(dir);
            return true;
        end
    end

    local function evadeBomb(curTile, adjTiles)
        -- If the current tile is in a bomb's radius.
        local safestTile = curTile;
        local direction = 'north';

        -- Look for the tile with the lowest danger value.
        for dir, tile in pairs(adjTiles) do
            if tile:isPassable()
                    and tile:getDanger() <= safestTile:getDanger()
                    and tile:getContentType() ~= CONTENT.EXPLOSION then
                safestTile = tile;
                direction = dir;
                if safestTile:getDanger() == 0 then
                    break;
                end
            end
        end

        self:move(direction);
    end

    local function plantBomb(adjTiles)
        for _, tile in pairs(adjTiles) do
            if tile:getContentType() == CONTENT.SOFTWALL then
                self:plantBomb();
                return true;
            end
        end
    end

    local function findTarget()
        return UpgradeManager.getClosestUpgrade(self:getY(), self:getY());
    end

    -- This is the brain of our AI which decides what the
    -- character should do next.
    local function generateInput(curTile, adjTiles)
        -- Evade bombs.
        if curTile:getDanger() > 0 then
            evadeBomb(curTile, adjTiles);
            return;
        end

        -- Plant bomb -> return to the top of input handling
        -- which means we now are on a bomb tile and
        -- the npc is going to evade that bomb.
        if plantBomb(adjTiles) then
            return;
        end

        -- Do basic pathfind to 10, 10 (Test coordinates).
        local target = findTarget();
        if target then
            local targetDir = findDirection(self:getX(), self:getY(), target.x, target.y);
            if walk(targetDir, adjTiles) then
                return;
            end
        end
    end

    local delay = 0;
    function self:update(dt)
        delay = delay + dt;

        adjTiles = self:getAdjacentTiles(self:getX(), self:getY());

        if delay > 0.2 then
            generateInput(self:getTile(), adjTiles);
            delay = 0;
        end

        if self:getTile():getContentType() == 'explosion' then
            self:kill();
        end
    end

    function self:draw()
        love.graphics.draw(img, self:getX() * TILESIZE, self:getY() * TILESIZE);

        love.graphics.setColor(0, 0, 0);
        for dir, tile in pairs(adjTiles) do
            if not tile:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', tile:getX() * 32, tile:getY() * 32, 32, 32);
            love.graphics.setColor(0, 0, 0);
        end
        love.graphics.setColor(255, 255, 255);
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return NPC;

--==================================================================================================
-- Created 31.07.14 - 00:47                                                                        =
--==================================================================================================