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

local Math = require('lib/Math');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Move = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Move.new(fsm, boss)
    local self = {};

    local dirX, dirY = Math.rndsign() * love.math.random(0, 2), Math.rndsign() * love.math.random(0, 2);
    local curX, curY;
    local tileCounter = 0;
    local missileTimer = 3;

    function self:enter()
        curX, curY = boss:getPosition();
    end

    function self:update(dt)
        dirX, dirY = boss:move(dt, dirX, dirY);

        missileTimer = missileTimer - dt;
        if missileTimer <= 0 and boss:getMissileCount() == 0 then
            print('bang');
            boss:shoot();
            missileTimer = 3;
        end

        if curX ~= boss:getX() then
            tileCounter = tileCounter + 1;
            curX = boss:getX();
        end
        if curY ~= boss:getY() then
            tileCounter = tileCounter + 1;
            curY = boss:getY();
        end
    end

    function self:exit()
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Move;

--==================================================================================================
-- Created 22.09.14 - 05:12                                                                        =
--==================================================================================================
