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

function Explosion.new(direction, strength)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local type = CONTENT.EXPLOSION;
    local tile;
    local timer = 1;
    local sprite;
    local direction = direction;
    local strength = strength;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    local function pickSprite(direction, strength, adjTiles)
        local n, s, e, w = adjTiles.north, adjTiles.south, adjTiles.east, adjTiles.west;

        -- Sprite for explosion's center.
        if direction == 'all' then
            return origin;
        end

        -- End sprites.
        if direction == 'north' and strength == 0 and n:getContentType() ~= CONTENT.EXPLOSION then
            return endnorth;
        elseif direction == 'south' and strength == 0 and s:getContentType() ~= CONTENT.EXPLOSION then
            return endsouth;
        elseif direction == 'east' and strength == 0 and e:getContentType() ~= CONTENT.EXPLOSION then
            return endeast;
        elseif direction == 'west' and strength == 0 and w:getContentType() ~= CONTENT.EXPLOSION then
            return endwest;
        end

        -- Middle sprites. Create intersections if multiple middle tiles collide.
        if (direction == 'north' or direction == 'south')
                and (e:getContentType() == CONTENT.EXPLOSION or w:getContentType() == CONTENT.EXPLOSION) then
            return origin;
        elseif (direction == 'east' or direction == 'west')
                and (n:getContentType() == CONTENT.EXPLOSION or s:getContentType() == CONTENT.EXPLOSION) then
            return origin;
        elseif direction == 'north' or direction == 'south' then
            return vertical;
        elseif direction == 'east' or direction == 'west' then
            return horizontal;
        end
    end

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            tile:removeContent();
        end

        sprite = pickSprite(direction, strength, tile:getNeighbours());
    end

    function self:draw(x, y)
        if sprite then
            love.graphics.draw(sprite, x * TILESIZE, y * TILESIZE);
        end
    end

    function self:signal(signal)
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getDirection()
        return direction;
    end

    function self:getType()
        return type;
    end

    function self:isPassable()
        return true;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setTile(ntile)
        tile = ntile;
    end

    return self;
end

return Explosion;

--==================================================================================================
-- Created 24.07.14 - 17:27                                                                        =
--==================================================================================================