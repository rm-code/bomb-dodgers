--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Screen = require('lib/screens/Screen');
local Arena = require('src/game/Arena');
local NPC = require('src/game/entities/NPC');
local Player = require('src/game/entities/Player');

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
    local players;
    local npcs;

    function self:init()
        arena = Arena.new();
        arena:init();

        players = {};
        players[#players + 1] = Player.new(arena, 2, 2);

        npcs = {};
        npcs[#npcs + 1] = NPC.new(arena, 2, 20);
        npcs[#npcs + 1] = NPC.new(arena, 20, 20);
        npcs[#npcs + 1] = NPC.new(arena, 20, 2);
    end

    function self:update(dt)
        arena:update(dt);

        for i = 1, #npcs do
            npcs[i]:update(dt);
        end

        for i = 1, #players do
            players[i]:update(dt);
        end
    end

    function self:draw()
        arena:draw();
        for i = 1, #npcs do
            npcs[i]:draw();
        end

        for i = 1, #players do
            players[i]:draw();
        end
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