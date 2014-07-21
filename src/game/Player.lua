local Bomb = require('src/game/Bomb');
local BombHandler = require('src/game/BombHandler');
local Config = require('src/Config');
local InputManager = require('lib/InputManager');

local Player = {};

function Player.new()
    local self = {};

    local id;
    local x = 2;
    local y = 2;

    local arena;

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

    local function handleInput(dt)
        -- Vertical movement.
        if InputManager.hasCommand('UP') then
            move(0, -1);
        elseif InputManager.hasCommand('DOWN') then
            move(0, 1);
        end

        if InputManager.hasCommand('LEFT') then
            move(-1, 0);

        elseif InputManager.hasCommand('RIGHT') then
            move(1, 0);
        end

        if InputManager.hasCommand('BOMB') then
            plantBomb(x, y, 20, 2);
        end
    end

    function self:update(dt)
        handleInput(dt);
    end

    function self:draw()
        love.graphics.setColor(0, 255, 0);
        love.graphics.rectangle('fill', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
        love.graphics.setColor(255, 255, 255);
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