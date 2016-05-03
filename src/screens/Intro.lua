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
local Screen = require( 'lib.screens.Screen' );
local ResourceManager = require( 'lib.ResourceManager' );
local Splash = require( 'lib.o-ten-one' );

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Intro = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local LOGO_DELAY = 3;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Intro.new()
    local self = Screen.new();

    local logo;
    local timer = 0;
    local x, y;

    local splash = Splash();

    function self:init()
        ResourceManager.loadResources();

        logo = love.graphics.newImage( 'res/img/ui/rmcode.png' );

        x = love.graphics.getWidth()  * 0.5 - logo:getWidth()  * 0.5;
        y = love.graphics.getHeight() * 0.5 - logo:getHeight() * 0.5;
    end

    function self:draw()
        if timer > LOGO_DELAY then
            splash:draw();
        else
            love.graphics.draw( logo, x, y );
        end
    end

    function self:update( dt )
        if timer > LOGO_DELAY then
            splash:update( dt );

            if splash.done then
                ScreenManager.switch( 'mainMenu' );
            end
        end

        timer = timer + dt;
    end

    function self:keyreleased( _ )
        ScreenManager.switch( 'mainMenu' );
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Intro;

--==================================================================================================
-- Created 03.11.14 - 18:03                                                                        =
--==================================================================================================
