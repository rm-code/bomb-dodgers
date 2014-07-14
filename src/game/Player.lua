local Bomb = require('src/game/Bomb');
local BombHandler = require('src/game/BombHandler');

local Player = {};

function Player.new(grid)
    local self = {};

    local id;
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

    local function plantBomb(x, y)
        BombHandler.addBomb(id, Bomb.new(x, y, 20, 2));
    end

    function self:init()
        id = BombHandler.registerPlayer();
    end

    function self:update(dt)
        --        local rnd = love.math.random(1, 4);
        --        if rnd == 1 then
        --            move(0, -1);
        --        elseif rnd == 2 then
        --            move(0, 1);
        --        elseif rnd == 3 then
        --            move(-1, 0);
        --        else
        --            move(1, 0);
        --        end
    end

    function self:draw()
        love.graphics.setColor(0, 255, 0);
        love.graphics.rectangle('fill', posX * tileSize, posY * tileSize, tileSize, tileSize);
        love.graphics.setColor(255, 255, 255);
    end

    function self:keypressed(key)
        if key == 'up' then
            move(0, -1);
        elseif key == 'down' then
            move(0, 1);
        end

        if key == 'left' then
            move(-1, 0);
        elseif key == 'right' then
            move(1, 0);
        end

        if key == ' ' then
            plantBomb(posX, posY, 20, 2);
        end
    end

    return self;
end

return Player;

--==================================================================================================
-- Created 14.07.14 - 17:34                                                                        =
--==================================================================================================