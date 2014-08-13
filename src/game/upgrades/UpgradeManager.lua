-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local UpgradeManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local upgrades = {};
local uniqueID = 0;

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

function UpgradeManager.register(x, y)
    uniqueID = uniqueID + 1;
    upgrades[uniqueID] = { x = x, y = y };
    return uniqueID;
end

function UpgradeManager.remove(id)
    upgrades[id] = nil;
end

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

    return upgrades[targetId];
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return UpgradeManager;

--==================================================================================================
-- Created 13.08.14 - 00:55                                                                        =
--==================================================================================================