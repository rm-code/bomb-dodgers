local Explosion = require('src/game/objects/Explosion');
local BlastBooster = require('src/game/upgrades/BlastBooster');
local CarryBooster = require('src/game/upgrades/CarryBooster');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Tile = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Tile.new()
    local self = {};

    -- The neighbouring tiles.
    local north;
    local south;
    local west;
    local east;

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
        if content then
            content:draw(x, y);
        end
    end

    local function dropUpgrade()
        local rnd = love.math.random(0, 10);
        if rnd == 0 then
            self:addContent(BlastBooster.new());
        elseif rnd == 1 then
            self:addContent(CarryBooster.new());
        end
    end

    local function detonate(detonate)
        -- Place explosion on the current tile.
        if content then
            if content:getType() == 'bomb' then
                content:signal(detonate.name);
            elseif content:getType() == 'softwall' then
                self:removeContent();
                dropUpgrade();
                return;
            elseif content:getType() == 'hardwall' then
                return;
            else
                self:removeContent();
                return;
            end
        else
            self:addContent(Explosion.new());
        end

        -- Send the explosion to the neighbouring tiles.
        if detonate.strength > 0 then
            if detonate.direction == 'all' then
                if north then north:signal({ name = 'detonate', strength = detonate.strength - 1, direction = 'north' }); end
                if south then south:signal({ name = 'detonate', strength = detonate.strength - 1, direction = 'south' }); end
                if west then west:signal({ name = 'detonate', strength = detonate.strength - 1, direction = 'west' }); end
                if east then east:signal({ name = 'detonate', strength = detonate.strength - 1, direction = 'east' }); end
            elseif north and detonate.direction == 'north' then
                north:signal({ name = 'detonate', strength = detonate.strength - 1, direction = 'north' });
            elseif south and detonate.direction == 'south' then
                south:signal({ name = 'detonate', strength = detonate.strength - 1, direction = 'south' });
            elseif west and detonate.direction == 'west' then
                west:signal({ name = 'detonate', strength = detonate.strength - 1, direction = 'west' });
            elseif east and detonate.direction == 'east' then
                east:signal({ name = 'detonate', strength = detonate.strength - 1, direction = 'east' });
            end
        end
    end

    local function kickbomb(signal)
        if signal.direction == 'north' then
            if north and north:getContentType() == 'explosion' then
                local strength = content:getStrength();
                north:addContent(content);
                self:removeContent();
                north:signal({ name = 'detonate', strength = strength, direction = 'all' });
            elseif north and north:isPassable() then
                north:addContent(content);
                self:removeContent();
                north:signal(signal);
            end
        elseif signal.direction == 'south' then
            if south and south:getContentType() == 'explosion' then
                local strength = content:getStrength();
                south:addContent(content);
                self:removeContent();
                south:signal({ name = 'detonate', strength = strength, direction = 'all' });
            elseif south and south:isPassable() then
                south:addContent(content);
                self:removeContent();
                south:signal(signal);
            end
        elseif signal.direction == 'west' then
            if west and west:getContentType() == 'explosion' then
                local strength = content:getStrength();
                west:addContent(content);
                self:removeContent();
                west:signal({ name = 'detonate', strength = strength, direction = 'all' });
            elseif west and west:isPassable() then
                west:addContent(content);
                self:removeContent();
                west:signal(signal);
            end
        elseif signal.direction == 'east' then
            if east and east:getContentType() == 'explosion' then
                local strength = content:getStrength();
                east:addContent(content);
                self:removeContent();
                east:signal({ name = 'detonate', strength = strength, direction = 'all' });
            elseif east and east:isPassable() then
                east:addContent(content);
                self:removeContent();
                east:signal(signal);
            end
        end
    end

    function self:signal(signal)
        if signal.name == 'detonate' then
            detonate(signal);
        elseif signal.name == 'kickbomb' then
            kickbomb(signal);
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
        content = nil;
    end

    function self:setNeighbours(n, s, w, e)
        north, south, west, east = n, s, w, e;
    end

    function self:isPassable()
        if content then
            if content:getType() == 'softwall' or content:getType() == 'bomb' or content:getType() == 'hardwall' then
                return false;
            elseif content:getType() == 'explosion' then
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

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Tile;

--==================================================================================================
-- Created 24.07.14 - 16:06                                                                        =
--==================================================================================================