local Content = require('src/objects/Content');
local Constants = require('src/Constants');
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local HardWall = {};

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
ResourceManager.register(HardWall);

---
-- Load images.
--
function HardWall.loadImages()
    images['hard_wall'] = ResourceManager.loadImage('res/img/content/hardwall.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function HardWall.new(x, y)
    local self = Content.new(CONTENT.HARDWALL, false, x, y);

    function self:explode(_, _, _)
        return;
    end

    function self:draw()
        love.graphics.draw(images['hard_wall'], self:getX() * TILESIZE, self:getY() * TILESIZE);
    end

    function self:increaseDanger(_, _, _)
        return;
    end

    function self:decreaseDanger(_, _, _)
        return;
    end

    return self;
end

return HardWall;

--==================================================================================================
-- Created 24.07.14 - 23:12                                                                        =
--==================================================================================================