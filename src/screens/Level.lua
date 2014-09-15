local Constants = require('src/Constants');
local Screen = require('lib/screens/Screen');
local Arena = require('src/arena/Arena');
local Camera = require('lib/Camera');
local InputManager = require('lib/InputManager');
local Controls = require('src/Controls');
local Player = require('src/entities/Player');
local PlayerManager = require('src/entities/PlayerManager');
local Npc = require('src/entities/Npc');
local NpcManager = require('src/entities/NpcManager');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Level = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Level.new(tileset)
    local self = Screen.new();

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local arena;
    local camera;
    local players;
    local npcs;
    local stage;
    local round;
    local playerScore;
    local npcScore;

    local SPAWNS = {
        { x = 20, y = 20 },
        { x = 2, y = 20 },
        { x = 20, y = 2 },
    }

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function generatePlayers(arena)
        PlayerManager.clear();
        players = {};
        players[#players + 1] = Player.new(arena, 2, 2);
        local id = PlayerManager.register(players[1]);
        players[1]:setId(id);
    end

    local function generateNpcs(amount)
        NpcManager.clear();

        npcs = {};
        for i = 1, amount do
            npcs[i] = Npc.new(arena, SPAWNS[i].x, SPAWNS[i].y);
            local id = NpcManager.register(npcs[i]);
            npcs[i]:setId(id);
        end
    end

    local function clearSpawns(arena, npcs, players)
        arena:clearSpawns(players);
        arena:clearSpawns(npcs);
    end

    local function generateArena(tileset)
        -- Create new arena and load basic level layout.
        arena = Arena.new(tileset);
        arena:init('res/arenas/basicLayout.lua');
    end

    local function reset()
        generateArena(tileset);
        generatePlayers(arena);
        generateNpcs(stage);
        clearSpawns(arena, npcs, players);
    end

    local function endRound(winner)
        self:setActive(false);

        round = round + 1;

        if winner == 'npc' then
            npcScore = npcScore + 1;
        else
            playerScore = playerScore + 1;
        end

        if playerScore == 2 then
            stage = stage + 1;
            round = 1;
            playerScore = 0;
            npcScore = 0;
            -- error('A winner is you.');
        elseif npcScore == 2 then
            round = 1;
            playerScore = 0;
            npcScore = 0;
            -- error('A winner is npc.');
        end

        reset();
        self:setActive(true);
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:init()
        -- Set the input map for the game.
        InputManager.setMap(Controls.GAME);

        generateArena(tileset);

        stage = 1;
        round = 1;
        playerScore = 0;
        npcScore = 0;

        -- Generate players.
        generatePlayers(arena);

        -- Generate enemies.
        generateNpcs(stage);

        -- Clear the area around the spawns from softwalls.
        clearSpawns(arena, npcs, players);

        camera = Camera.new();
        camera:setZoom(3);
        camera:setBoundaries(Constants.TILESIZE, Constants.TILESIZE, 22 * Constants.TILESIZE, 22 * Constants.TILESIZE);
    end

    function self:update(dt)
        if InputManager.hasCommand('COL') then
            PaletteSwitcher.nextPalette();
        end

        if self:isActive() then
            if PlayerManager.getPlayerCount() == 0 then
                endRound('npc');
                return;
            elseif NpcManager.getNpcCount() == 0 then
                endRound('player');
                return;
            end

            arena:update(dt);

            for i = 1, #players do
                if not players[i]:isDead() then
                    players[i]:update(dt);
                    camera:track(players[i]:getRealX(), players[i]:getRealY(), 6, dt);
                end
            end

            NpcManager.update(dt);
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

        love.graphics.setColor(0, 0, 0);
        love.graphics.print('NPCs:' .. NpcManager.getNpcCount(), 20, 20);
        love.graphics.print('Players:' .. PlayerManager.getPlayerCount(), 20, 40);
        love.graphics.print('Round:' .. round, 20, 60);
        love.graphics.print('Stage:' .. stage, 20, 80);
        love.graphics.setColor(255, 255, 255);
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Level;

--==================================================================================================
-- Created 14.09.14 - 01:01                                                                        =
--==================================================================================================