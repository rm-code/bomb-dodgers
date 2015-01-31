--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 Robert Machmer                                             --
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

local GAME_IDENTITY = "rmcode_BombDodgers";

local GAME_TITLE = "Bomb Dodgers";

local LOVE_VERSION = "0.9.1";

local GAME_VERSION = "v0245";

-- ------------------------------------------------
-- Local variables
-- ------------------------------------------------

local config;

-- ------------------------------------------------
-- Global Functions
-- ------------------------------------------------

---
-- Initialise löve's config file.
-- @param _conf
--
function love.conf(t)
    t.identity = GAME_IDENTITY;
    t.version = LOVE_VERSION;
    t.console = true;

    t.window.title = GAME_TITLE;
    t.window.icon = 'res/img/icon.png';
    t.window.width = 640;
    t.window.height = 480;
    t.window.borderless = false;
    t.window.resizable = true;
    t.window.minwidth = 640;
    t.window.minheight = 480;
    t.window.fullscreen = false;
    t.window.fullscreentype = "desktop";
    t.window.vsync = true;
    t.window.fsaa = 0;
    t.window.display = 1;
    t.window.highdpi = false;
    t.window.srgb = false;

    t.modules.audio = true;
    t.modules.event = true;
    t.modules.graphics = true;
    t.modules.image = true;
    t.modules.joystick = true;
    t.modules.keyboard = true;
    t.modules.math = true;
    t.modules.mouse = true;
    t.modules.physics = true;
    t.modules.sound = true;
    t.modules.system = true;
    t.modules.timer = true;
    t.modules.window = true;

    config = t;
end

---
-- Returns the config file.
--
function getConfig()
    if config then
        return config;
    end
end

---
-- Returns the game's version.
--
function getVersion()
    if GAME_VERSION then
        return GAME_VERSION;
    end
end

---
-- Returns the game's title.
--
function getTitle()
    return GAME_TITLE;
end

--==================================================================================================
-- Created 14.07.14 - 02:51                                                                        =
--==================================================================================================