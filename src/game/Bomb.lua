local Bomb = {};

function Bomb.new(x, y, timer, strength)
    local self = {};

    local x, y = x, y;
    local timer = timer;
    local tileSize = 32;
    local strength = strength;

    function self:update(dt)
        timer = timer - dt * 10;
    end

    function self:draw()
        love.graphics.setColor(255, 0, 0);
        love.graphics.circle('fill', x * tileSize + 16, y * tileSize + 16, 16, 6);
        love.graphics.setColor(255, 255, 255);
    end

    function self:getTimer()
        return timer;
    end

    function self:getX()
        return x;
    end

    function self:getY()
        return y;
    end

    function self:getStrength()
        return strength;
    end

    return self;
end

return Bomb;

--==================================================================================================
-- Created 15.07.14 - 00:37                                                                        =
--==================================================================================================