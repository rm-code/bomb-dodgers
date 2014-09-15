local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local LevelOutro = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function LevelOutro.new(level)
    local self = Screen.new();

    local timer = 1;

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            ScreenManager.pop();
        end
    end

    function self:draw()
        love.graphics.print('Time: ' .. timer, 20, 20);
        love.graphics.print('Loading: ' .. level, 20, 40);
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return LevelOutro;

--==================================================================================================
-- Created 15.09.14 - 12:52                                                                        =
--==================================================================================================