local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local InputManager = require('lib/InputManager');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');
local LevelIntro = require('src/screens/LevelIntro');
local LevelOutro = require('src/screens/LevelOutro');
local PlayerManager = require('src/entities/PlayerManager');
local NpcManager = require('src/entities/NpcManager');


-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Level = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Level.new(level, arena, scores, camera)
    local self = Screen.new();

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:init()
        ScreenManager.push(LevelIntro.new(level, scores));
    end

    function self:update(dt)
        if InputManager.hasCommand('COL') then
            PaletteSwitcher.nextPalette();
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
            PaletteSwitcher.set();
            camera:set();
            arena:draw();

            NpcManager.draw();

            PlayerManager.draw();

            camera:unset();
            PaletteSwitcher.unset();
        end
    end

    function self:close()
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