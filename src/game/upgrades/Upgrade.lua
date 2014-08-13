local Constants = require('src/Constants');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Upgrade = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;
local TIMER = Constants.UPGRADES.TIMER;

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local imgFireUp = love.graphics.newImage('res/img/upgrades/fireup.png');
local imgBombUp = love.graphics.newImage('res/img/upgrades/bombup.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Upgrade.new()
    local self = {};

    local type;
    local tile;
    local id;
    local decayTimer = TIMER;

    -- ------------------------------------------------
    -- Public functions
    -- ------------------------------------------------

    function self:update(dt)
        decayTimer = decayTimer - dt;
        if decayTimer <= 0 then
            tile:removeContent();
        end
    end

    function self:draw(x, y)
        if type == CONTENT.FIREUP then
            love.graphics.draw(imgFireUp, x * TILESIZE, y * TILESIZE);
        elseif type == CONTENT.BOMBUP then
            love.graphics.draw(imgBombUp, x * TILESIZE, y * TILESIZE);
        end
    end

    function self:signal(signal)
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getType()
        return type;
    end

    function self:getId()
        return id;
    end

    function self:isPassable()
        return true;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setType(ntype)
        type = ntype;
    end

    function self:setTile(ntile)
        tile = ntile;
    end

    function self:setId(nid)
        id = nid;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Upgrade;

--==================================================================================================
-- Created 13.08.14 - 02:08                                                                        =
--==================================================================================================