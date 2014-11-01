--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Move = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Move.new(fsm, boss)
    local self = {};

    local direction;
    local curX, curY;
    local tileCounter = 0;
    local validDirs = {};

    local function newDirection(direction, adjTiles)
        for dir, tile in pairs(adjTiles) do
            if tile:isPassable() then
                validDirs[#validDirs + 1] = dir;
            end
        end
        return validDirs[love.math.random(1, #validDirs)];
    end

    function self:enter()
        curX, curY = boss:getPosition();
        direction = newDirection(direction, boss:getAdjacentTiles());
    end

    function self:update(dt)
        local adjTiles = boss:getAdjacentTiles();
        if tileCounter >= 10 then
            if love.math.random(0, 1) == 0 then
                fsm:switch('spawntentacles');
                direction = newDirection(direction, adjTiles);
                tileCounter = 0;
            else
                fsm:switch('charge');
            end
        elseif not adjTiles[direction]:isPassable() then
            direction = newDirection(direction, adjTiles);
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