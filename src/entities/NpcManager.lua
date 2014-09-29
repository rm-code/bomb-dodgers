--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local NpcManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local npcs = {};

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

function NpcManager.register(npc)
    npcs[#npcs + 1] = npc;
end

function NpcManager.update(dt)
    for i = 1, #npcs do
        npcs[i]:update(dt);
    end
end

function NpcManager.draw()
    for i = 1, #npcs do
        npcs[i]:draw();
    end
end

function NpcManager.getClosest(x, y)
    local distance;
    local targetId;

    for i = 1, #npcs do
        local td = math.abs(x - npcs[i]:getX()) + math.abs(y - npcs[i]:getY());

        if not distance or td < distance then
            distance = td;
            targetId = i;
        end
    end

    if npcs[targetId] then
        return npcs[targetId];
    end
end

function NpcManager.getCount()
    local cnt = 0;
    for i = 1, #npcs do
        if not npcs[i]:isDead() then
            cnt = cnt + 1;
        end
    end
    return cnt;
end

function NpcManager.clear()
    for i = 1, #npcs do
        npcs[i] = nil;
    end
end

function NpcManager.getNpcs()
    return npcs;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return NpcManager;

--==================================================================================================
-- Created 09.09.14 - 09:47                                                                        =
--==================================================================================================