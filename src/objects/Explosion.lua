local Content = require('src/objects/Content');
local Constants = require('src/Constants');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Explosion = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local origin = love.graphics.newImage('res/img/explosion/origin.png');
local horizontal = love.graphics.newImage('res/img/explosion/middle_hor.png');
local vertical = love.graphics.newImage('res/img/explosion/middle_vert.png');
local endnorth = love.graphics.newImage('res/img/explosion/end_up.png');
local endsouth = love.graphics.newImage('res/img/explosion/end_down.png');
local endeast = love.graphics.newImage('res/img/explosion/end_right.png');
local endwest = love.graphics.newImage('res/img/explosion/end_left.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Explosion.new(x, y)
    local self = Content.new(CONTENT.EXPLOSION, true, x, y);

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local timer = Constants.EXPLOSIONTIMER;
    local sprite = origin;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function pickSprite(adjTiles)
        local n = adjTiles.n;
        local s = adjTiles.s;
        local e = adjTiles.e;
        local w = adjTiles.w;

        if n:getContentType() == CONTENT.EXPLOSION
                and s:getContentType() == CONTENT.EXPLOSION
                and e:getContentType() == CONTENT.EXPLOSION
                and w:getContentType() == CONTENT.EXPLOSION then
            return origin;
        elseif (not n:getContentType() == CONTENT.EXPLOSION or not s:getContentType() == CONTENT.EXPLOSION)
                and e:getContentType() == CONTENT.EXPLOSION
                and w:getContentType() == CONTENT.EXPLOSION then
            return horizontal;
        elseif (not e:getContentType() == CONTENT.EXPLOSION or not w:getContentType() == CONTENT.EXPLOSION)
                and n:getContentType() == CONTENT.EXPLOSION
                and s:getContentType() == CONTENT.EXPLOSION then
            return vertical;
        else
            return origin;
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            self:getParent():clearContent();
        end

        sprite = pickSprite(self:getParent():getAdjacentTiles());
    end

    function self:draw()
        -- love.graphics.setColor(255, 255, 255, 100);
        love.graphics.draw(sprite, self:getX() * TILESIZE, self:getY() * TILESIZE);
        -- love.graphics.setColor(255, 255, 255, 255);
    end

    function self:explode(radius, direction, adjTiles)
        -- Replace with newer explosion.
        self:getParent():addContent(Explosion.new(self:getX(), self:getY()));

        -- Notify neighbour.
        adjTiles[direction]:explode(radius - 1, direction);
    end

    function self:increaseDanger(radius, direction, adjTiles)
        if radius > 0 then
            self:getParent():setDanger(radius);
            adjTiles[direction]:increaseDanger(radius - 1, direction);
        end
    end

    function self:decreaseDanger(radius, direction, adjTiles)
        if radius > 0 then
            self:getParent():setDanger(-radius);
            adjTiles[direction]:decreaseDanger(radius - 1, direction);
        end
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    return self;
end

return Explosion;

--==================================================================================================
-- Created 24.07.14 - 17:27                                                                        =
--==================================================================================================