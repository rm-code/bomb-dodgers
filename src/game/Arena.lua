local Arena = {}

function Arena.new()
    local self = {};

    local tileSize = 32;
    local grid;

    function self:init()
        grid = love.filesystem.load('res/grid.lua')();
        print(grid);
        print(grid[1]);
        print(grid[1][2]);
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
    end

    function self:update(dt)
    end

    return self;
end

return Arena;

--==================================================================================================
-- Created 14.07.14 - 12:02                                                                        =
--==================================================================================================