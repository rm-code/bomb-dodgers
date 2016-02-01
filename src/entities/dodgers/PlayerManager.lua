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

local PlayerManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local players = {};

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

function PlayerManager.register(player)
    players[#players + 1] = player;
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

function PlayerManager.update(dt)
    for _, player in pairs(players) do
        player:update(dt);
    end
end

function PlayerManager.draw()
    for _, player in pairs(players) do
        player:draw();
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

function PlayerManager.getPlayers()
    return players;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return PlayerManager;

--==================================================================================================
-- Created 13.08.14 - 00:55                                                                        =
--==================================================================================================
