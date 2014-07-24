local Config = require('src/Config');

local Explosion = {};

function Explosion.new()
    local self = {};

    local x, y;
    local tile;
    local type = 'explosion';
    local timer = 1;

    function self:init(nx, ny)
        x, y = nx, ny;
    end

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            tile:removeContent();
        end
    end

    function self:draw()
        love.graphics.setColor(255, 0, 0);
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

return Explosion;

--==================================================================================================
-- Created 24.07.14 - 17:27                                                                        =
--==================================================================================================