local Bomb = require('src/game/objects/Bomb');
local Config = require('src/Config');
local InputManager = require('lib/InputManager');

local Player = {};

function Player.new()
    local self = {};

    local x, y;
    local grid;

    local function move(dx, dy)
        if grid[x + dx][y + dy]:isPassable() then
            x = x + dx;
            y = y + dy;
        elseif grid[x + dx][y + dy]:getContentType() == 'bomb' then
            grid[x + dx][y + dy]:signal('kickbomb', dx, dy);
        end
    end

    local function plantBomb(x, y)
        local bomb = Bomb.new();
        bomb:init(x, y, 2, 2);
        grid[x][y]:addContent(bomb);
    end

    function self:init(ngrid, nx, ny)
        grid = ngrid;
        x, y = nx, ny;
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
            plantBomb(x, y);
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
-- Created 24.07.14 - 22:06                                                                        =
--==================================================================================================