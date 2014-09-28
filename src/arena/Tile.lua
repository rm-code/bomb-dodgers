--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local Explosion = require('src/arena/objects/Explosion');
local Bomb = require('src/arena/objects/Bomb');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Tile = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Tile.new(x, y)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local x = x;
    local y = y;
    local adjTiles;
    local content;
    local danger = 0;
    local tilesheet;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:draw()
        if content then
            content:draw();
        end
    end

    function self:update(dt)
        if content then
            content:update(dt);
        end
    end

    function self:addContent(ncontent)
        content = ncontent;
        content:setParent(self);
    end

    function self:clearContent()
        content = nil;
    end

    function self:explode(radius, direction)
        if not content and radius > 0 then
            self:addContent(Explosion.new(radius, x, y));
            adjTiles[direction]:explode(radius - 1, direction);
        elseif radius > 0 then
            content:explode(radius, direction, adjTiles);
        end
    end

    function self:increaseDanger(radius, direction)
        if content and radius > 0 then
            content:increaseDanger(radius, direction, adjTiles);
        elseif radius > 0 then
            self:setDanger(radius);
            adjTiles[direction]:increaseDanger(radius - 1, direction);
        end
    end

    function self:decreaseDanger(radius, direction)
        if content and radius > 0 then
            content:decreaseDanger(radius, direction, adjTiles);
        elseif radius > 0 then
            self:setDanger(-radius);
            adjTiles[direction]:decreaseDanger(radius - 1, direction);
        end
    end

    function self:plantBomb(radius, entity)
        local bomb = Bomb.new(x, y);
        bomb:setBlastRadius(radius);
        bomb:setOwner(entity);
        self:addContent(bomb);

        content:increaseDanger(radius, 'all', adjTiles);
    end

    function self:kickBomb(direction)
        content:setDirection(direction);
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getX()
        return x;
    end

    function self:getY()
        return y;
    end

    function self:getRealX()
        return x * Constants.TILESIZE;
    end

    function self:getRealY()
        return y * Constants.TILESIZE;
    end

    function self:getAdjacentTiles()
        return adjTiles;
    end

    function self:isPassable()
        return not content or content:isPassable();
    end

    function self:isSafe()
        if danger > 0 or (content and content:getType() == CONTENT.EXPLOSION) then
            return false;
        else
            return true;
        end
    end

    function self:getContentType()
        return not content or content:getType();
    end

    function self:getContent()
        return content;
    end

    function self:getTileSheet()
        return tilesheet;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setAdjacentTiles(n, s, e, w)
        adjTiles = adjTiles or {};
        adjTiles['n'] = n;
        adjTiles['s'] = s;
        adjTiles['e'] = e;
        adjTiles['w'] = w;
    end

    function self:setDanger(nd)
        danger = danger + nd < 0 and 0 or danger + nd;
    end

    function self:setTileSheet(ts)
        tilesheet = ts;
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