--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 - 2016 Robert Machmer                                      --
--                                                                               --
-- This software is provided 'as-is', without any express or implied             --
-- warranty. In no event will the authors be held liable for any damages         --
-- arising from the use of this software.                                        --
--                                                                               --
-- Permission is granted to anyone to use this software for any purpose,         --
-- including commercial applications, and to alter it and redistribute it        --
-- freely, subject to the following restrictions:                                --
--                                                                               --
--  1. The origin of this software must not be misrepresented; you must not      --
--      claim that you wrote the original software. If you use this software     --
--      in a product, an acknowledgment in the product documentation would be    --
--      appreciated but is not required.                                         --
--  2. Altered source versions must be plainly marked as such, and must not be   --
--      misrepresented as being the original software.                           --
--  3. This notice may not be removed or altered from any source distribution.   --
--                                                                               --
--===============================================================================--

local Constants = require('src/Constants');
local Tile = require('src/arena/Tile');
local ResourceManager = require('lib/ResourceManager');
local SoftWall = require('src/arena/objects/SoftWall');
local HardWall = require('src/arena/objects/HardWall');
local Upgrade = require('src/arena/objects/Upgrade');

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

-- Register module with resource manager.
ResourceManager.register(Arena);

---
-- Load images.
--
function Arena.loadImages()
    images['tiles'] = ResourceManager.loadImage('res/img/levels/tiles.png');

    images.stone = {};
    images.stone['floor'] = love.graphics.newQuad(1, 1, 32, 32, images['tiles']:getDimensions());
    images.stone['hwall'] = love.graphics.newQuad(35, 1, 32, 32, images['tiles']:getDimensions());
    images.stone['swall'] = love.graphics.newQuad(69, 1, 32, 32, images['tiles']:getDimensions());

    images.desert = {};
    images.desert['floor'] = love.graphics.newQuad(1, 35, 32, 32, images['tiles']:getDimensions());
    images.desert['hwall'] = love.graphics.newQuad(35, 35, 32, 32, images['tiles']:getDimensions());
    images.desert['swall'] = love.graphics.newQuad(69, 35, 32, 32, images['tiles']:getDimensions());

    images.snow = {};
    images.snow['floor'] = love.graphics.newQuad(1, 69, 32, 32, images['tiles']:getDimensions());
    images.snow['hwall'] = love.graphics.newQuad(35, 69, 32, 32, images['tiles']:getDimensions());
    images.snow['swall'] = love.graphics.newQuad(69, 69, 32, 32, images['tiles']:getDimensions());

    images.forest = {};
    images.forest['floor'] = love.graphics.newQuad(1, 103, 32, 32, images['tiles']:getDimensions());
    images.forest['hwall'] = love.graphics.newQuad(35, 103, 32, 32, images['tiles']:getDimensions());
    images.forest['swall'] = love.graphics.newQuad(69, 103, 32, 32, images['tiles']:getDimensions());
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
    local w, h;
    local canvas;
    local tilesheet = ts or 'stone';

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
                        love.graphics.draw(images['tiles'], images[tilesheet]['hwall'], (x - 1) * TILESIZE, (y - 1) * TILESIZE);
                    else
                        love.graphics.draw(images['tiles'], images[tilesheet]['floor'], (x - 1) * TILESIZE, (y - 1) * TILESIZE);
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

    ---
    -- Spawns an upgrade somewhere on the grid.
    -- @param amount
    --
    function self:spawnUpgrades(amount)
        local rndX, rndY;
        local upgrade;
        local count = 0;
        while count < amount do
            rndX, rndY = love.math.random(1, w), love.math.random(1, h);

            -- Only spawn upgrades on free tiles.
            if not grid[rndX][rndY]:getContent() then
                upgrade = Upgrade.new(rndX, rndY, true);
                upgrade:init();

                if upgrade:getUpgradeType() == 'fireup' or upgrade:getUpgradeType() == 'bombup' then
                    grid[rndX][rndY]:addContent(upgrade);
                    count = count + 1;
                end
            end
        end
    end

    function self:init(toLoad, suppressSoftwalls)
        -- Loads the basic grid layout of a level.
        grid = love.filesystem.load(toLoad)();

        -- Save width and height.
        w, h = #grid, #grid[1];

        -- Create canvas.
        canvas = love.graphics.newCanvas(w * TILESIZE, h * TILESIZE);

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
                    love.graphics.draw(images['tiles'], images[tilesheet]['swall'], x * TILESIZE, y * TILESIZE);
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

    ---
    -- Returns the width of the grid.
    --
    function self:getWidth()
        return w;
    end

    ---
    -- Returns the height of the grid.
    --
    function self:getHeight()
        return h;
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
