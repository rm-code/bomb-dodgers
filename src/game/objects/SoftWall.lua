local Config = require('src/Config');

local SoftWall = {};

function SoftWall.new()
    local self = {};

    local x, y;
    local tile;
    local type = 'softwall';

    function self:init(nx, ny)
        x, y = nx, ny;
    end

    function self:update(dt)
    end

    function self:draw()
        love.graphics.setColor(120, 120, 120);
        love.graphics.rectangle('fill', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
        love.graphics.setColor(255, 255, 255);
    end

    function self:signal(signal)
        if signal == 'explode' then
            tile:removeContent();
        end
    end

    function self:setTile(ntile)
        tile = ntile;
    end

    function self:getType()
        return type;
    end

    return self;
end

return SoftWall;

--==================================================================================================
-- Created 24.07.14 - 22:45                                                                        =
--==================================================================================================