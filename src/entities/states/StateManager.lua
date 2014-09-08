--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local StateManager = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function StateManager.new()
    local self = {};

    local states;
    local current;

    function self:switch(statename)
        if current then
            current:exit();
        end
        current = states[statename];
        current:enter();
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