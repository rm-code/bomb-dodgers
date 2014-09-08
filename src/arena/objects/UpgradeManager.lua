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
function UpgradeManager.register(x, y)
    uniqueID = uniqueID + 1;
    upgrades[uniqueID] = { x = x, y = y };
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
function UpgradeManager.getClosestUpgrade(x, y)
    local distance;
    local targetId;

    for id, target in pairs(upgrades) do
        local td = math.abs(x - target.x) + math.abs(y - target.y);

        if not distance then
            distance = td;
            targetId = id;
        elseif td < distance then
            distance = td;
            targetId = id;
        end
    end

    if upgrades[targetId] then
        return upgrades[targetId].x, upgrades[targetId].y;
    end
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return UpgradeManager;

--==================================================================================================
-- Created 13.08.14 - 00:55                                                                        =
--==================================================================================================