local Tile = require('src/game/Tile');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Arena = {}

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Arena.new()
    local self = {};

    local tiles;

    function self:init()
        tiles = love.filesystem.load('res/grid.lua')();

        for x = 1, #tiles do
            for y = 1, #tiles[x] do
                local type = tiles[x][y];
                tiles[x][y] = Tile.new();
                tiles[x][y]:init(x, y, type, type);
                tiles[x][y]:setGrid(tiles);
            end
        end
    end

    function self:draw()
        for x = 1, #tiles do
            for y = 1, #tiles[x] do
                tiles[x][y]:draw();
            end
        end
    end

    function self:update(dt)
        for x = 1, #tiles do
            for y = 1, #tiles[x] do
                tiles[x][y]:update(dt);
            end
        end
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