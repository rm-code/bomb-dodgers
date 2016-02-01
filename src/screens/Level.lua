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

local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
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
    music['stone'] = ResourceManager.loadMusic('res/music/level1.ogg', 'static');
    music['stone']:setRelative(true);
    music['stone']:setLooping(true);
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

    local curSong;

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:init()
        if stage == 4 then
            curSong = music['boss'];
        else
            curSong = music[level];
        end
        SoundManager.play(curSong, 'music', 0, 0, 0);
    end

    function self:update(dt)
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
            camera:set();
            arena:draw();

            NpcManager.draw();

            PlayerManager.draw();

            camera:unset();
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
