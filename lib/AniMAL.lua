--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local AniMAL = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local mode = {
    'loop',
    'single',
}

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function AniMAL.new(img, w, h, speed, modeNo)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local spritesheet = img;
    local width = w;
    local height = h;
    local speed = speed;
    local timer = 0;
    local totalFrames = spritesheet:getWidth() / width;
    local frames = {};
    local curFrame = 1;
    local playMode = mode[modeNo or 1];
    local done;

    for i = 1, totalFrames do
        frames[i] = love.graphics.newQuad((i - 1) * width, 0, width, height, spritesheet:getDimensions());
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    ---
    -- Draws the current quad of the selected spritesheet.
    -- @param x - The x position to draw the quad at.
    -- @param y - The y position to draw the quad at.
    --
    function self:draw(x, y)
        love.graphics.draw(spritesheet, frames[curFrame], x, y);
    end

    ---
    -- Loops through all frames of the animation.
    -- @param dt
    --
    function self:update(dt)
        timer = timer + dt;
        if timer >= speed and not done then
            timer = 0;
            if curFrame == #frames and playMode == 'single' then
                done = true;
                return;
            end
            curFrame = curFrame == #frames and 1 or curFrame + 1;
        end
    end

    function self:rewind()
        curFrame = 1;
        done = false;
    end

    function self:isDone()
        return done;
    end

    function self:setDone(ndone)
        done = ndone;
    end

    -- ------------------------------------------------
    -- Return Object
    -- ------------------------------------------------

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return AniMAL;

--==================================================================================================
-- Created 06.09.14 - 16:55                                                                        =
--==================================================================================================