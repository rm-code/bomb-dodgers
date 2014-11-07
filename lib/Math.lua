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

local Math = {};

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

---
-- Clamps a value to a certain range.
-- @param min - The minimum value to return.
-- @param val - The value to clamp.
-- @param max - The maximum value to return.
--
function Math.clamp(min, val, max)
    return math.max(min, math.min(val, max));
end

---
-- Lerps a value to another value.
--
-- @see: http://en.wikipedia.org/wiki/Linear_interpolation
--
-- @param a - The value to lerp.
-- @param b - The value to lerp to.
-- @param t - The factor by which to lerp.
--
function Math.lerp(a, b, t)
    return (1 - t) * a + t * b;
end

---
-- Returns a random sign.
--
function Math.rndsign()
    return love.math.random(0, 1) == 0 and -1 or 1;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Math;

--==================================================================================================
-- Created 08.09.14 - 13:52                                                                        =
--==================================================================================================