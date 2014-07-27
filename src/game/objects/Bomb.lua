local Config = require('src/Config');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Bomb = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Bomb.new()
    local self = {};

    local x, y;
    local dx, dy;
    local timer;
    local strength;
    local tile;
    local type = 'bomb';

    function self:init(nx, ny, ntimer, nstrength)
        x, y = nx, ny;
        timer = ntimer;
        strength = nstrength;
    end

    function self:move(ndx, ndy)
        dx, dy = ndx, ndy;
        x = x + dx;
        y = y + dy;
    end

    local updates = 0;
    function self:update(dt)
        updates = updates + 1;
        if updates % 2 == 0 then
            if dx and dy then
                tile:signal('kickbomb', dx, dy);
            end
        end

        timer = timer - dt;
        if timer <= 0 then
            tile:removeContent();
            tile:signal({ name = 'detonate', strength = strength, direction = 'all' });
        end
    end

    function self:signal(signal)
        if signal.name == 'detonate' then
            tile:removeContent();
            tile:signal({ name = 'detonate', strength = strength, direction = 'all' });
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

    function self:getType()
        return type;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Bomb;

--==================================================================================================
-- Created 15.07.14 - 00:37                                                                        =
--==================================================================================================