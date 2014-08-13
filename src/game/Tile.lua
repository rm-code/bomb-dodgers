local Constants = require('src/Constants');
local Explosion = require('src/game/objects/Explosion');
local Upgrade = require('src/game/upgrades/Upgrade');
local UpgradeManager = require('src/game/upgrades/UpgradeManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Tile = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local img = love.graphics.newImage('res/img/floor.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Tile.new()
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local adjTiles = {};
    local danger = 0;
    local content;
    local x, y;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    ---
    -- Randomly decides wether or not to drop an upgrade.
    -- It registers the dropped upgrade with at the UpgradeManager
    -- sets its type and then adds it to the current tile.
    --
    local function dropUpgrade()
        local rnd = love.math.random(0, Constants.UPGRADES.DROPCHANCE);
        if rnd == 0 then
            local id = UpgradeManager.register(x, y);
            local upgrade = Upgrade.new();
            upgrade:setId(id);
            upgrade:setType(CONTENT.FIREUP);
            self:addContent(upgrade);
        elseif rnd == 1 then
            local id = UpgradeManager.register(x, y);
            local upgrade = Upgrade.new();
            upgrade:setId(id);
            upgrade:setType(CONTENT.BOMBUP);
            self:addContent(upgrade);
        end
    end

    ---
    -- @param signal
    --
    local function detonate(signal)
        if content then
            if content:getType() == CONTENT.BOMB then
                content:signal(signal.name);
            elseif content:getType() == CONTENT.SOFTWALL then
                self:removeContent();
                dropUpgrade();
                return;
            elseif content:getType() == CONTENT.HARDWALL then
                return;
            end
        else
            if signal.direction == 'all' then
                self:addContent(Explosion.new('origin'));
            else
                if signal.strength == 0 then
                    self:addContent(Explosion.new('end' .. signal.direction));
                else
                    self:addContent(Explosion.new(signal.direction));
                end
            end
        end

        -- Send the explosion to the neighbouring tiles.
        if signal.strength > 0 then
            if signal.direction == 'all' then
                if adjTiles.north then adjTiles.north:signal({ name = 'detonate', strength = signal.strength - 1, direction = 'north' }); end
                if adjTiles.south then adjTiles.south:signal({ name = 'detonate', strength = signal.strength - 1, direction = 'south' }); end
                if adjTiles.west then adjTiles.west:signal({ name = 'detonate', strength = signal.strength - 1, direction = 'west' }); end
                if adjTiles.east then adjTiles.east:signal({ name = 'detonate', strength = signal.strength - 1, direction = 'east' }); end
            else
                adjTiles[signal.direction]:signal({ name = 'detonate', strength = signal.strength - 1, direction = signal.direction });
            end
        end
    end

    ---
    -- @param signal
    --
    local function plantbomb(signal)
        if content then
            if content:getType() == CONTENT.SOFTWALL then
                return;
            elseif content:getType() == CONTENT.HARDWALL then
                return;
            elseif danger > signal.strength + 1 then
                return;
            end
        end
        danger = danger + signal.strength + 1;

        -- Send the explosion to the neighbouring tiles.
        if signal.strength > 0 then
            if signal.direction == 'all' then
                if adjTiles.north then adjTiles.north:signal({ name = 'plantbomb', strength = signal.strength - 1, direction = 'north' }); end
                if adjTiles.south then adjTiles.south:signal({ name = 'plantbomb', strength = signal.strength - 1, direction = 'south' }); end
                if adjTiles.west then adjTiles.west:signal({ name = 'plantbomb', strength = signal.strength - 1, direction = 'west' }); end
                if adjTiles.east then adjTiles.east:signal({ name = 'plantbomb', strength = signal.strength - 1, direction = 'east' }); end
            else
                adjTiles[signal.direction]:signal({ name = 'plantbomb', strength = signal.strength - 1, direction = signal.direction });
            end
        end
    end

    ---
    -- @param signal
    --
    local function removedanger(signal)
        if content and content:getType() == CONTENT.SOFTWALL then
            return;
        elseif content and content:getType() == CONTENT.HARDWALL then
            return;
        end

        -- Reduce danger value of the tile.
        danger = danger - signal.strength - 1 < 0 and 0 or danger - signal.strength - 1;

        if signal.strength > 0 then
            if signal.direction == 'all' then
                if adjTiles.north then adjTiles.north:signal({ name = 'removedanger', strength = signal.strength - 1, direction = 'north' }); end
                if adjTiles.south then adjTiles.south:signal({ name = 'removedanger', strength = signal.strength - 1, direction = 'south' }); end
                if adjTiles.west then adjTiles.west:signal({ name = 'removedanger', strength = signal.strength - 1, direction = 'west' }); end
                if adjTiles.east then adjTiles.east:signal({ name = 'removedanger', strength = signal.strength - 1, direction = 'east' }); end
            else
                adjTiles[signal.direction]:signal({ name = 'removedanger', strength = signal.strength - 1, direction = signal.direction });
            end
        end
    end

    ---
    -- Moves a bomb along the grid. If it hits an explosion tile it will explode.
    -- If it hits another solid tile it will stop moving.
    -- @param signal
    --
    local function kickbomb(signal)
        local content = self:getContent();
        local tile = adjTiles[signal.direction];

        if tile:getContentType() == CONTENT.EXPLOSION then
            self:removeContent();
            tile:addContent(content);
            tile:signal({ name = 'detonate', strength = content:getStrength(), direction = 'all' });
        elseif tile:isPassable() then
            self:removeContent();
            tile:addContent(content);
            tile:signal(signal);
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    ---
    -- Initialises the tile at the given coordinates.
    -- @param nx
    -- @param ny
    --
    function self:init(nx, ny)
        x = nx;
        y = ny;
    end

    ---
    -- Updates the tile and its content.
    -- @param dt
    --
    function self:update(dt)
        if content then
            content:update(dt);
        end
    end

    ---
    -- Draws the tile and its content.
    --
    function self:draw()
        love.graphics.draw(img, x * TILESIZE, y * TILESIZE);
        -- love.graphics.setColor(0, 0, 0);
        -- love.graphics.print(danger, x * TILESIZE + 16, y * TILESIZE + 16);
        love.graphics.setColor(255, 255, 255);
        if content then
            content:draw(x, y);
        end
    end

    ---
    -- Receives a signal, decides what to do with it and then sends it to
    -- its own content.
    -- @param signal
    --
    function self:signal(signal)
        if signal.name == 'detonate' then
            detonate(signal);
        elseif signal.name == 'kickbomb' then
            kickbomb(signal);
        elseif signal.name == 'plantbomb' then
            plantbomb(signal);
        elseif signal.name == 'removedanger' then
            removedanger(signal);
        end

        -- Signal the content.
        if content then
            content:signal(signal);
        end
    end

    ---
    -- Adds content to the current tile.
    -- @param ncontent
    --
    function self:addContent(ncontent)
        content = ncontent;
        content:setTile(self);
    end

    ---
    -- Removes current content from the tile.
    --
    function self:removeContent()
        if not content then
            return;
        end

        -- Hard walls can never be removed.
        if content:getType() == CONTENT.HARDWALL then
            return;
        end

        -- If the content was a bomb then remove the danger based on that bomb
        -- from the current and adjacent tiles.
        if content:getType() == CONTENT.BOMB then
            self:signal({ name = 'removedanger', strength = content:getStrength(), direction = 'all' });
        end

        -- If the content was an upgrade then remove that upgrade from the upgrade manager aswell.
        if content:getType() == CONTENT.BOMBUP or content:getType() == CONTENT.FIREUP then
            UpgradeManager.remove(content:getId());
        end

        content = nil;
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getDanger()
        return danger;
    end

    function self:getContent()
        return content;
    end

    function self:getX()
        return x;
    end

    function self:getY()
        return y;
    end

    function self:getNeighbours()
        return adjTiles;
    end

    function self:getContentType()
        if content then
            return content:getType();
        end
    end

    function self:isPassable()
        if content then
            return content:isPassable()
        else
            return true;
        end
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setNeighbours(n, s, w, e)
        adjTiles.north, adjTiles.south, adjTiles.west, adjTiles.east = n, s, w, e;
    end

    function self:setDanger(d)
        danger = d;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Tile;

--==================================================================================================
-- Created 24.07.14 - 16:06                                                                        =
--==================================================================================================