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

function HardWall.new()
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local type = CONTENT.HARDWALL;
    local tile;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(_)
    end

    function self:draw(x, y)
        love.graphics.draw(img, x * TILESIZE, y * TILESIZE);
    end

    function self:signal(_)
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getType()
        return type;
    end

    function self:isPassable()
        return false;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setTile(ntile)
        tile = ntile;
    end

    return self;
end

return HardWall;

--==================================================================================================
-- Created 24.07.14 - 23:12                                                                        =
--==================================================================================================