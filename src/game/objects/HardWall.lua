local Config = require('src/Config');

local img = love.graphics.newImage('res/img/hardwall.png');

local HardWall = {};

function HardWall.new()
    local self = {};

    local tile;
    local type = 'hardwall';

    function self:update(dt)
    end

    function self:draw(x, y)
        love.graphics.draw(img, x * Config.tileSize, y * Config.tileSize);
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