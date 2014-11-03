--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 Robert Machmer                                             --
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

local UpgradeManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local upgrades = {};
local uniqueID = 0;

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

---
-- Registers an upgrade with the upgrade manager and
-- returns the id under which the upgrade has been
-- stored.
-- @param x
-- @param y
--
function UpgradeManager.register(upgrade)
    uniqueID = uniqueID + 1;
    upgrades[uniqueID] = upgrade;
    return uniqueID;
end

---
-- Removes an upgrade from the manager.
-- @param id
--
function UpgradeManager.remove(id)
    upgrades[id] = nil;
end

---
-- Returns the position of the closest upgrade.
-- @param x
-- @param y
--
function UpgradeManager.getClosest(x, y)
    local distance;
    local targetId;

    for id, target in pairs(upgrades) do
        local td = math.abs(x - target:getX()) + math.abs(y - target:getY());

        if not distance or td < distance then
            distance = td;
            targetId = id;
        end
    end

    if upgrades[targetId] then
        return upgrades[targetId];
    end
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return UpgradeManager;

--==================================================================================================
-- Created 13.08.14 - 00:55                                                                        =
--==================================================================================================