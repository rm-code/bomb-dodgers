-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Hurt = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Hurt.new(fsm, boss)
    local self = {};

    local dmgTimer = 3;

    function self:enter()
        boss:setInvincible(true);
    end

    function self:update(dt)
        dmgTimer = dmgTimer - dt;
        if dmgTimer <= 0 then
            dmgTimer = 3;
            boss:setAlpha(255);
            fsm:switch('move');
        else
            boss:pulse(dt);
        end
    end

    function self:exit()
        boss:setInvincible(false);
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Hurt;

--==================================================================================================
-- Created 29.09.14 - 11:29                                                                        =
--==================================================================================================