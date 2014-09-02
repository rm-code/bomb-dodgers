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
    local previous;

    function self:switch(statename)
        -- Exit the current state and save it as the previous one.
        if current then
            current:exit();
            previous = current;
        end

        -- Enter the new state.
        current = states[statename];
        current:enter();
    end

    function self:update(dt)
        current:update(dt);
    end

    function self:initStates(nstates)
        states = nstates;
    end

    function self:draw()
        current:draw();
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