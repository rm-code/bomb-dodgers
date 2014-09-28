local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local LevelOutro = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function LevelOutro.new(level, scores)
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
        if scores[1] then
            love.graphics.print('Round 1: ' .. scores[1], 20, 80);
        end
        if scores[2] then
            love.graphics.print('Round 2: ' .. scores[2], 20, 100);
        end
        if scores[3] then
            love.graphics.print('Round 3: ' .. scores[3], 20, 120);
        end
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