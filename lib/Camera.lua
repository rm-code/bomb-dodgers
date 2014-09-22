--==================================================================================================
-- Copyright (c) 2014 Robert Machmer                                                               =
--                                                                                                 =
-- This software is provided 'as-is', without any express or implied                               =
-- warranty. In no event will the authors be held liable for any damages                           =
-- arising from the use of this software.                                                          =
--                                                                                                 =
-- Permission is granted to anyone to use this software for any purpose,                           =
-- including commercial applications, and to alter it and redistribute it                          =
-- freely, subject to the following restrictions:                                                  =
--                                                                                                 =
-- 1. The origin of this software must not be misrepresented; you must not                         =
--    claim that you wrote the original software. If you use this software                         =
--    in a product, an acknowledgment in the product documentation would be                        =
--    appreciated but is not required.                                                             =
-- 2. Altered source versions must be plainly marked as such, and must not be                      =
--    misrepresented as being the original software.                                               =
-- 3. This notice may not be removed or altered from any source distribution.                      =
--                                                                                                 =
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
    local zoom = zoom or 2;
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
        zoom = Math.clamp(0.5, zoom + dZoom, 10);
    end

    function self:track(tarX, tarY, speed, dt)
        local nX = x - (x - math.floor(tarX)) * dt * speed;
        local nY = y - (y - math.floor(tarY)) * dt * speed;
        x = (minX and maxX) and Math.clamp(minX + screenW / (2 * zoom), nX, maxX - screenW / (2 * zoom)) or nX;
        y = (minY and maxY) and Math.clamp(minY + screenH / (2 * zoom), nY, maxY - screenH / (2 * zoom)) or nY;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setZoom(z)
        zoom = Math.clamp(0.5, z, 5);
    end

    function self:setBoundaries(mX, mY, mxX, mxY)
        minX, maxX, minY, maxY = mX, mxX, mY, mxY;
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