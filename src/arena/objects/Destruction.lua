--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 Robert Machmer                                             --
--                                                                               --
-- This software is provided 'as-is', without any express or implied             --
-- warranty. In no event will the authors be held liable for any damages         --
-- arising from the use of this software.                                        --
--                                                                               --
-- Permission is granted to anyone to use this software for any purpose,         --
-- including commercial applications, and to alter it and redistribute it        --
-- freely, subject to the following restrictions:                                --
--                                                                               --
--  1. The origin of this software must not be misrepresented; you must not      --
--      claim that you wrote the original software. If you use this software     --
--      in a product, an acknowledgment in the product documentation would be    --
--      appreciated but is not required.                                         --
--  2. Altered source versions must be plainly marked as such, and must not be   --
--      misrepresented as being the original software.                           --
--  3. This notice may not be removed or altered from any source distribution.   --
--                                                                               --
--===============================================================================--

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
    images['stone'] = ResourceManager.loadImage('res/img/levels/stone_des.png');
    images['desert'] = ResourceManager.loadImage('res/img/levels/desert_des.png');
    images['snow'] = ResourceManager.loadImage('res/img/levels/snow_des.png');
    images['forest'] = ResourceManager.loadImage('res/img/levels/forest_des.png');
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