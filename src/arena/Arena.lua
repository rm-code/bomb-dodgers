--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local Tile = require('src/arena/Tile');
local SoftWall = require('src/arena/objects/SoftWall');
local HardWall = require('src/arena/objects/HardWall');
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Arena = {}

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};
images.stonegarden = {};
images.desert = {};

-- Register module with resource manager.
ResourceManager.register(Arena);

---
-- Load images.
--
function Arena.loadImages()
    images.stonegarden['floor'] = ResourceManager.loadImage('res/img/levels/stonegarden/floor.png');
    images.stonegarden['hwall'] = ResourceManager.loadImage('res/img/levels/stonegarden/hardwall.png');
    images.stonegarden['swall'] = ResourceManager.loadImage('res/img/levels/stonegarden/softwall.png');

    images.desert['floor'] = ResourceManager.loadImage('res/img/levels/desert/floor.png');
    images.desert['hwall'] = ResourceManager.loadImage('res/img/levels/desert/hardwall.png');
    images.desert['swall'] = ResourceManager.loadImage('res/img/levels/desert/softwall.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Arena.new(ts)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local grid;
    local canvas;
    local tilesheet = ts or 'stonegarden';

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    ---
    -- Places hardwalls at the positions which are predetermined
    -- by the loaded grid layout. Randomly add soft walls at
    -- free places all over the grid.
    -- @param grid - The grid to fill.
    --
    local function placeWalls(grid, suppressSoftwalls)
        for x = 1, #grid do
            for y = 1, #grid[x] do
                local type = grid[x][y];
                grid[x][y] = Tile.new(x, y);
                grid[x][y]:setTileSheet(tilesheet);

                -- Add walls.
                if type == 1 then
                    grid[x][y]:addContent(HardWall.new(x, y));
                elseif type == 0 then
                    if love.math.random(0, 3) == 0 and not suppressSoftwalls then
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

    local function renderToCanvas(canvas, grid)
        canvas:clear();

        -- Draw to canvas.
        canvas:renderTo(function()
            for x = 1, #grid do
                for y = 1, #grid[x] do
                    if grid[x][y]:getContentType() == CONTENT.HARDWALL then
                        love.graphics.draw(images[tilesheet]['hwall'], (x - 1) * TILESIZE, (y - 1) * TILESIZE);
                    else
                        love.graphics.draw(images[tilesheet]['floor'], (x - 1) * TILESIZE, (y - 1) * TILESIZE);
                    end
                end
            end
        end)
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

    function self:reset(level, suppressSoftwalls)
        for x = 1, #grid do
            for y = 1, #grid[x] do
                local tile = grid[x][y];
                tile:setTileSheet(level);

                -- Add walls.
                if tile:getContentType() == CONTENT.HARDWALL then
                    -- Do nothing.
                elseif tile:getContentType() == CONTENT.SOFTWALL then
                    if love.math.random(0, 3) > 0 or suppressSoftwalls then
                        tile:clearContent();
                    end
                else
                    if love.math.random(0, 3) == 0 and not suppressSoftwalls then
                        tile:addContent(SoftWall.new(x, y));
                    else
                        tile:clearContent();
                    end
                end
                tile:setDanger(-1000);
            end
        end

        renderToCanvas(canvas, grid);
    end

    function self:init(toLoad, suppressSoftwalls)
        -- Loads the basic grid layout of a level.
        grid = love.filesystem.load(toLoad)();

        -- Create canvas.
        canvas = love.graphics.newCanvas(#grid * TILESIZE, #grid[1] * TILESIZE);

        -- Fills the grid with
        placeWalls(grid, suppressSoftwalls);

        -- Set neighbours.
        setTileNeighbours(grid);

        renderToCanvas(canvas, grid);
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
        love.graphics.draw(canvas, TILESIZE, TILESIZE);

        for x = 1, #grid do
            for y = 1, #grid[x] do
                if grid[x][y]:getContentType() == CONTENT.SOFTWALL then
                    love.graphics.draw(images[tilesheet]['swall'], x * TILESIZE, y * TILESIZE);
                end
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
    -- Setters
    -- ------------------------------------------------

    function self:setTilesheet(ntilesheet)
        tilesheet = ntilesheet;
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