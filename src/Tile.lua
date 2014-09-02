local Constants = require('src/Constants');
local Explosion = require('src/objects/Explosion');
local Bomb = require('src/objects/Bomb');

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

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:draw()
        love.graphics.draw(img, x * TILESIZE, y * TILESIZE);

        if content then
            content:draw();
        end

        -- love.graphics.setColor(255, 0, 0);
        -- love.graphics.print(danger, x * TILESIZE + 16, y * TILESIZE + 16);
        -- love.graphics.setColor(255, 255, 255);
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
            self:addContent(Explosion.new(x, y));
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
        content:move(direction);
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
        danger = danger + nd;
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