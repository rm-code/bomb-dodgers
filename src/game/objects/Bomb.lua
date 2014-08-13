local Constants = require('src/Constants');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local img = love.graphics.newImage('res/img/bomb.png');

local Bomb = {};

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;
local BOMBTIMER = Constants.BOMBTIMER;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Bomb.new()
    local self = {};

    local timer = BOMBTIMER;
    local strength;
    local player;
    local tile;
    local type = CONTENT.BOMB;

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
        strength = nstrength;
    end

    function self:draw(x, y)
        love.graphics.draw(img, x * TILESIZE, y * TILESIZE);
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