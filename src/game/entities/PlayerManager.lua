-- ------------------------------------------------
-- Module
-- ------------------------------------------------

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

function PlayerManager.getClosestPlayer(x, y)
    local distance;
    local targetId;

    for id, target in pairs(players) do
        local td = math.abs(x - target:getX()) + math.abs(y - target:getY());

        if not distance then
            distance = td;
            targetId = id;
        elseif td < distance then
            distance = td;
            targetId = id;
        end
    end

    return players[targetId]:getX(), players[targetId]:getY();
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return PlayerManager;

--==================================================================================================
-- Created 13.08.14 - 00:55                                                                        =
--==================================================================================================