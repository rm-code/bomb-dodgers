--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local AniMAL = {};

function AniMAL.new(img, w, h, speed)
    local self = {};

    local spritesheet = img;
    local width = w;
    local height = h;
    local speed = speed;
    local timer = 0;
    local totalFrames = spritesheet:getWidth() / width;
    local frames = {};
    local curFrame = 1;

    for i = 1, totalFrames do
        frames[i] = love.graphics.newQuad((i - 1) * width, 0, width, height, spritesheet:getDimensions());
    end

    function self:draw(x, y)
        love.graphics.draw(spritesheet, frames[curFrame], x, y);
    end

    function self:update(dt)
        timer = timer + dt;
        if timer >= speed then
            timer = 0;
            curFrame = curFrame == #frames and 1 or curFrame + 1;
        end
    end

    return self;
end

return AniMAL;

--==================================================================================================
-- Created 06.09.14 - 16:55                                                                        =
--==================================================================================================