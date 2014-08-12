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

                -- Add walls.
                if type == 0 then
                    if love.math.random(0, 3) == 1 then
                        grid[x][y]:addContent(SoftWall.new());
                    end
                elseif type == 1 then
                    grid[x][y]:addContent(HardWall.new());
                end
            end
        end

        -- Set neighbours.
        for x = 1, #grid do
            for y = 1, #grid[x] do
                local n = self:getTile(x, y - 1);
                local s = self:getTile(x, y + 1);
                local w = self:getTile(x - 1, y);
                local e = self:getTile(x + 1, y);
                grid[x][y]:setNeighbours(n, s, w, e);
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

    function self:getTile(x, y)
        return grid[x] and grid[x][y] or false;
    end

    function self:getAdjacentTiles(x, y)
        return self:getTile(x, y):getNeighbours();
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