local Content = require('src/objects/Content');
local Constants = require('src/Constants');
local Upgrade = require('src/objects/Upgrade');
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local SoftWall = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(SoftWall);

---
-- Load images.
--
function SoftWall.loadImages()
    images['soft_wall'] = ResourceManager.loadImage('res/img/content/softwall.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function SoftWall.new(x, y)
    local self = Content.new(CONTENT.SOFTWALL, false, x, y);

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    ---
    -- Randomly decides wether or not to drop an upgrade.
    -- It registers the dropped upgrade with at the UpgradeManager
    -- sets its type and then adds it to the current tile.
    --
    local function dropUpgrade(x, y)
        if love.math.random(0, Constants.UPGRADES.DROPCHANCE) == 0 then
            local upgrade = Upgrade.new(x, y);
            upgrade:init();
            self:getParent():addContent(upgrade);
        end
    end

    function self:explode(_, _, _)
        -- Remove the softwall from the tile.
        -- TODO replace with burning animation.
        self:getParent():clearContent();

        -- Randomly drop upgrades.
        dropUpgrade(self:getX(), self:getY());
    end

    function self:increaseDanger(_, _, _)
        return;
    end

    function self:decreaseDanger(_, _, _)
        return;
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:draw()
        love.graphics.draw(images['soft_wall'], self:getX() * TILESIZE, self:getY() * TILESIZE);
    end

    return self;
end

return SoftWall;

--==================================================================================================
-- Created 24.07.14 - 22:45                                                                        =
--==================================================================================================