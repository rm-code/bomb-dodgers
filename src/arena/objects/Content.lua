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

local Content = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Content.new(type, passable, x, y)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local x, y = x, y;
    local type = type;
    local passable = passable;
    local hazardous = false;
    local parentTile;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:draw()
        return;
    end

    function self:update(_)
        return;
    end

    function self:increaseDanger(_, _, _)
        return;
    end

    function self:decreaseDanger(_, _, _)
        return;
    end

    function self:explode(_, _, _)
        return;
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getType()
        return type;
    end

    function self:isPassable()
        return passable;
    end

    function self:isHazardous()
        return hazardous;
    end

    function self:getX()
        return x;
    end

    function self:getY()
        return y;
    end

    function self:getParent()
        return parentTile;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setHazardous(nhazardous)
        hazardous = nhazardous;
    end

    function self:setType(ntype)
        type = ntype;
    end

    function self:setParent(tile)
        parentTile = tile;
    end

    function self:setPassable(npassable)
        passable = npassable;
    end

    function self:setX(nx)
        x = nx;
    end

    function self:setY(ny)
        y = ny;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Content;

--==================================================================================================
-- Created 29.08.14 - 02:10                                                                        =
--==================================================================================================
