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

local Charge = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Charge.new(fsm, boss)
    local self = {};

    local adjTiles;
    local direction;
    local timer = 2;

    local function getDirection()
        if boss:getX() < 10 then
            return 'e';
        else
            return 'w';
        end
    end

    function self:enter()
        direction = getDirection();
        adjTiles = boss:getAdjacentTiles();
        boss:setSpeed(200);
    end

    function self:update(dt)
        if not adjTiles[direction]:isPassable() then
            fsm:switch('move');
            return;
        end

        timer = timer - dt;
        if timer <= 0 then
            if not boss:move(dt, direction) then
                fsm:switch('move');
                return;
            end
        end
    end

    function self:exit()
        boss:setSpeed(85);
        timer = 2;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Charge;

--==================================================================================================
-- Created 12.10.14 - 18:59                                                                        =
--==================================================================================================