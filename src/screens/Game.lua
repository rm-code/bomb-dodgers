--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Screen = require('lib/screens/Screen');
local Arena = require('src/Arena');
local NPC = require('src/entities/NPC');
local Player = require('src/entities/Player');
local PlayerManager = require('src/entities/PlayerManager');

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

        for i = 1, #players do
            local id = PlayerManager.register(players[i]);
            players[i]:setId(id);
        end

        npcs = {};
        npcs[#npcs + 1] = NPC.new(arena, 2, 20);
        npcs[#npcs + 1] = NPC.new(arena, 20, 20);
        npcs[#npcs + 1] = NPC.new(arena, 20, 2);

        -- Clear the spawn points from softwalls.
        arena:clearSpawns(players);
        arena:clearSpawns(npcs);
    end

    function self:update(dt)
        arena:update(dt);

        if PlayerManager.getPlayerCount() == 0 then
            return;
        end

        for i = 1, #npcs do
            if not npcs[i]:isDead() then
                npcs[i]:update(dt);
            end
        end

        for i = 1, #players do
            if not players[i]:isDead() then
                players[i]:update(dt);
            end
        end
    end

    function self:draw()
        arena:draw();
        for i = 1, #npcs do
            if not npcs[i]:isDead() then
                npcs[i]:draw();
            end
        end

        for i = 1, #players do
            if not players[i]:isDead() then
                players[i]:draw();
            end
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