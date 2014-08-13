-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local State = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function State.new()
    local self = {};

    function self:enter() end

    function self:exit() end

    function self:update() end

    function self:draw() end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return State;

--==================================================================================================
-- Created 13.08.14 - 15:11                                                                        =
--==================================================================================================