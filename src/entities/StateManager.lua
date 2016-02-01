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