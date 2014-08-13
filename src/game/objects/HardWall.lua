local Constants = require('src/Constants');

local img = love.graphics.newImage('res/img/hardwall.png');

local HardWall = {};

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

function HardWall.new()
    local self = {};

    local tile;
    local type = CONTENT.HARDWALL;

    function self:update(dt)
    end

    function self:draw(x, y)
        love.graphics.draw(img, x * TILESIZE, y * TILESIZE);
        love.graphics.setColor(255, 255, 255);
    end

    function self:signal(signal)
    end

    function self:setTile(ntile)
        tile = ntile;
    end

    function self:getType()
        return type;
    end

    return self;
end

return HardWall;

--==================================================================================================
-- Created 24.07.14 - 23:12                                                                        =
--==================================================================================================