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

    ---
    -- Switches to a new state.
    -- @param statename
    --
    function self:switch(statename)
        if current then
            current:exit();
        end
        current = states[statename];
        current:enter();
    end

    ---
    -- Updates the current state.
    -- @param dt
    --
    function self:update(dt)
        current:update(dt);
    end

    ---
    -- Gets a list of states from which to
    -- pick new ones.
    -- @param nstates
    --
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