local Bomb = require('src/game/Bomb');
local BombHandler = require('src/game/BombHandler');

local Player = {};

function Player.new()
    local self = {};

    local id;
    local x = 2;
    local y = 2;

    local arena;

    local tileSize = 32;

    local function move(dx, dy)
        if not arena:hasCollision(x + dx, y + dy) then
            x = x + dx;
            y = y + dy;
        end
    end

    local function plantBomb(x, y)
        BombHandler.addBomb(id, Bomb.new(x, y, 20, 2));
    end

    function self:init(narena)
        id = BombHandler.registerPlayer();
        arena = narena;
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
        love.graphics.rectangle('fill', x * tileSize, y * tileSize, tileSize, tileSize);
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
            plantBomb(x, y, 20, 2);
        end
    end

    function self:getX()
        return x;
    end

    function self:getY()
        return y;
    end

    return self;
end

return Player;

--==================================================================================================
-- Created 14.07.14 - 17:34                                                                        =
--==================================================================================================