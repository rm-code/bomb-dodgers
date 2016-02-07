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
local SoundManager = require( 'lib.SoundManager' );

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local ButtonManager = {};

-- ------------------------------------------------
-- Load Resources
-- ------------------------------------------------

local sounds = {};

ResourceManager.register(ButtonManager);

function ButtonManager.loadSounds()
    sounds['select'] = ResourceManager.loadSound('res/snd/select.wav', 'static');
    sounds['select']:setRelative(true);
    sounds['beep'] = ResourceManager.loadSound('res/snd/beep.wav', 'static');
    sounds['beep']:setRelative(true);
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function ButtonManager.new()
    local self = {};

    local buttons = {};
    local currentButton = 1;

    function self:register(button)
        buttons[#buttons + 1] = button;
    end

    function self:draw()
        for i = 1, #buttons do
            buttons[i]:draw();
        end
    end

    function self:update(dt)
        for i = 1, #buttons do
            buttons[i]:update(dt);
        end
    end

    function self:press()
        SoundManager.play(sounds['select'], 'sfx', 0, 0, 0);
        buttons[currentButton]:press();
    end

    function self:select(no)
        if buttons[currentButton] ~= buttons[no] then
            buttons[currentButton]:setActive(false);
            SoundManager.play(sounds['beep'], 'sfx', 0, 0, 0);
            currentButton = no;
            buttons[currentButton]:setActive(true);
        else
            buttons[currentButton]:setActive(true);
        end
    end

    function self:next()
        SoundManager.play(sounds['beep'], 'sfx', 0, 0, 0);
        buttons[currentButton]:setActive(false);
        currentButton = currentButton == #buttons and 1 or currentButton + 1;
        buttons[currentButton]:setActive(true);
    end

    function self:prev()
        SoundManager.play(sounds['beep'], 'sfx', 0, 0, 0);
        buttons[currentButton]:setActive(false);
        currentButton = currentButton == 1 and #buttons or currentButton - 1;
        buttons[currentButton]:setActive(true);
    end

    return self;
end

return ButtonManager;

--==================================================================================================
-- Created 22.06.14 - 23:16                                                                        =
--==================================================================================================
