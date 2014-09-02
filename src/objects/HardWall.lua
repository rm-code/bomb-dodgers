local Content = require('src/objects/Content');
local Constants = require('src/Constants');

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
-- Local Variables
-- ------------------------------------------------

local img = love.graphics.newImage('res/img/hardwall.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function HardWall.new(x, y)
    local self = Content.new(CONTENT.HARDWALL, false, x, y);

    function self:explode(_, _, _)
        return;
    end

    function self:draw()
        love.graphics.draw(img, self:getX() * TILESIZE, self:getY() * TILESIZE);
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