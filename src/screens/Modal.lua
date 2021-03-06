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

local ResourceManager = require( 'lib.ResourceManager' );
local Screen = require( 'lib.screens.Screen' );
local ButtonManager = require( 'src.ui.ButtonManager' );
local Button = require( 'src.ui.Button' );
local InputManager = require( 'lib.InputManager' );
local PaletteSwitcher = require( 'lib.colswitcher.PaletteSwitcher' );
local ScreenScaler = require( 'lib.ScreenScaler' );

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Modal = {};

-- ------------------------------------------------
-- Load Resources
-- ------------------------------------------------

local images = {};

ResourceManager.register(Modal);

function Modal.loadImages()
    images['yes'] = ResourceManager.loadImage('res/img/ui/yes.png');
    images['no'] = ResourceManager.loadImage('res/img/ui/no.png');
    images['sure'] = ResourceManager.loadImage('res/img/ui/sure.png');
end


-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Modal.new()
    local self = Screen.new();

    local x, y, w, h;

    local tConfirm;
    local tDecline;
    local buttons;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function confirm()
        tConfirm();
    end

    local function decline()
        if tDecline then
            tDecline();
        end
    end

    local function handleInput()
        -- Allows cycling through the menu entries by keyboard.
        if InputManager.hasCommand('RIGHT') then
            buttons:next();
        elseif InputManager.hasCommand('LEFT') then
            buttons:prev();
        end

        -- Press the button below the mouse cursor.
        if InputManager.hasCommand('SELECT') then
            buttons:press();
        end

        -- Exit the game.
        if InputManager.hasCommand('BACK') then
            decline();
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:init( ntConfirm, ntDecline )
        tConfirm = ntConfirm;
        tDecline = ntDecline;

        h = 150;
        w = 250;
        x = 640 * 0.5 - w * 0.5;
        y = 480 * 0.5 - h * 0.5;

        buttons = ButtonManager.new();
        buttons:register( Button.new( images['yes'], x + 30,           y + h * 0.5, 3, 3, confirm ));
        buttons:register( Button.new( images['no'],  x + w * 0.5 + 30, y + h * 0.5, 3, 3, decline ));
        buttons:select(2);
    end

    function self:update(dt)
        -- Update buttons.
        handleInput();
        buttons:update(dt);
    end

    function self:draw()
        PaletteSwitcher.set();
        ScreenScaler.push();

        love.graphics.setColor(215, 232, 148);
        love.graphics.rectangle( 'fill', x, y, w, h );
        love.graphics.setColor(32, 70, 49);
        love.graphics.setLineWidth(4);
        love.graphics.rectangle('line', x, y, w, h);
        love.graphics.setColor(255, 255, 255);
        love.graphics.draw(images['sure'], x + (w * 0.5) - 72, y + 10, 0, 3, 3);

        buttons:draw();

        ScreenScaler.pop();
        PaletteSwitcher.unset();
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Modal;

--==================================================================================================
-- Created 10.11.14 - 12:35                                                                        =
--==================================================================================================
