local Constants = require('src/Constants');

local img = love.graphics.newImage('res/img/carryboost.png');

local CarryBooster = {};

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

function CarryBooster.new(id)
    local self = {};

    local tile;
    local type = CONTENT.BOMBUP;
    local timer = 15;
    local id = id;

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            tile:removeContent();
        end
    end

    function self:draw(x, y)
        love.graphics.draw(img, x * TILESIZE, y * TILESIZE);
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

return CarryBooster;

--==================================================================================================
-- Created 28.07.14 - 15:20                                                                        =
--==================================================================================================