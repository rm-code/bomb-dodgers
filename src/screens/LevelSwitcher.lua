local Constants = require('src/Constants');
local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local Level = require('src/screens/Level');
local InputManager = require('lib/InputManager');
local Controls = require('src/Controls');
local Arena = require('src/arena/Arena');
local PlayerManager = require('src/entities/PlayerManager');
local Player = require('src/entities/Player');
local NpcManager = require('src/entities/NpcManager');
local Npc = require('src/entities/Npc');
local Camera = require('lib/Camera');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local LevelSwitcher = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local SPAWNS = {
    { x = 2, y = 2 },
    { x = 20, y = 20 },
    { x = 2, y = 20 },
    { x = 20, y = 2 },
}

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function LevelSwitcher.new()
    local self = Screen.new();

    local camera;

    local level; -- The current level (stonegarden, desert, ...).

    local scores;

    local arena;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function createArena(tileset)
        local arena = Arena.new(tileset);
        arena:init('res/arenas/basicLayout.lua');
        return arena;
    end

    local function addPlayer(arena)
        local count = PlayerManager.getCount();
        local player = Player.new(arena, SPAWNS[count + 1].x, SPAWNS[count + 1].y);
        local id = PlayerManager.register(player);
        player:setId(id);
    end

    local function addNpc(arena)
        local count = NpcManager.getCount() + PlayerManager.getCount();
        local npc = Npc.new(arena, SPAWNS[count + 1].x, SPAWNS[count + 1].y);
        local id = NpcManager.register(npc);
        npc:setId(id);
    end

    local function createCamera()
        local camera = Camera.new();
        camera:setZoom(3);
        camera:setBoundaries(Constants.TILESIZE, Constants.TILESIZE, 22 * Constants.TILESIZE, 22 * Constants.TILESIZE);
        return camera;
    end

    local function endRound(arena, scores)
        local pScore = 0;
        local npcScore = 0;

        for i = 1, #scores do
            if scores[i] == 'npc' then
                npcScore = npcScore + 1;
            else
                pScore = pScore + 1;
            end
        end

        if #scores == 3 or pScore == 2 then
            addNpc(arena);
            for i = 1, #scores do
                scores[i] = nil;
            end
        elseif npcScore == 2 then
            for i = 1, #scores do
                scores[i] = nil;
            end
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
            npcs[i]:setPosition(SPAWNS[i + #players].x, SPAWNS[i + #players].y);
        end

        arena:reset();
        arena:clearSpawns(players);
        arena:clearSpawns(npcs);
    end

    function self:init()
        -- Set the input map for the game.
        InputManager.setMap(Controls.GAME);

        scores = {};
        arena = createArena('stonegarden');
        camera = createCamera();
        addPlayer(arena);
        addNpc(arena);
        arena:clearSpawns(PlayerManager.getPlayers());
        arena:clearSpawns(NpcManager.getNpcs());
        PlayerManager.attachCamera(camera, 1);

        ScreenManager.push(Level.new('stonegarden', arena, scores, camera));
    end

    function self:update()
        if self:isActive() then
            endRound(arena, scores);
            ScreenManager.push(Level.new('stonegarden', arena, scores, camera));
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