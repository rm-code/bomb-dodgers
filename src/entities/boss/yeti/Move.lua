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

local Move = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Move.new(fsm, boss)
    local self = {};

    local direction = 'e';
    local curX, curY;
    local tileCounter = 0;
    local validDirs = {};

    local function newDirection(adjTiles)
        for dir, tile in pairs(adjTiles) do
            if tile:isPassable() then
                validDirs[#validDirs + 1] = dir;
            end
        end
        return validDirs[love.math.random(1, #validDirs)];
    end

    function self:enter()
        direction = newDirection(boss:getAdjacentTiles());
    end

    function self:update(dt)
        local adjTiles = boss:getAdjacentTiles();

        if boss:getMissileCount() < 4 then
            boss:shoot();
        end

        if not adjTiles[direction]:isPassable() or tileCounter >= 5 then
            direction = newDirection(adjTiles);
            tileCounter = 0;
        else
            boss:move(dt, direction);
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

    function self:exit() end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Move;

--==================================================================================================
-- Created 22.09.14 - 05:12                                                                        =
--==================================================================================================
