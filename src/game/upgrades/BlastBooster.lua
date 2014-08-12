local Config = require('src/Config');

local img = love.graphics.newImage('res/img/blastboost.png');

local BlastBooster = {};

function BlastBooster.new(id)
    local self = {};

    local tile;
    local type = 'blastboost';
    local timer = 15;
    local id = id;

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

    function self:getId()
        return id;
    end

    return self;
end

return BlastBooster;

--==================================================================================================
-- Created 28.07.14 - 15:01                                                                        =
--==================================================================================================