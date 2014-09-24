--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local PlayerManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local players = {};
local uniqueID = 0;

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

function PlayerManager.register(player)
    uniqueID = uniqueID + 1;
    players[uniqueID] = player;
    return uniqueID;
end

function PlayerManager.remove(id)
    players[id] = nil;
end

function PlayerManager.getClosest(x, y)
    local distance;
    local targetId;

    for id, target in pairs(players) do
        local td = math.abs(x - target:getX()) + math.abs(y - target:getY());

        if not distance or td < distance then
            distance = td;
            targetId = id;
        end
    end

    if players[targetId] then
        return players[targetId];
    end
end

function PlayerManager.clear()
    for i, _ in pairs(players) do
        players[i] = nil;
    end
end

function PlayerManager.getCount()
    local i = 0;
    for _, _ in pairs(players) do
        i = i + 1;
    end
    return i;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return PlayerManager;

--==================================================================================================
-- Created 13.08.14 - 00:55                                                                        =
--==================================================================================================