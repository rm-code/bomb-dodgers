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

    local timer;
    local strength;
    local player;
    local tile;
    local type = 'bomb';

    function self:init(ntimer, nstrength)
        timer = ntimer;
        strength = nstrength;
    end

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            tile:removeContent();
            player:removeBomb();
            tile:signal({ name = 'detonate', strength = strength, direction = 'all' });
        end
    end

    function self:signal(signal)
        if signal.name == 'detonate' then
            tile:removeContent();
            player:removeBomb();
            tile:signal({ name = 'detonate', strength = strength, direction = 'all' });
        end
    end

    function self:setTile(ntile)
        tile = ntile;
    end

    function self:draw(x, y)
        love.graphics.setColor(255, 0, 0);
        love.graphics.circle('fill', x * Config.tileSize + Config.tileSize * 0.5, y * Config.tileSize + Config.tileSize * 0.5, Config.tileSize * 0.5, 20);
        love.graphics.setColor(255, 255, 255);
    end

    function self:getType()
        return type;
    end

    function self:setPlayer(nplayer)
        player = nplayer;
    end

    function self:getStrength()
        return strength;
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