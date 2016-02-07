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

local Tentacles = require( 'src.entities.boss.mummy.ClothTentacle' );

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local SpawnTentacles = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function SpawnTentacles.new(fsm, boss, arena)
    local self = {};

    local timer = 2;

    ---
    -- Spawns an upgrade somewhere on the grid.
    -- @param amount
    --
    local function spawnTentacles(amount, arena)
        local rndX, rndY;
        local tentacle;
        local count = 0;
        while count < amount do
            rndX, rndY = love.math.random(1, arena:getWidth()), love.math.random(1, arena:getHeight());

            -- Only spawn upgrades on free tiles.
            if not arena:getTile(rndX, rndY):getContent() then
                tentacle = Tentacles.new(rndX, rndY);
                arena:getTile(rndX, rndY):addContent(tentacle);
                count = count + 1;
            end
        end
    end

    function self:enter() end

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            spawnTentacles(5, arena);
            timer = 2;
            fsm:switch('move');
        end
    end

    function self:exit() end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return SpawnTentacles;

--==================================================================================================
-- Created 10.10.14 - 23:43                                                                        =
--==================================================================================================
