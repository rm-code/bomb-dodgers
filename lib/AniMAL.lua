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
    local sx, sy = 1, 1;
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
        love.graphics.draw(spritesheet, frames[curFrame], x, y, 0, sx, sy);
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

    function self:setScale(nsx, nsy)
        sx, sy = nsx, nsy;
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