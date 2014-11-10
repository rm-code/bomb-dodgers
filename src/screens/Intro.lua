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

local ScreenManager = require('lib/screens/ScreenManager');
local Screen = require('lib/screens/Screen');
local ResourceManager = require('lib/ResourceManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Intro = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local DISPLAY_TIME = 3;
local WIDTH = 640;
local HEIGHT = 480;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Intro.new()
    local self = Screen.new();

    local logos = {};
    local loading = false;
    local index = 1;
    local x, y;

    function self:init()
        logos[1] = love.graphics.newImage('res/img/ui/rmcode.png');
        logos[2] = love.graphics.newImage('res/img/ui/love.png');

        x = WIDTH * 0.5 - logos[index]:getWidth() * 0.5;
        y = HEIGHT * 0.5 - logos[index]:getHeight() * 0.5;
    end

    function self:draw()
        love.graphics.draw(logos[index], x, y);
    end

    local counter = 0;
    function self:update(dt)
        counter = counter + dt;
        if not loading and counter > 0.05 then
            -- Load resources.
            ResourceManager.loadResources();
            loading = true;
            counter = 0;
        end

        if counter > DISPLAY_TIME then
            index = index + 1;
            if index > 2 then
                ScreenManager.switch(MainMenu.new());
            else
                x = WIDTH * 0.5 - logos[index]:getWidth() * 0.5;
                y = HEIGHT * 0.5 - logos[index]:getHeight() * 0.5;
            end
            counter = 0;
        end
    end

    function self:keypressed(key)
        if key ~= 'return' and loading then
            ScreenManager.switch(MainMenu.new());
        end
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