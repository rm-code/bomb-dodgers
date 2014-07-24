local Config = require('src/Config');

local HardWall = {};

function HardWall.new()
    local self = {};

    local x, y;
    local tile;
    local type = 'hardwall';

    function self:init(nx, ny)
        x, y = nx, ny;
    end

    function self:update(dt)
    end

    function self:draw()
        love.graphics.setColor(200, 200, 200);
        love.graphics.rectangle('fill', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
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