--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

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

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Math;

--==================================================================================================
-- Created 08.09.14 - 13:52                                                                        =
--==================================================================================================