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

local Constants = require( 'src.Constants' );
local Screen = require( 'lib.screens.Screen' );
local ScreenManager = require( 'lib.screens.ScreenManager' );
local InputManager = require( 'lib.InputManager' );
local Controls = require( 'src.Controls' );
local Arena = require( 'src.arena.Arena' );
local PlayerManager = require( 'src.entities.dodgers.PlayerManager' );
local Player = require( 'src.entities.dodgers.Player' );
local NpcManager = require( 'src.entities.dodgers.NpcManager' );
local Npc = require( 'src.entities.dodgers.Npc' );
local Camera = require( 'lib.Camera' );
local ProfileHandler = require( 'src.profile.ProfileHandler' );

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local LevelSwitcher = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local BOSS_SPAWN = { x = 10, y = 12 };

local SPAWNS = {
    { x = 2, y = 2 },
    { x = 20, y = 20 },
    { x = 2, y = 20 },
    { x = 20, y = 2 },
};

local LEVELS = {
    'stone',
    'desert',
    'snow',
    'forest',
};

local BOSSES = {
    require('src.entities.boss.robot.Robot'),
    require('src.entities.boss.mummy.Mummy'),
    require('src.entities.boss.yeti.Yeti'),
    require('src.entities.boss.ant.Ant'),
};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function LevelSwitcher.new()
    local self = Screen.new();

    local camera;

    local level; -- The current level (stonegarden, desert, ...).
    local stage;

    local rounds;

    local arena;
    local profile;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    ---
    -- Create the arena on which the game will be played.
    -- @param tileset
    --
    local function createArena(tileset)
        local arena = Arena.new(tileset);
        arena:init('res/arenas/layout_Arena.lua');
        return arena;
    end

    ---
    -- Add a new player and attach a camera to it.
    -- @param arena
    -- @param camera
    --
    local function addPlayer(arena, camera)
        local count = PlayerManager.getCount();
        local player = Player.new(arena, SPAWNS[count + 1].x, SPAWNS[count + 1].y);
        player:setCamera(camera);
        PlayerManager.register(player);
    end

    ---
    -- Add a new npc and register it with the NpcManager.
    -- @param arena
    --
    local function addNpc(arena)
        local count = NpcManager.getCount() + PlayerManager.getCount();
        local npc = Npc.new(arena, SPAWNS[count + 1].x, SPAWNS[count + 1].y);
        NpcManager.register(npc);
    end

    ---
    -- Clear the npc manager and create a boss.
    -- @param arena
    --
    local function addBoss(arena)
        NpcManager.clear();

        local boss = BOSSES[level].new(arena, BOSS_SPAWN.x, BOSS_SPAWN.y);
        NpcManager.register(boss);
    end

    ---
    -- Create a new camera.
    --
    local function createCamera()
        local camera = Camera.new();
        camera:setScale(2, 2);
        camera:setBoundaries(Constants.TILESIZE, Constants.TILESIZE, 22 * Constants.TILESIZE, 22 * Constants.TILESIZE);
        return camera;
    end

    local function checkScore(scores)
        local pScore, npcScore = 0, 0;

        for i = 1, #scores do
            if scores[i] == 'npc' then
                npcScore = npcScore + 1;
            else
                pScore = pScore + 1;
            end
        end

        return pScore, npcScore;
    end

    local function clearScores(rounds)
        for i = 1, #rounds do
            rounds[i] = nil;
        end
    end

    local function endRound(arena, rounds)
        local pScore, npcScore = checkScore(rounds);

        if stage == 4 and pScore == 1 then
            level = level + 1 > #LEVELS and 1 or level + 1;

            -- Unlock the next level.
            profile['door' .. level] = true;
            ProfileHandler.save(profile);

            stage = 1;
            NpcManager.clear();
            addNpc(arena);
            clearScores(rounds);
        elseif stage == 4 then
            clearScores(rounds);
        elseif pScore == 2 then
            if stage == 3 then
                addBoss(arena);
            else
                addNpc(arena);
            end
            stage = stage + 1;
            clearScores(rounds);
        elseif npcScore == 2 then
            clearScores(rounds);
        end

        local players = PlayerManager.getPlayers();
        for i = 1, #players do
            players[i]:setDead(false);
            players[i]:reset();
            players[i]:setPosition(SPAWNS[i].x, SPAWNS[i].y);
        end

        local npcs = NpcManager.getNpcs();
        for i = 1, #npcs do
            npcs[i]:setDead(false);
            npcs[i]:reset();
            if stage == 4 then
                npcs[i]:setPosition(BOSS_SPAWN.x, BOSS_SPAWN.y);
            else
                npcs[i]:setPosition(SPAWNS[i + #players].x, SPAWNS[i + #players].y);
            end
        end

        arena:setTilesheet(LEVELS[level]);
        arena:reset(LEVELS[level], stage == 4);
        arena:clearSpawns(players);
        arena:clearSpawns(npcs);

        if stage == 4 then
            arena:spawnUpgrades(5);
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:init( index )
        -- Set the input map for the game.
        InputManager.setMap(Controls.GAME);

        level = index;
        stage = 1;
        rounds = {};
        arena = createArena(LEVELS[level]);
        camera = createCamera();
        addPlayer(arena, camera);
        addNpc(arena);
        arena:clearSpawns(PlayerManager.getPlayers());
        arena:clearSpawns(NpcManager.getNpcs());

        profile = ProfileHandler.load();

        ScreenManager.push( 'level', LEVELS[level], stage, arena, rounds, camera );
    end

    function self:update()
        if self:isActive() then
            endRound(arena, rounds);
            ScreenManager.push( 'level', LEVELS[level], stage, arena, rounds, camera );
        end
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return LevelSwitcher;

--==================================================================================================
-- Created 28.09.14 - 20:40                                                                        =
--==================================================================================================
