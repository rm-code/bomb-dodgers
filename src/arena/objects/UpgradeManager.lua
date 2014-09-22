--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

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
        return upgrades[targetId]:getX(), upgrades[targetId]:getY();
    end
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return UpgradeManager;

--==================================================================================================
-- Created 13.08.14 - 00:55                                                                        =
--==================================================================================================