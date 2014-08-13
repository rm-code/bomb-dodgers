local Constants = require('src/Constants');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Bomb = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;
local BOMBTIMER = Constants.BOMBTIMER;

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local img = love.graphics.newImage('res/img/bomb.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Bomb.new()
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local type = CONTENT.BOMB;
    local tile;
    local strength;
    local player;
    local timer = BOMBTIMER;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            tile:removeContent();
            player:removeBomb();
            tile:signal({ name = 'detonate', strength = strength, direction = 'all' });
        end
    end

    function self:draw(x, y)
        love.graphics.draw(img, x * TILESIZE, y * TILESIZE);
    end

    function self:signal(signal)
        if signal.name == 'detonate' then
            tile:removeContent();
            player:removeBomb();
            tile:signal({ name = 'detonate', strength = strength, direction = 'all' });
        end
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getType()
        return type;
    end

    function self:getStrength()
        return strength;
    end

    function self:isPassable()
        return false;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setTile(ntile)
        tile = ntile;
        tile:signal({ name = 'plantbomb', strength = strength, direction = 'all' });
    end

    function self:setStrength(nstrength)
        strength = nstrength;
    end

    function self:setPlayer(nplayer)
        player = nplayer;
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