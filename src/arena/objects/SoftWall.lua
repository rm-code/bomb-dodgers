--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 - 2016 Robert Machmer                                      --
--                                                                               --
-- This software is provided 'as-is', without any express or implied             --
-- warranty. In no event will the authors be held liable for any damages         --
-- arising from the use of this software.                                        --
--                                                                               --
-- Permission is granted to anyone to use this software for any purpose,         --
-- including commercial applications, and to alter it and redistribute it        --
-- freely, subject to the following restrictions:                                --
--                                                                               --
--  1. The origin of this software must not be misrepresented; you must not      --
--      claim that you wrote the original software. If you use this software     --
--      in a product, an acknowledgment in the product documentation would be    --
--      appreciated but is not required.                                         --
--  2. Altered source versions must be plainly marked as such, and must not be   --
--      misrepresented as being the original software.                           --
--  3. This notice may not be removed or altered from any source distribution.   --
--                                                                               --
--===============================================================================--

local Content = require( 'src.arena.objects.Content' );
local Constants = require( 'src.Constants' );
local Upgrade = require( 'src.arena.objects.Upgrade' );
local Destruction = require( 'src.arena.objects.Destruction' );

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local SoftWall = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;

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
        else
            self:getParent():addContent(Destruction.new(self:getParent():getTileSheet(), x, y));
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:explode(_, _, _)
        self:getParent():clearContent();

        -- Randomly drop upgrades.
        dropUpgrade(self:getX(), self:getY());
    end

    -- ------------------------------------------------
    -- Return Object
    -- ------------------------------------------------

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return SoftWall;

--==================================================================================================
-- Created 24.07.14 - 22:45                                                                        =
--==================================================================================================
