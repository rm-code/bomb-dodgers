local Config = require('src/Config');

local img = love.graphics.newImage('res/img/carryboost.png');

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
        love.graphics.draw(img, x * Config.tileSize, y * Config.tileSize);
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