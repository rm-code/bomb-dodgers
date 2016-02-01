--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 - 2016 Robert Machmer                                      --
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
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Door = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Door);

---
-- Load images.
--
function Door.loadImages()
    images['tiles'] = ResourceManager.loadImage('res/img/levels/door.png')
    images['closed'] = love.graphics.newQuad(0, 0, 32, 32, images['tiles']:getDimensions());
    images['open'] = love.graphics.newQuad(32, 0, 32, 32, images['tiles']:getDimensions());
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Door.new(x, y, open)
    local self = Content.new(Constants.CONTENT.DOOR, open, x, y);

    local sprite = open and images['open'] or images['closed'];

    function self:draw()
        love.graphics.draw(images['tiles'], sprite, self:getX() * Constants.TILESIZE, self:getY() * Constants.TILESIZE);
    end

    return self;
end

return Door;

--==================================================================================================
-- Created 06.10.14 - 03:57                                                                        =
--==================================================================================================
