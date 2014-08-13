local Constants = require('src/Constants');

local img = love.graphics.newImage('res/img/softwall.png');

local SoftWall = {};

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

function SoftWall.new()
    local self = {};

    local tile;
    local type = CONTENT.SOFTWALL;

    function self:update(dt)
    end

    function self:draw(x, y)
--        love.graphics.setColor(120, 120, 120);
--        love.graphics.rectangle('fill', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
        love.graphics.draw(img, x * TILESIZE, y * TILESIZE);
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