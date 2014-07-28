local Config = require('src/Config');

local BlastBooster = {};

function BlastBooster.new()
    local self = {};

    local tile;
    local type = 'blastboost';
    local timer = 15;

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            tile:removeContent();
        end
    end

    function self:draw(x, y)
        love.graphics.setColor(255, 20, 147);
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

return BlastBooster;

--==================================================================================================
-- Created 28.07.14 - 15:01                                                                        =
--==================================================================================================