local Config = require('src/Config');

local Arena = {}

local TILE = {};
TILE.SPACE = 0;
TILE.WALL = 1;
TILE.RUBBLE = 2;

function Arena.new()
    local self = {};

    local grid;
    local explosions = {};
    local explosionDelay = 40;
    local objects = {};

    function self:init()
        grid = love.filesystem.load('res/grid.lua')();

        for x = 1, #grid do
            for y = 1, #grid[x] do
                if grid[x][y] == 0 then
                    if love.math.random(0, 2) == 1 then
                        grid[x][y] = TILE.RUBBLE;
                    end
                end
            end
        end

        for x = 1, #grid do
            explosions[x] = {};
            for y = 1, #grid[x] do
                explosions[x][y] = 0;
            end
        end

        for x = 1, #grid do
            objects[x] = {};
            for y = 1, #grid[x] do
                objects[x][y] = 0;
            end
        end
    end

    function self:draw()
        for x = 1, #grid do
            for y = 1, #grid[x] do
                if grid[x][y] == TILE.WALL then
                    love.graphics.rectangle('fill', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
                elseif grid[x][y] == TILE.SPACE then
                    -- love.graphics.rectangle('line', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
                elseif grid[x][y] == TILE.RUBBLE then
                    love.graphics.setColor(100, 100, 100);
                    love.graphics.rectangle('fill', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
                    love.graphics.setColor(255, 255, 255);
                end
            end
        end
        for x = 1, #explosions do
            for y = 1, #explosions[x] do
                if explosions[x][y] >= 1 then
                    love.graphics.setColor(255, 0, 0);
                    love.graphics.rectangle('fill', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
                    love.graphics.setColor(255, 255, 255);
                end
            end
        end
    end

    function self:update(dt)
        for x = 1, #explosions do
            for y = 1, #explosions[x] do
                if explosions[x][y] > 0 then
                    explosions[x][y] = explosions[x][y] - 1;
                end
            end
        end
    end

    function self:getGrid()
        return grid;
    end

    function self:hasCollision(x, y)
        if grid[x][y] == 0 and objects[x][y] == 0 then
            return false;
        else
            return true;
        end
    end

    function self:addExplosion(x, y, strength)
        explosions[x][y] = explosionDelay;

        local dx;
        for i = 1, strength do
            dx = x + i;
            if grid[dx][y] == TILE.SPACE then
                explosions[dx][y] = explosionDelay;
            elseif grid[dx][y] == TILE.WALL then
                break;
            elseif grid[dx][y] == TILE.RUBBLE then
                grid[dx][y] = 0;
                break;
            end
        end
        for i = 1, strength do
            dx = x - i;
            if grid[dx][y] == TILE.SPACE then
                explosions[dx][y] = explosionDelay;
            elseif grid[dx][y] == TILE.WALL then
                break;
            elseif grid[dx][y] == TILE.RUBBLE then
                grid[dx][y] = 0;
                break;
            end
        end
        local dy;
        for i = 1, strength do
            dy = y + i;
            if grid[x][dy] == TILE.SPACE then
                explosions[x][dy] = explosionDelay;
            elseif grid[x][dy] == TILE.WALL then
                break;
            elseif grid[x][dy] == TILE.RUBBLE then
                grid[x][dy] = 0;
                break;
            end
        end
        for i = 1, strength do
            dy = y - i;
            if grid[x][dy] == TILE.SPACE then
                explosions[x][dy] = explosionDelay;
            elseif grid[x][dy] == TILE.WALL then
                break;
            elseif grid[x][dy] == TILE.RUBBLE then
                grid[x][dy] = 0;
                break;
            end
        end
    end

    function self:isExplosion(x, y)
        return explosions[x][y] > 0;
    end

    function self:removeRubble(x, y, radius)
        for ix = -radius, radius do
            for iy = -radius, radius do
                if grid[x + ix] and grid[x + ix][y + iy] and grid[x + ix][y + iy] == TILE.RUBBLE then
                    grid[x + ix][y + iy] = TILE.SPACE;
                    print("remove rubble");
                end
            end
        end
    end

    function self:setObject(x, y, yesno)
        objects[x][y] = yesno;
    end

    return self;
end

return Arena;

--==================================================================================================
-- Created 14.07.14 - 12:02                                                                        =
--==================================================================================================