--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Content = require('src/arena/objects/Content');
local Constants = require('src/Constants');
local ResourceManager = require('lib/ResourceManager');

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
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Explosion);

---
-- Load images.
--
function Explosion.loadImages()
    images['origin'] = ResourceManager.loadImage('res/img/explosion/origin.png');
    images['horizontal'] = ResourceManager.loadImage('res/img/explosion/middle_hor.png');
    images['vertical'] = ResourceManager.loadImage('res/img/explosion/middle_vert.png');
    images['endnorth'] = ResourceManager.loadImage('res/img/explosion/end_up.png');
    images['endsouth'] = ResourceManager.loadImage('res/img/explosion/end_down.png');
    images['endeast'] = ResourceManager.loadImage('res/img/explosion/end_right.png');
    images['endwest'] = ResourceManager.loadImage('res/img/explosion/end_left.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Explosion.new(strength, x, y)
    local self = Content.new(CONTENT.EXPLOSION, true, x, y);

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local strength = strength;
    local timer = Constants.EXPLOSIONTIMER;
    local sprite;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    ---
    -- Picks an explosion sprite based on the content type of the
    -- adjacent tiles.
    -- @param adjTiles - The adjacent tiles next to the explosion's parent tile.
    --
    local function pickSprite(adjTiles, strength)
        local n = adjTiles.n:getContentType() == CONTENT.EXPLOSION;
        local s = adjTiles.s:getContentType() == CONTENT.EXPLOSION;
        local e = adjTiles.e:getContentType() == CONTENT.EXPLOSION;
        local w = adjTiles.w:getContentType() == CONTENT.EXPLOSION;

        -- If we have explosions horizontal and vertical directions
        -- then add an origin sprite. If the blast strength is one
        -- and there is no more explosion in that direction, we know
        -- that we have reached an end tile.
        if (n or s) and (e or w) then
            return images['origin'];
        elseif e or w then
            if strength == 1 and e and not w then
                return images['endwest'];
            elseif strength == 1 and w and not e then
                return images['endeast'];
            else
                return images['horizontal'];
            end
        elseif n or s then
            if strength == 1 and n and not s then
                return images['endsouth'];
            elseif strength == 1 and s and not n then
                return images['endnorth'];
            else
                return images['vertical'];
            end
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    ---
    -- Update the timer until the explosion is removed and
    -- constantly check if the current sprite needs to be changed.
    -- This might happen if for example a new explosion intersects
    -- with an old one and creates a new intersection sprite.
    -- @param dt - The game's delta time.
    --
    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            self:getParent():clearContent();
        end

        sprite = pickSprite(self:getParent():getAdjacentTiles(), strength);
    end

    ---
    -- Draw the picked sprite.
    --
    function self:draw()
        if sprite then
            love.graphics.draw(sprite, self:getX() * TILESIZE, self:getY() * TILESIZE);
        end
    end

    ---
    -- Handle an explosion signal.
    -- @param radius
    -- @param direction
    -- @param adjTiles
    --
    function self:explode(radius, direction, adjTiles)
        -- Replace with newer explosion.
        self:getParent():addContent(Explosion.new(radius, self:getX(), self:getY()));

        -- Notify neighbour.
        adjTiles[direction]:explode(radius - 1, direction);
    end

    ---
    -- Increase danger.
    -- @param radius
    -- @param direction
    -- @param adjTiles
    --
    function self:increaseDanger(radius, direction, adjTiles)
        if radius > 0 then
            self:getParent():setDanger(radius);
            adjTiles[direction]:increaseDanger(radius - 1, direction);
        end
    end

    ---
    -- Decrease danger.
    -- @param radius
    -- @param direction
    -- @param adjTiles
    --
    function self:decreaseDanger(radius, direction, adjTiles)
        if radius > 0 then
            self:getParent():setDanger(-radius);
            adjTiles[direction]:decreaseDanger(radius - 1, direction);
        end
    end

    -- ------------------------------------------------
    -- Return Object
    -- ------------------------------------------------

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Explosion;

--==================================================================================================
-- Created 24.07.14 - 17:27                                                                        =
--==================================================================================================