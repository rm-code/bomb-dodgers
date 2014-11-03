--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

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