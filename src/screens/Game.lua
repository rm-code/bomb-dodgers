--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local BombHandler = require('src/game/BombHandler');
local Arena = require('src/game/Arena');
local Player = require('src/game/Player');
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
    local player;

    function self:init()
        arena = Arena.new();
        arena:init();

        player = Player.new();
        player:init(arena);

        arena:removeRubble(player:getX(), player:getX(), 2);

        BombHandler.setArena(arena);
    end

    function self:update(dt)
        BombHandler.update(dt);
        player:update(dt);
        arena:update(dt);
    end

    function self:draw()
        BombHandler.draw();
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