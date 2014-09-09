--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local NpcManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local npcs = {};
local uniqueID = 0;

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

function NpcManager.register(npc)
    uniqueID = uniqueID + 1;
    npcs[uniqueID] = npc;
    return uniqueID;
end

function NpcManager.remove(id)
    npcs[id] = nil;
end

function NpcManager.update(dt)
    for i = 1, #npcs do
        if not npcs[i]:isDead() then
            npcs[i]:update(dt);
        end
    end
end

function NpcManager.draw()
    for i = 1, #npcs do
        if not npcs[i]:isDead() then
            npcs[i]:draw();
        end
    end
end

function NpcManager.getClosestNpc(x, y)
    local distance;
    local targetId;

    for id, target in pairs(npcs) do
        local td = math.abs(x - target:getX()) + math.abs(y - target:getY());

        if not distance then
            distance = td;
            targetId = id;
        elseif td < distance then
            distance = td;
            targetId = id;
        end
    end

    return npcs[targetId]:getX(), npcs[targetId]:getY();
end

function NpcManager.getNpcCount()
    local i = 0;
    for _, _ in pairs(npcs) do
        i = i + 1;
    end
    return i;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return NpcManager;

--==================================================================================================
-- Created 09.09.14 - 09:47                                                                        =
--==================================================================================================