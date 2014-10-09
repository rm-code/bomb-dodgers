--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Move = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Move.new(fsm, entity)
    local self = {};

    local direction = 'e';
    local lastRow;
    local missileTimer = 3;
    local minionTimer = 0;

    local function newDirection(direction, adjTiles)
        local ndir;
        if direction == 's' or direction == 'n' then
            ndir = adjTiles['e']:isPassable() and 'e' or 'w';
        elseif direction == 'e' or direction == 'w' then
            ndir = love.math.random(0, 1) == 0 and 'n' or 's';
        end
        return ndir;
    end

    function self:enter()
        lastRow = entity:getY();
    end

    function self:update(dt)
        local adjTiles = entity:getAdjacentTiles();

        if adjTiles[direction] then
            if math.abs(entity:getY() - lastRow) >= 2 then
                direction = newDirection(direction, adjTiles);
                lastRow = entity:getY();
            end

            if not entity:move(dt, direction) then
                direction = newDirection(direction, adjTiles);
            end
        end

        missileTimer = missileTimer - dt;
        if missileTimer <= 0 and entity:getMissileCount() == 0 then
            entity:shoot();
            missileTimer = 3;
        end

        minionTimer = minionTimer - dt;
        if minionTimer <= 0 and entity:getMinionCount() == 0 then
            entity:releaseMinions();
            minionTimer = 3;
        end
    end

    function self:exit()
        direction = 'e';
        missileTimer = 3;
        minionTimer = 0;
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