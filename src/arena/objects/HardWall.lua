--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Content = require('src/arena/objects/Content');
local Constants = require('src/Constants');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local HardWall = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function HardWall.new(x, y)
    local self = Content.new(CONTENT.HARDWALL, false, x, y);

    function self:explode(_, _, _)
        return;
    end

    function self:increaseDanger(_, _, _)
        return;
    end

    function self:decreaseDanger(_, _, _)
        return;
    end

    return self;
end

return HardWall;

--==================================================================================================
-- Created 24.07.14 - 23:12                                                                        =
--==================================================================================================