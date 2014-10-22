--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local InputManager = require('lib/InputManager');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');
local PlayerManager = require('src/entities/dodgers/PlayerManager');
local NpcManager = require('src/entities/dodgers/NpcManager');
local ResourceManager = require('lib/ResourceManager');
local SoundManager = require('lib/SoundManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Level = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local music = {};

ResourceManager.register(Level);

function Level.loadMusic()
    music['stonegarden'] = ResourceManager.loadMusic('res/music/level1.ogg', 'static');
    music['stonegarden']:setRelative(true);
    music['stonegarden']:setLooping(true);
    music['desert'] = ResourceManager.loadMusic('res/music/level2.ogg', 'static');
    music['desert']:setRelative(true);
    music['desert']:setLooping(true);
    music['snow'] = ResourceManager.loadMusic('res/music/level3.ogg', 'static');
    music['snow']:setRelative(true);
    music['snow']:setLooping(true);
    music['forest'] = ResourceManager.loadMusic('res/music/level4.ogg', 'static');
    music['forest']:setRelative(true);
    music['forest']:setLooping(true);
    music['boss'] = ResourceManager.loadMusic('res/music/boss.ogg', 'static');
    music['boss']:setRelative(true);
    music['boss']:setLooping(true);
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Level.new(level, stage, arena, scores, camera)
    local self = Screen.new();

    local paletteShader;
    local curSong;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:init()
        paletteShader = PaletteSwitcher.new();

        if stage == 4 then
            curSong = music['boss'];
        else
            curSong = music[level];
        end
        SoundManager.play(curSong, 'music', 0, 0, 0);
    end

    function self:update(dt)
        if InputManager.hasCommand('COL') then
            PaletteSwitcher.nextPalette();
        end
        if InputManager.hasCommand('CHEAT') then
            local npcs = NpcManager.getNpcs();
            for i = 1, #npcs do
                npcs[i]:setDead(true);
            end
        end

        if self:isActive() then
            arena:update(dt);

            PlayerManager.update(dt);
            if PlayerManager.getCount() == 0 then
                scores[#scores + 1] = 'npc';
                ScreenManager.pop();
                return;
            end

            NpcManager.update(dt);
            if NpcManager.getCount() == 0 then
                scores[#scores + 1] = 'player';
                ScreenManager.pop();
                return;
            end
        end
    end

    function self:draw()
        if self:isActive() then
            paletteShader:set();
            camera:set();
            arena:draw();

            NpcManager.draw();

            PlayerManager.draw();

            camera:unset();
            paletteShader:unset();
        end
    end

    function self:close()
        curSong:stop();
        ScreenManager.push(LevelOutro.new(level, scores));
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