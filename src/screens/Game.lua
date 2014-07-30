--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Screen = require('lib/screens/Screen');
local Arena = require('src/game/Arena');
local Player = require('src/game/Player');

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
    local player;

    function self:init()
        arena = Arena.new();
        arena:init();

        player = Player.new();
        player:init(arena, 2, 2);
    end

    function self:update(dt)
        arena:update(dt);
        player:update(dt);
    end

    function self:draw()
        arena:draw();
        player:draw();
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