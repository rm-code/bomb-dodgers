--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 Robert Machmer                                             --
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