local Player = {};

function Player.new(grid)
    local self = {};

    local posX = 2;
    local posY = 2;

    local grid = grid;

    local tileSize = 32;

    local function move(dx, dy)
        local x = posX + dx or 0;
        local y = posY + dy or 0;

        if grid and grid[x] and grid[x][y] and grid[x][y] == 0 then
            posX = x;
            posY = y;
        end
    end

    function self:update(dt)
        if love.keyboard.isDown('up') then
            move(0, -1);
        elseif love.keyboard.isDown('down') then
            move(0, 1);
        end

        if love.keyboard.isDown('left') then
            move(-1, 0);
        elseif love.keyboard.isDown('right') then
            move(1, 0);
        end
    end

    function self:draw()
        love.graphics.setColor(255, 0, 0);
        love.graphics.rectangle('fill', posX * tileSize, posY * tileSize, tileSize, tileSize);
        love.graphics.setColor(255, 255, 255);
    end

    return self;
end

return Player;

--==================================================================================================
-- Created 14.07.14 - 17:34                                                                        =
--==================================================================================================