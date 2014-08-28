local Content = require('src/game/objects/Content');
local Constants = require('src/Constants');
local UpgradeManager = require('src/game/upgrades/UpgradeManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Upgrade = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;
local TYPES = { 'fireup', 'bombup' };

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local imgFireUp = love.graphics.newImage('res/img/upgrades/fireup.png');
local imgBombUp = love.graphics.newImage('res/img/upgrades/bombup.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Upgrade.new(x, y)
    local self = Content.new(CONTENT.UPGRADE, true, x, y);

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local upgradeType;
    local id;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function assignUpgradeType()
        local rnd = love.math.random(1, #TYPES);
        return TYPES[rnd];
    end

    -- ------------------------------------------------
    -- Public functions
    -- ------------------------------------------------

    function self:init()
        -- Save the id used in the upgrade manager.
        id = UpgradeManager.register(self:getX(), self:getY());

        -- Select a random type of upgrade.
        upgradeType = assignUpgradeType();
    end

    function self:update(_)
        return;
    end

    function self:draw()
        if upgradeType == TYPES[1] then
            love.graphics.draw(imgFireUp, self:getX() * TILESIZE, self:getY() * TILESIZE);
        elseif upgradeType == TYPES[2] then
            love.graphics.draw(imgBombUp, self:getX() * TILESIZE, self:getY() * TILESIZE);
        end
    end

    function self:explode()
        self:getParent():clearContent();
    end

    function self:remove()
        UpgradeManager.remove(id);
        self:getParent():clearContent();
    end

    function self:increaseDanger(_, _, _)
        return;
    end

    function self:decreaseDanger(_, _, _)
        return;
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getUpgradeType()
        return upgradeType;
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