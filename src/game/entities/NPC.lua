local Config = require('src/Config');
local Entity = require('src/game/entities/Entity');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local NPC = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local img = love.graphics.newImage('res/img/dodger.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function NPC.new(arena, x, y)
    local self = Entity.new(arena, x, y);

    local adjTiles = {};
    adjTiles.north, adjTiles.south, adjTiles.east, adjTiles.west = self:getAdjacentTiles(self:getX(), self:getY());

    local function findDirection(tarX, tarY)
        if tarX == self:getX() and tarY == self:getY() then
            return;
        elseif tarX == self:getX() and tarY < self:getY() then
            return 'north';
        elseif tarX == self:getX() and tarY > self:getY() then
            return 'south';
        elseif tarX < self:getX() and tarY == self:getY() then
            return 'west';
        elseif tarX > self:getX() and tarY == self:getY() then
            return 'east';
        end
    end

    local function walk(adjTiles)
        local moveDir = 'north';
        for dir, tile in pairs(adjTiles) do
            if tile:isPassable()
                    and tile:getDanger() == 0
                    and tile:getContentType() ~= 'explosion' then

                if love.math.random(0, 1) == 0 then
                    moveDir = dir;
                end
            end
        end

        if moveDir then
            self:move(moveDir);
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
                    and tile:getContentType() ~= 'explosion' then
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
            if tile:getContentType() == 'softwall' then
                self:plantBomb();
                return true;
            end
        end
    end

    -- This is the brain of our AI which decides what the
    -- character should do next.
    local function generateInput()
        local curTile = self:getTile();

        -- Update adjacent tiles.
        adjTiles.north, adjTiles.south, adjTiles.east, adjTiles.west = self:getAdjacentTiles(self:getX(), self:getY());

        -- Evade bombs.
        if curTile:getDanger() > 0 then
            evadeBomb(curTile, adjTiles);
            return;
        end

        if plantBomb(adjTiles) then
            return;
        end

        if walk(adjTiles) then
            return;
        end
    end

    local delay = 0;
    function self:update(dt)
        delay = delay + dt;

        if delay > 0.2 then
            generateInput();
            delay = 0;
        end

        if self:getTile():getContentType() == 'explosion' then
            self:kill();
        end
    end

    function self:draw()
        love.graphics.draw(img, self:getX() * Config.tileSize, self:getY() * Config.tileSize);

        love.graphics.setColor(0, 0, 0);
        if adjTiles.north then
            if not adjTiles.north:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', adjTiles.north:getX() * 32, adjTiles.north:getY() * 32, 32, 32);
            love.graphics.setColor(0, 0, 0);
        end

        if adjTiles.south then
            if not adjTiles.south:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', adjTiles.south:getX() * 32, adjTiles.south:getY() * 32, 32, 32);
            love.graphics.setColor(0, 0, 0);
        end

        if adjTiles.east then
            if not adjTiles.east:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', adjTiles.east:getX() * 32, adjTiles.east:getY() * 32, 32, 32);
            love.graphics.setColor(0, 0, 0);
        end

        if adjTiles.west then
            if not adjTiles.west:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', adjTiles.west:getX() * 32, adjTiles.west:getY() * 32, 32, 32);
            love.graphics.setColor(255, 255, 255);
        end
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