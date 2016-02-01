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

local PlayerManager = require('src/entities/dodgers/PlayerManager');
local UpgradeManager = require('src/arena/objects/UpgradeManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Move = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Move.new(fsm, npc)
    local self = {};

    local tarX, tarY;
    local direction;
    local prevDirection;
    local possibleMove;
    local curTile;

    local function aquireTarget(x, y)
        local player = PlayerManager.getClosest(x, y);
        local upgrade = UpgradeManager.getClosest(x, y);

        if upgrade then
            if math.abs(x - upgrade:getX()) + math.abs(y - upgrade:getY()) < math.abs(x - player:getX()) + math.abs(y - player:getY()) then
                return upgrade:getX(), upgrade:getY();
            end
        end

        return player:getX(), player:getY();
    end

    local function getBestDirection(tarX, tarY)
        local adjTiles = npc:getAdjacentTiles();
        local bestDir;
        local cost;

        for dir, tile in pairs(adjTiles) do
            if tile:isPassable() and tile:isSafe() and dir ~= prevDirection then
                local ncost = math.abs(tile:getX() - tarX) + math.abs(tile:getY() - tarY);
                if not cost or ncost <= cost then
                    cost = ncost;
                    bestDir = dir;
                end
            end
        end

        return bestDir;
    end

    local function getPrevDirection(curDirection)
        if curDirection == 'n' then
            return 's';
        elseif curDirection == 's' then
            return 'n';
        elseif curDirection == 'e' then
            return 'w';
        elseif curDirection == 'w' then
            return 'e';
        end
    end

    local function tryToPlant()
        local adjTiles = npc:getAdjacentTiles();
        if npc:isSafeToPlant(adjTiles) and npc:isGoodToPlant(adjTiles, npc:getX(), npc:getY(), npc:getBlastRadius()) then
            npc:plantBomb();
        end
    end

    function self:enter()
        tarX, tarY = aquireTarget(npc:getPosition());
        direction = getBestDirection(tarX, tarY);
        prevDirection = getPrevDirection(direction);
        possibleMove = true;
        curTile = npc:getTile();
    end

    function self:update(dt)
        if not npc:getTile():isSafe() then
            fsm:switch('evade');
        end

        if possibleMove then
            possibleMove = npc:move(dt, direction);
        else
            fsm:switch('random');
            return;
        end

        if npc:getTile() ~= curTile then
            tarX, tarY = aquireTarget(npc:getPosition());
            direction = getBestDirection(tarX, tarY);
            prevDirection = getPrevDirection(direction);
            curTile = npc:getTile();

            tryToPlant();
        end
    end

    function self:exit()
        tarX, tarY = nil, nil;
        direction = nil;
        prevDirection = nil;
        possibleMove = true;
        curTile = nil;
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