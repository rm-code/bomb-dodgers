--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Button = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Button.new(img, x, y, target)
    local self = {};

    local active;
    local alpha;

    function self:draw()
        love.graphics.setColor(255, 255, 255, alpha);
        love.graphics.draw(img, x, y);
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