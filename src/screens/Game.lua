--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Screen = require('lib/screens/Screen');
local Arena = require('src/arena/Arena');
local NPC = require('src/entities/NPC');
local Player = require('src/entities/Player');
local PlayerManager = require('src/entities/PlayerManager');
local NpcManager = require('src/entities/NpcManager');
local Camera = require('lib/Camera');
local InputManager = require('lib/InputManager');
local Controls = require('src/Controls');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');

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
    local camera;

    function self:init()
        -- Set the input map for the game.
        InputManager.setMap(Controls.GAME);

        arena = Arena.new();
        arena:init('res/empty_level.lua');

        camera = Camera.new();
        camera:setZoom(3);
        camera:setBoundaries(32, 32, 22 * 32, 22 * 32);

        players = {};
        players[#players + 1] = Player.new(arena, 2, 2);

        for i = 1, #players do
            local id = PlayerManager.register(players[i]);
            players[i]:setId(id);
        end

        local npcs = {};
        npcs[#npcs + 1] = NPC.new(arena, 2, 20);
        npcs[#npcs + 1] = NPC.new(arena, 20, 20);
        npcs[#npcs + 1] = NPC.new(arena, 20, 2);

        for i = 1, #npcs do
            local id = NpcManager.register(npcs[i]);
            npcs[i]:setId(id);
        end

        -- Clear the spawn points from softwalls.
        arena:clearSpawns(players);
        arena:clearSpawns(npcs);
    end

    function self:update(dt)
        arena:update(dt);

        if PlayerManager.getPlayerCount() == 0 then
            return;
        end

        NpcManager.update(dt);

        for i = 1, #players do
            if not players[i]:isDead() then
                players[i]:update(dt);
                camera:track(players[i]:getRealX(), players[i]:getRealY(), 6, dt);
            end
        end
    end

    function self:draw()
        PaletteSwitcher.set();
        camera:set();
        arena:draw();

        NpcManager.draw();

        for i = 1, #players do
            if not players[i]:isDead() then
                players[i]:draw();
            end
        end
        camera:unset();
        PaletteSwitcher.unset();
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