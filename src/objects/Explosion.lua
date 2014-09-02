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

function Explosion.new(strength, x, y)
    local self = Content.new(CONTENT.EXPLOSION, true, x, y);

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local timer = Constants.EXPLOSIONTIMER;
    local sprite;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function pickSprite(adjTiles)
        local n = adjTiles.n:getContentType() == CONTENT.EXPLOSION;
        local s = adjTiles.s:getContentType() == CONTENT.EXPLOSION;
        local e = adjTiles.e:getContentType() == CONTENT.EXPLOSION;
        local w = adjTiles.w:getContentType() == CONTENT.EXPLOSION;

        if (n or s) and (e or w) then
            return origin;
        elseif e or w then
            if strength == 1 and e and not w then
                return endwest;
            elseif strength == 1 and w and not e then
                return endeast;
            else
                return horizontal;
            end
        elseif n or s then
            if strength == 1 and n and not s then
                return endsouth;
            elseif strength == 1 and s and not n then
                return endnorth;
            else
                return vertical;
            end
        else
            return missing;
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
        if sprite then
            love.graphics.draw(sprite, self:getX() * TILESIZE, self:getY() * TILESIZE);
        end
        -- love.graphics.setColor(255, 255, 255, 255);
    end

    function self:explode(radius, direction, adjTiles)
        -- Replace with newer explosion.
        self:getParent():addContent(Explosion.new(radius, self:getX(), self:getY()));

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