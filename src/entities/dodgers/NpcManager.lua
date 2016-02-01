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
