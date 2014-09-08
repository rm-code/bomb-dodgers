--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local Tile = require('src/arena/Tile');
local SoftWall = require('src/arena/objects/SoftWall');
local HardWall = require('src/arena/objects/HardWall');

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
    -- Private Functions
    -- ------------------------------------------------

    ---
    -- Places hardwalls at the positions which are predetermined
    -- by the loaded grid layout. Randomly add soft walls at
    -- free places all over the grid.
    -- @param grid - The grid to fill.
    --
    local function placeWalls(grid)
        for x = 1, #grid do
            for y = 1, #grid[x] do
                local type = grid[x][y];
                grid[x][y] = Tile.new(x, y);

                -- Add walls.
                if type == 1 then
                    grid[x][y]:addContent(HardWall.new(x, y));
                elseif type == 0 then
                    if love.math.random(0, 3) == 1 then
                        grid[x][y]:addContent(SoftWall.new(x, y));
                    end
                end
            end
        end
    end

    ---
    -- Sets the four adjacent tiles of each tile on the grid.
    -- @param grid - The grid to iterate over.
    --
    local function setTileNeighbours(grid)
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
        -- Loads the basic grid layout of a level.
        grid = love.filesystem.load('res/empty_level.lua')();

        -- Fills the grid with
        placeWalls(grid);

        -- Set neighbours.
        setTileNeighbours(grid);
    end

    ---
    -- Update all tiles on the grid.
    -- @param dt
    --
    function self:update(dt)
        for x = 1, #grid do
            for y = 1, #grid[x] do
                grid[x][y]:update(dt);
            end
        end
    end

    ---
    -- Draw all tiles on the grid.
    --
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

    ---
    -- Returns the grid.
    --
    function self:getGrid()
        return grid;
    end

    ---
    -- Returns the tile at the given coordinates.
    -- @param x - The x position of the tile to get.
    -- @param y - The y position of the tile to get.
    --
    function self:getTile(x, y)
        return grid[x] and grid[x][y];
    end

    ---
    -- Returns the adjacent tiles of a certain position on the grid.
    -- @param x - The x position of the tile around which to get the adjacent tiles.
    -- @param y - The y position of the tile around which to get the adjacent tiles.
    --
    function self:getAdjacentTiles(x, y)
        return grid[x][y]:getAdjacentTiles();
    end

    -- ------------------------------------------------
    -- Return Object
    -- ------------------------------------------------

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Arena;

--==================================================================================================
-- Created 14.07.14 - 12:02                                                                        =
--==================================================================================================