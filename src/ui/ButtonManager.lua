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

local SOUNDS = {};

ResourceManager.register(ButtonManager);

function ButtonManager.loadSounds()
    SOUNDS['select'] = ResourceManager.loadSound('res/snd/select.wav', 'static');
    SOUNDS['beep'] = ResourceManager.loadSound('res/snd/beep.wav', 'static');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function ButtonManager.new()
    local self = {};

    local buttons = {};
    local curButton;
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
        SOUNDS['select']:play();
        curButton:press();
    end

    function self:select(no)
        if not curButton then
            curButton = buttons[no];
            curButton:setActive(true);
        elseif curButton ~= buttons[no] then
            curButton:setActive(false);
            SOUNDS['beep']:play();
            curButton = buttons[no];
            curButton:setActive(true);
        end
    end

    function self:next()
        SOUNDS['beep']:play();
        currentButton = currentButton == #buttons and 1 or currentButton + 1;
    end

    function self:prev()
        SOUNDS['beep']:play();
        currentButton = currentButton == 1 and #buttons or currentButton - 1;
    end

    return self;
end

return ButtonManager;

--==================================================================================================
-- Created 22.06.14 - 23:16                                                                        =
--==================================================================================================