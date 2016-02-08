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

local PlayerManager = require( 'src.entities.dodgers.PlayerManager' );
local UpgradeManager = require( 'src.arena.objects.UpgradeManager' );

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Move = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Move.new( fsm, npc )
    local self = {};

    local direction;
    local prevDirection;
    local possibleMove;
    local curTile;

    ---
    -- This function returns the coordinates to the next closest target which
    -- could either be the player or an upgrade.
    -- @param x (number) The x-coordinate of the npc.
    -- @param y (number) The y-coordinate of the npc.
    -- @return  (number) The x-coordinate of the target.
    -- @return  (number) The y-coordinate of the target.
    --
    local function aquireTarget( x, y )
        local player = PlayerManager.getClosest( x, y );
        local upgrade = UpgradeManager.getClosest( x, y );

        local px, py =  player:getPosition();
        if upgrade then
            local ux, uy = upgrade:getPosition();
            if math.abs( x - ux ) + math.abs( y - uy ) < math.abs( x - px ) + math.abs( y - py ) then
                return ux, uy;
            end
        end

        return px, py;
    end

    ---
    -- Checks the tiles adjacent to the tile the npc is currently standing on
    -- and returns which direction brings it closer to the target and is safe.
    -- @param tarX (number) The x-coordinate of the target the npc wants to reach.
    -- @param tarY (number) The y-coordinate of the target the npc wants to reach.
    -- @return     (string) The direction to pick (n, s, e, w).
    --
    local function getBestDirection( tarX, tarY )
        local adjTiles = npc:getAdjacentTiles();
        local bestDir;
        local lowestCost;

        for dir, tile in pairs( adjTiles ) do
            if tile:isPassable() and tile:isSafe() and dir ~= prevDirection then
                local newCost = math.abs( tile:getX() - tarX ) + math.abs( tile:getY() - tarY );
                if not lowestCost or newCost <= lowestCost then
                    lowestCost = newCost;
                    bestDir = dir;
                end
            end
        end

        return bestDir;
    end

    ---
    -- Gets the previous direction by "inverting" the current direction.
    -- @param curDirection (string) The current direction (n, s, e, w).
    -- @return             (string) The previous direction (n, s, e, w).
    --
    local function getPrevDirection( curDirection )
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

    ---
    -- Plants a bomb if at least one of the adjacent tiles is safe, if it is
    -- next to a soft wall, or if the player is within the blast radius of the
    -- bomb.
    --
    local function tryToPlant()
        local adjTiles = npc:getAdjacentTiles();
        if npc:isSafeToPlant( adjTiles ) and npc:isGoodToPlant( adjTiles, npc:getX(), npc:getY(), npc:getBlastRadius() ) then
            npc:plantBomb();
        end
    end

    ---
    -- Initialises this state.
    --
    function self:enter()
        local tarX, tarY = aquireTarget( npc:getPosition() );
        direction = getBestDirection( tarX, tarY );
        prevDirection = getPrevDirection( direction );
        possibleMove = true;
        curTile = npc:getTile();
    end

    function self:update( dt )
        if not npc:getTile():isSafe() then
            fsm:switch( 'evade' );
        end

        if possibleMove then
            possibleMove = npc:move( dt, direction );
        else
            fsm:switch( 'random' );
            return;
        end

        if npc:getTile() ~= curTile then
            local tarX, tarY = aquireTarget(npc:getPosition());
            direction = getBestDirection(tarX, tarY);
            prevDirection = getPrevDirection(direction);
            curTile = npc:getTile();

            tryToPlant();
        end
    end

    function self:exit()
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
