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

function PlayerManager.getClosest(x, y)
    local distance;
    local targetId;

    for i = 1, #players do
        local td = math.abs(x - players[i]:getX()) + math.abs(y - players[i]:getY());

        if not distance or td < distance then
            distance = td;
            targetId = i;
        end
    end

    if players[targetId] then
        return players[targetId];
    end
end

function PlayerManager.clear()
    for i = 1, #players do
        players[i] = nil;
    end
end

function PlayerManager.getCount()
    local cnt = 0;
    for i = 1, #players do
        if not players[i]:isDead() then
            cnt = cnt + 1;
        end
    end
    return cnt;
end

function PlayerManager.attachCamera(cam, id)
    players[id]:setCamera(cam);
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return PlayerManager;

--==================================================================================================
-- Created 13.08.14 - 00:55                                                                        =
--==================================================================================================