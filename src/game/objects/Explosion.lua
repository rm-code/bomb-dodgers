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

function Explosion.new(dir)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local type = CONTENT.EXPLOSION;
    local tile;
    local timer = 1;
    local sprite;

    if dir == 'origin' then
        sprite = origin;
    elseif dir == 'east' or dir == 'west' then
        sprite = horizontal;
    elseif dir == 'north' or dir == 'south' then
        sprite = vertical;
    elseif dir == 'endnorth' then
        sprite = endnorth;
    elseif dir == 'endsouth' then
        sprite = endsouth;
    elseif dir == 'endeast' then
        sprite = endeast;
    elseif dir == 'endwest' then
        sprite = endwest;
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            tile:removeContent();
        end
    end

    function self:draw(x, y)
        love.graphics.draw(sprite, x * TILESIZE, y * TILESIZE);
    end

    function self:signal(signal)
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getType()
        return type;
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