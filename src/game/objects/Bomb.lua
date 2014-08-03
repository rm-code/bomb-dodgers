local Config = require('src/Config');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local img = love.graphics.newImage('res/img/bomb.png');

local Bomb = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Bomb.new()
    local self = {};

    local timer = Config.bombTimer;
    local strength;
    local player;
    local tile;
    local type = 'bomb';

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
        tile:signal({ name = 'plantbomb', strength = strength, direction = 'all' });
    end

    function self:setStrength(nstrength)
        print(nstrength)
        strength = nstrength;
    end

    function self:draw(x, y)
        love.graphics.draw(img, x * Config.tileSize, y * Config.tileSize);
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