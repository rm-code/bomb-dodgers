--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Content = require('src/arena/objects/Content');
local Constants = require('src/Constants');
local UpgradeManager = require('src/arena/objects/UpgradeManager');
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Upgrade = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;
local TYPES = { 'fireup', 'bombup', 'bombdown', 'snail' };

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Upgrade);

---
-- Load images.
--
function Upgrade.loadImages()
    images['fireup'] = love.graphics.newImage('res/img/upgrades/fireup.png');
    images['bombup'] = love.graphics.newImage('res/img/upgrades/bombup.png');
    images['bombdown'] = love.graphics.newImage('res/img/upgrades/bombdown.png');
    images['snail'] = love.graphics.newImage('res/img/upgrades/snail.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Upgrade.new(x, y)
    local self = Content.new(CONTENT.UPGRADE, true, x, y);

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local upgradeType;
    local sprite;
    local id;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function assignUpgradeType()
        local rnd = love.math.random(1, 4);
        if rnd == 1 then
            return TYPES[love.math.random(3, 4)];
        else
            return TYPES[love.math.random(1, 2)];
        end
    end

    local function assignSprite(type)
        return images[type];
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
            id = UpgradeManager.register(self);
        end

        -- Assign a sprite.
        sprite = assignSprite(upgradeType);
    end

    function self:draw()
        love.graphics.draw(sprite, self:getX() * TILESIZE, self:getY() * TILESIZE);
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

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getUpgradeType()
        return upgradeType;
    end

    -- ------------------------------------------------
    -- Return Object
    -- ------------------------------------------------

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Upgrade;

--==================================================================================================
-- Created 13.08.14 - 02:08                                                                        =
--==================================================================================================