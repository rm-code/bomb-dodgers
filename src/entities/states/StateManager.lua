-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local StateManager = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function StateManager.new()
    local self = {};

    local states;
    local current;

    function self:switch(statename)
        current = states[statename];
    end

    function self:update(dt)
        current:update(dt);
    end

    function self:initStates(nstates)
        states = nstates;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return StateManager;

--==================================================================================================
-- Created 13.08.14 - 13:50                                                                        =
--==================================================================================================