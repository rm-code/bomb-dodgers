--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local ResourceManager = require('lib/ResourceManager');

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
    sounds['beep'] = ResourceManager.loadSound('res/snd/beep.wav', 'static');
    sounds['select']:setRelative(true);
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
        sounds['select']:play();
        buttons[currentButton]:press();
    end

    function self:select(no)
        if buttons[currentButton] ~= buttons[no] then
            buttons[currentButton]:setActive(false);
            sounds['beep']:play();
            currentButton = no;
            buttons[currentButton]:setActive(true);
        else
            buttons[currentButton]:setActive(true);
        end
    end

    function self:next()
        sounds['beep']:play();
        buttons[currentButton]:setActive(false);
        currentButton = currentButton == #buttons and 1 or currentButton + 1;
        buttons[currentButton]:setActive(true);
    end

    function self:prev()
        sounds['beep']:play();
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