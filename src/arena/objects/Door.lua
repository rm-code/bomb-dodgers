--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

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