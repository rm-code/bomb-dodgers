local Config = require('src/Config');
local Explosion = require('src/game/objects/Explosion');
local BlastBooster = require('src/game/upgrades/BlastBooster');
local CarryBooster = require('src/game/upgrades/CarryBooster');
local UpgradeManager = require('src/game/upgrades/UpgradeManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Tile = {};

local img = love.graphics.newImage('res/img/floor.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Tile.new()
    local self = {};

    -- The neighbouring tiles.
    local adjTiles = {};

    local danger = 0;
    local content;
    local x, y;

    function self:init(nx, ny)
        x = nx;
        y = ny;
    end

    function self:update(dt)
        if content then
            content:update(dt);
        end
    end

    function self:draw()
        love.graphics.draw(img, x * Config.tileSize, y * Config.tileSize);
        love.graphics.setColor(0, 0, 0);
        love.graphics.print(danger, x * Config.tileSize + 16, y * Config.tileSize + 16);
        love.graphics.setColor(255, 255, 255);
        if content then
            content:draw(x, y);
        end
    end

    local function dropUpgrade()
        local rnd = love.math.random(0, 10);
        if rnd == 0 then
            local id = UpgradeManager.register(x, y);
            self:addContent(BlastBooster.new(id));
        elseif rnd == 1 then
            local id = UpgradeManager.register(x, y);
            self:addContent(CarryBooster.new(id));
        end
    end

    local function detonate(signal)
        if content then
            if content:getType() == 'bomb' then
                content:signal(signal.name);
            elseif content:getType() == 'softwall' then
                self:removeContent();
                dropUpgrade();
                return;
            elseif content:getType() == 'hardwall' then
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

    local function plantbomb(signal)
        if content then
            if content:getType() == 'softwall' then
                return;
            elseif content:getType() == 'hardwall' then
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

    local function removedanger(signal)
        if content and content:getType() == 'softwall' then
            return;
        elseif content and content:getType() == 'hardwall' then
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

        if tile:getContentType() == 'explosion' then
            self:removeContent();
            tile:addContent(content);
            tile:signal({ name = 'detonate', strength = content:getStrength(), direction = 'all' });
        elseif tile:isPassable() then
            self:removeContent();
            tile:addContent(content);
            tile:signal(signal);
        end
    end

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

        -- Signal content.
        if content then
            content:signal(signal);
        end
    end

    function self:addContent(ncontent)
        content = ncontent;
        content:setTile(self);
    end

    function self:removeContent()
        if not content then
            return;
        end

        if content:getType() == 'bomb' then
            self:signal({ name = 'removedanger', strength = content:getStrength(), direction = 'all' });
        elseif content:getType() == 'carryboost' or content:getType() == 'blastboost' then
            UpgradeManager.remove(content:getId());
        end
        content = nil;
    end

    function self:setNeighbours(n, s, w, e)
        adjTiles.north, adjTiles.south, adjTiles.west, adjTiles.east = n, s, w, e;
    end

    function self:isPassable()
        if content then
            if content:getType() == 'softwall' or content:getType() == 'bomb' or content:getType() == 'hardwall' then
                return false;
            elseif content:getType() == 'explosion' or content:getType() == 'blastboost' or content:getType() == 'carryboost' then
                return true;
            end
        else
            return true;
        end
    end

    function self:getContentType()
        if content then
            return content:getType();
        end
    end

    function self:getNeighbours()
        return adjTiles;
    end

    function self:getX()
        return x;
    end

    function self:setDanger(d)
        danger = d;
    end

    function self:getDanger()
        return danger;
    end

    function self:getContent()
        return content;
    end

    function self:getY()
        return y;
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