--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Content = require('src/arena/objects/Content');
local Constants = require('src/Constants');
local AniMAL = require('lib/AniMAL');
local ResourceManager = require('lib/ResourceManager');
local Explosion = require('src/arena/objects/Explosion');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Destruction = {};

-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Destruction);

---
-- Load images.
--
function Destruction.loadImages()
    images['stonegarden'] = ResourceManager.loadImage('res/img/levels/stonegarden/destruction.png');
    images['desert'] = ResourceManager.loadImage('res/img/ui/missing.png');
    images['snow'] = ResourceManager.loadImage('res/img/ui/missing.png');
    images['forest'] = ResourceManager.loadImage('res/img/ui/missing.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Destruction.new(ts, x, y)
    local self = Content.new('dsoftwall', true, x, y);

    local anim = AniMAL.new(images[ts], Constants.TILESIZE, Constants.TILESIZE, 0.1, 2);

    function self:draw()
        anim:draw(self:getX() * Constants.TILESIZE, self:getY() * Constants.TILESIZE);
    end

    function self:update(dt)
        anim:update(dt);
        if anim:isDone() then
            self:getParent():clearContent();
        end
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

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Destruction;

--==================================================================================================
-- Created 14.09.14 - 19:13                                                                        =
--==================================================================================================