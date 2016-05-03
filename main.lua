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

local ScreenManager = require( 'lib.screens.ScreenManager' );
local ScreenScaler = require( 'lib.ScreenScaler' );
local InputManager = require( 'lib.InputManager' );
local ProfileHandler = require( 'src.profile.ProfileHandler' );
local SoundManager = require( 'lib.SoundManager' );
local PaletteSwitcher = require( 'lib.colswitcher.PaletteSwitcher' );

-- ------------------------------------------------
-- Loading
-- ------------------------------------------------

function love.load()
    print("===================")
    print(string.format("Title: '%s'", getTitle()));
    print(string.format("Version: %s", getVersion()));
    print(string.format("LOVE Version: %d.%d.%d (%s)", love.getVersion()));
    print( string.format( "Resolution: %dx%d", love.graphics.getDimensions() ));
    print("===================")

    -- Check the user's hardware.
    print( "\n---- RENDERER  ---- " );
    local name, version, vendor, device = love.graphics.getRendererInfo();
    print( string.format( "Name: %s \nVersion: %s \nVendor: %s \nDevice: %s", name, version, vendor, device ));

    print( "\n----  SYSTEM   ---- " );
    print( love.system.getOS() );
    print( "===================" );
    print( os.date( '%c', os.time() ));
    print( "===================" );

    -- Set default filters.
    love.graphics.setDefaultFilter('nearest', 'nearest');

    -- Set volume.
    local profile = ProfileHandler.load();
    SoundManager.setVolume('sfx', profile.sfx / 10);
    SoundManager.setVolume('music', profile.music / 10);

    ScreenScaler.init(profile.mode, profile.scaleX, profile.scaleY, profile.vsync);

    PaletteSwitcher.init('lib/colswitcher/palettes.png', 'lib/colswitcher/palette.fs');
    PaletteSwitcher.setActive(profile.shaders);

    local screens = {
        intro         = require( 'src.screens.Intro' );
        level         = require( 'src.screens.Level' );
        levelMenu     = require( 'src.screens.LevelMenu' );
        levelOutro    = require( 'src.screens.LevelOutro' );
        levelSwitcher = require( 'src.screens.LevelSwitcher' );
        mainMenu      = require( 'src.screens.MainMenu' );
        options       = require( 'src.screens.Options' );
        modal         = require( 'src.screens.Modal' );
    };

    ScreenManager.init( screens, 'intro' );
end

-- ------------------------------------------------
-- Periodical Updates
-- ------------------------------------------------

function love.update(dt)
    ScreenManager.update(dt);
    InputManager.update(dt);
end

function love.draw()
    ScreenManager.draw();

    -- InputManager.draw();
end

-- ------------------------------------------------
-- Window
-- ------------------------------------------------

function love.resize(width, height)
    ScreenManager.resize(width, height);
end

function love.visible(visible)
    ScreenManager.visible(visible);
end

function love.focus(focus)
    ScreenManager.focus(focus);
end

-- ------------------------------------------------
-- Input
-- ------------------------------------------------

function love.keypressed(key)
    if key == 'tab' then
        PaletteSwitcher.next();
    end

    ScreenManager.keypressed(key);
end

function love.keyreleased(key)
    ScreenManager.keyreleased(key);
end

function love.textinput(input)
    ScreenManager.textinput(input);
end

function love.mousepressed(x, y, button)
    ScreenManager.mousepressed(x, y, button);
end

function love.mousereleased(x, y, button)
    ScreenManager.mousereleased(x, y, button);
end

function love.mousefocus(focus)
    ScreenManager.mousefocus(focus);
end

function love.joystickadded(joystick)
    InputManager.addJoystick(joystick);
end

function love.joystickremoved(joystick)
    InputManager.removeJoystick(joystick);
end

-- ------------------------------------------------
-- Misc
-- ------------------------------------------------

function love.quit() end

--==================================================================================================
-- Created 14.07.14 - 02:51                                                                        =
--==================================================================================================
