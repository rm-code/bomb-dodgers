local Tile = require('src/game/Tile');
local SoftWall = require('src/game/objects/SoftWall');
local HardWall = require('src/game/objects/HardWall');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Arena = {}

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Arena.new()
    local self = {};

    local grid;

    function self:init()
        grid = love.filesystem.load('res/grid.lua')();

        for x = 1, #grid do
            for y = 1, #grid[x] do
                local type = grid[x][y];
                grid[x][y] = Tile.new();
                grid[x][y]:init(x, y, type, type);
                grid[x][y]:setGrid(grid);

                -- Add walls.
                if type == 0 then
                    if love.math.random(0, 3) == 1 then
                        local wall = SoftWall.new();
                        wall:init(x, y);
                        grid[x][y]:addContent(wall);
                    end
                elseif type == 1 then
                    local wall = HardWall.new();
                    wall:init(x, y);
                    grid[x][y]:addContent(wall);
                end
            end
        end
    end

    function self:draw()
        for x = 1, #grid do
            for y = 1, #grid[x] do
                grid[x][y]:draw();
            end
        end
    end

    function self:update(dt)
        for x = 1, #grid do
            for y = 1, #grid[x] do
                grid[x][y]:update(dt);
            end
        end
    end

    function self:getGrid()
        return grid;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Arena;

--==================================================================================================
-- Created 14.07.14 - 12:02                                                                        =
--==================================================================================================