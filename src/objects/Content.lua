-- ------------------------------------------------
-- Module
-- ------------------------------------------------

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
    local parentTile;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(_)
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

return Content; --==================================================================================================
-- Created 29.08.14 - 02:10                                                                        =
--==================================================================================================