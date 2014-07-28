local Config = require('src/Config');

local CarryBooster = {};

function CarryBooster.new()
    local self = {};

    local tile;
    local type = 'carryboost';
    local timer = 15;

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            tile:removeContent();
        end
    end

    function self:draw(x, y)
        love.graphics.setColor(0, 0, 205);
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

return CarryBooster;

--==================================================================================================
-- Created 28.07.14 - 15:20                                                                        =
--==================================================================================================