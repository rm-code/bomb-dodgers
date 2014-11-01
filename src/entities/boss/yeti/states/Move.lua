--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

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