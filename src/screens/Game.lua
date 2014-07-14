--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Arena = require('src/game/Arena');
local Screen = require('lib/screens/Screen');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Game = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Game.new()
    local self = Screen.new();

    local arena;

    function self:init()
        arena = Arena.new();
        arena:init();
    end

    function self:draw()
        arena:draw();
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Game;

--==================================================================================================
-- Created 14.07.14 - 02:53                                                                        =
--==================================================================================================