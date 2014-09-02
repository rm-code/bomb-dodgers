local Constants = require('src/Constants');
local Tile = require('src/Tile');
local SoftWall = require('src/objects/SoftWall');
local HardWall = require('src/objects/HardWall');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Arena = {}

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Arena.new()
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local grid;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    ---
    -- Removes any softwalls that might have been created
    -- at the character spawn points.
    -- @param entities
    --
    function self:clearSpawns(entities)
        for i = 1, #entities do
            local tile = entities[i]:getTile();
            local adjTiles = tile:getAdjacentTiles();

            -- Remove soft wall from current tile.
            if tile:getContentType() == CONTENT.SOFTWALL then
                tile:clearContent();
            end

            -- Remove soft walls from adjacent tiles.
            for _, tile in pairs(adjTiles) do
                if tile:getContentType() == CONTENT.SOFTWALL then
                    tile:clearContent();
                end
            end
        end
    end

    function self:init()
        grid = love.filesystem.load('res/grid.lua')();

        for x = 1, #grid do
            for y = 1, #grid[x] do
                local type = grid[x][y];
                grid[x][y] = Tile.new(x, y);

                -- Add walls.
                if type == 0 then
                    if love.math.random(0, 3) == 1 then
                        grid[x][y]:addContent(SoftWall.new(x, y));
                    end
                elseif type == 1 then
                    grid[x][y]:addContent(HardWall.new(x, y));
                end
            end
        end

        -- Set neighbours.
        local n, s, e, w;
        for x = 1, #grid do
            for y = 1, #grid[x] do
                n = self:getTile(x, y - 1);
                s = self:getTile(x, y + 1);
                e = self:getTile(x + 1, y);
                w = self:getTile(x - 1, y);
                grid[x][y]:setAdjacentTiles(n, s, e, w);
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

    function self:draw()
        for x = 1, #grid do
            for y = 1, #grid[x] do
                grid[x][y]:draw();
            end
        end
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getGrid()
        return grid;
    end

    function self:getTile(x, y)
        return grid[x] and grid[x][y];
    end

    function self:getAdjacentTiles(x, y)
        return grid[x][y]:getAdjacentTiles();
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