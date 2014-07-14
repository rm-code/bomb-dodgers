local Arena = {}

function Arena.new()
    local self = {};

    local tileSize = 32;
    local grid;
    local explosions = {};
    local explosionDelay = 40;

    function self:init()
        grid = love.filesystem.load('res/grid.lua')();

        for x = 1, #grid do
            explosions[x] = {};
            for y = 1, #grid[x] do
                explosions[x][y] = 0;
            end
        end
    end

    function self:draw()
        for x = 1, #grid do
            for y = 1, #grid[x] do
                if grid[x][y] == 1 then
                    love.graphics.rectangle('fill', x * tileSize, y * tileSize, tileSize, tileSize);
                elseif grid[x][y] == 0 then
                    -- love.graphics.rectangle('line', x * tileSize, y * tileSize, tileSize, tileSize);
                end
            end
        end
        for x = 1, #explosions do
            for y = 1, #explosions[x] do
                if explosions[x][y] >= 1 then
                    love.graphics.setColor(255, 0, 0);
                    love.graphics.rectangle('fill', x * tileSize, y * tileSize, tileSize, tileSize);
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

    function self:addExplosion(x, y, strength)
        explosions[x][y] = explosionDelay;

        local n;
        for i = 1, strength do
            n = x + i;
            if explosions[n] and explosions[n][y] and grid[n][y] == 0 then
                explosions[n][y] = explosionDelay;
            else
                break;
            end
        end
        for i = 1, strength do
            n = x - i;
            if explosions[n] and explosions[n][y] and grid[n][y] == 0 then
                explosions[n][y] = explosionDelay;
            else
                break;
            end
        end
        for i = 1, strength do
            n = y + i;
            if explosions[x] and explosions[x][n] and grid[x][n] == 0 then
                explosions[x][n] = explosionDelay;
            else
                break;
            end
        end
        for i = 1, strength do
            n = y - i;
            if explosions[x] and explosions[x][n] and grid[x][n] == 0 then
                explosions[x][n] = explosionDelay;
            else
                break;
            end
        end
    end

    function self:isExplosion(x, y)
        return explosions[x][y] > 0;
    end

    return self;
end

return Arena;

--==================================================================================================
-- Created 14.07.14 - 12:02                                                                        =
--==================================================================================================