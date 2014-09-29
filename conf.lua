--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local GAME_IDENTITY = "rmcode_BombDodgers";

local GAME_TITLE = "Bomb Dodgers";

local LOVE_VERSION = "0.9.1";

local GAME_VERSION = "v0155-6038";

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
    t.window.icon = nil;
    t.window.width = 0;
    t.window.height = 0;
    t.window.borderless = false;
    t.window.resizable = true;
    t.window.minwidth = 800;
    t.window.minheight = 600;
    t.window.fullscreen = false;
    t.window.fullscreentype = "desktop";
    t.window.vsync = true;
    t.window.fsaa = 0;
    t.window.display = 2;
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