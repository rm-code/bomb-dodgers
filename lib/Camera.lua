--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Math = require('lib/Math');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Camera = {};

function Camera.new()
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local x, y = 0, 0;
    local sx, sy = 1, 1;
    local baseX, baseY = 640, 480;
    local minX, minY, maxX, maxY;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:set()
        love.graphics.push();
        love.graphics.scale(sx, sy);
        love.graphics.translate(baseX / (2 * sx), baseY / (2 * sy));
        love.graphics.translate(-x, -y);
    end

    function self:unset()
        love.graphics.pop();
    end

    function self:scale(dsx, dsy)
        sx = sx + dsx;
        sy = sy + dsy;
    end

    function self:track(tarX, tarY, speed, dt)
        local nX = x - (x - math.floor(tarX)) * dt * speed;
        local nY = y - (y - math.floor(tarY)) * dt * speed;
        x = (minX and maxX) and Math.clamp(minX + baseX / (2 * sx), nX, maxX - baseX / (2 * sy)) or nX;
        y = (minY and maxY) and Math.clamp(minY + baseY / (2 * sx), nY, maxY - baseY / (2 * sy)) or nY;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setScale(nsx, nsy)
        sx = nsx;
        sy = nsy;
    end

    function self:setPosition(nx, ny)
        x, y = nx, ny;
    end

    function self:setBoundaries(mX, mY, mxX, mxY)
        minX, maxX, minY, maxY = mX, mxX, mY, mxY;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Camera;

--==================================================================================================
-- Created 08.09.14 - 13:34                                                                        =
--==================================================================================================