local Content = require('src/objects/Content');
local Constants = require('src/Constants');
local UpgradeManager = require('src/upgrades/UpgradeManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Upgrade = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;
local TYPES = { 'fireup', 'bombup', 'bombdown' };

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local imgFireUp = love.graphics.newImage('res/img/upgrades/fireup.png');
local imgBombUp = love.graphics.newImage('res/img/upgrades/bombup.png');
local imgBombDown = love.graphics.newImage('res/img/upgrades/bombdown.png');

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
        local rnd = love.math.random(1, #TYPES + 1);
        return TYPES[rnd];
    end

    -- ------------------------------------------------
    -- Public functions
    -- ------------------------------------------------

    function self:init()
        -- Select a random type of upgrade.
        upgradeType = assignUpgradeType();

        -- Only register upgrades in the upgrade manager. We don't want
        -- the AI to actively hunt for downgrades.
        if upgradeType == TYPES[1] or upgradeType == TYPES[2] then
            -- Save the id used in the upgrade manager.
            id = UpgradeManager.register(self:getX(), self:getY());
        end
    end

    function self:update(_)
        return;
    end

    function self:draw()
        if upgradeType == TYPES[1] then
            love.graphics.draw(imgFireUp, self:getX() * TILESIZE, self:getY() * TILESIZE);
        elseif upgradeType == TYPES[2] then
            love.graphics.draw(imgBombUp, self:getX() * TILESIZE, self:getY() * TILESIZE);
        elseif upgradeType == TYPES[3] then
            love.graphics.draw(imgBombDown, self:getX() * TILESIZE, self:getY() * TILESIZE);
        end
    end

    function self:explode()
        self:getParent():clearContent();
    end

    function self:remove()
        if id then
            UpgradeManager.remove(id);
        end
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