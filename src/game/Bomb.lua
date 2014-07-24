local Config = require('src/Config');


local Bomb = {};

function Bomb.new()
    local self = {};

    local x, y;
    local timer;
    local strength;
    local tile;

    function self:init(nx, ny, ntimer, nstrength)
        x, y = nx, ny;
        timer = ntimer;
        strength = nstrength;
    end

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            tile:signal('detonate', strength);
        end
    end

    function self:signal(signal)
        if signal == 'explode' then
            tile:signal('detonate', strength);
        end
    end

    function self:setTile(ntile)
        tile = ntile;
    end

    function self:draw()
        love.graphics.setColor(255, 0, 0);
        love.graphics.circle('fill', x * Config.tileSize + Config.tileSize * 0.5, y * Config.tileSize + Config.tileSize * 0.5, Config.tileSize * 0.5, 20);
        love.graphics.setColor(255, 255, 255);
    end

    return self;
end

return Bomb;

--==================================================================================================
-- Created 15.07.14 - 00:37                                                                        =
--==================================================================================================