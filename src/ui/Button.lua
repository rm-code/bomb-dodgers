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

local Button = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Button.new(img, x, y, sx, sy, target)
    local self = {};

    local active;
    local alpha;
    local sx, sy = sx or 1, sy or 1;

    function self:draw()
        love.graphics.setColor(255, 255, 255, alpha);
        love.graphics.draw(img, x, y, 0, sx, sy);
        love.graphics.setColor(255, 255, 255, 255);
    end

    function self:update()
        alpha = active and 255 or 100;
    end

    function self:setActive(_active)
        active = _active;
    end

    function self:press()
        target();
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Button;

--==================================================================================================
-- Created 11.09.14 - 19:36                                                                        =
--==================================================================================================