--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Math = require('lib/Math');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Camera = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Camera.new(x, y, zoom)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local x = x or 0;
    local y = y or 0;
    local zoom = zoom or 0;
    local minX, minY, maxX, maxY;

    local screenW, screenH = love.graphics.getDimensions();

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:set()
        love.graphics.push();
        love.graphics.scale(zoom, zoom);
        love.graphics.translate(screenW / (2 * zoom), screenH / (2 * zoom));
        love.graphics.translate(-x, -y);
    end

    function self:unset()
        love.graphics.pop();
    end

    function self:zoom(dZoom)
        zoom = Math.clamp(0.5, zoom + dZoom, 5);
    end

    function self:track(tarX, tarY, speed, dt)
        local nX = x - (x - math.floor(tarX)) * dt * speed;
        local nY = y - (y - math.floor(tarY)) * dt * speed;

        if minX and maxX then
            x = Math.clamp(minX + screenW / (2 * zoom), nX, maxX - screenW / (2 * zoom));
        else
            x = nX;
        end

        if minY and maxY then
            y = Math.clamp(minY + screenH / (2 * zoom), nY, maxY - screenH / (2 * zoom));
        else
            y = nY;
        end
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setZoom(_zoom)
        zoom = Math.clamp(0.5, _zoom, 5);
    end

    function self:setBoundaries(_minX, _minY, _maxX, _maxY)
        minX, maxX, minY, maxY = _minX, _maxX, _minY, _maxY;
    end

    -- ------------------------------------------------
    -- Return Object
    -- ------------------------------------------------

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Camera;

--==================================================================================================
-- Created 08.09.14 - 13:34                                                                        =
--==================================================================================================