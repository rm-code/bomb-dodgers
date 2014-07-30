local Bomb = require('src/game/objects/Bomb');
local Config = require('src/Config');
local InputManager = require('lib/InputManager');

local img = love.graphics.newImage('res/img/dodger.png');

local Player = {};

function Player.new()
    local self = {};

    local x, y;
    local grid;
    local blastStrength = 1;
    local bombCapacity = 1;
    local liveBombs = 0;

    local function move(dx, dy)
        if grid[x + dx][y + dy]:getContentType() == 'blastboost' then
            x = x + dx;
            y = y + dy;
            blastStrength = blastStrength + 1;
            grid[x][y]:removeContent();
        elseif grid[x + dx][y + dy]:getContentType() == 'carryboost' then
            x = x + dx;
            y = y + dy;
            bombCapacity = bombCapacity + 1;
            grid[x][y]:removeContent();
        elseif grid[x + dx][y + dy]:isPassable() then
            x = x + dx;
            y = y + dy;
        elseif grid[x + dx][y + dy]:getContentType() == 'bomb' then
            local dir;
            if dx < 0 then
                dir = 'west';
            elseif dx > 0 then
                dir = 'east';
            elseif dy < 0 then
                dir = 'north';
            elseif dy > 0 then
                dir = 'south';
            end
            grid[x + dx][y + dy]:signal({ name = 'kickbomb', direction = dir });
        end
    end

    local function plantBomb(x, y)
        if liveBombs < bombCapacity then
            local bomb = Bomb.new();
            bomb:init(2, blastStrength);
            bomb:setPlayer(self);
            grid[x][y]:addContent(bomb);
            liveBombs = liveBombs + 1;
            return true;
        else
            return false;
        end
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

    function self:removeBomb()
        liveBombs = liveBombs - 1;
    end

    function self:draw()
        love.graphics.draw(img, x * Config.tileSize, y * Config.tileSize);
        love.graphics.print('Bombs: ' .. liveBombs, 800, 20);
        love.graphics.print('Cap: ' .. bombCapacity, 800, 40);
        love.graphics.print('Blast: ' .. blastStrength, 800, 60);
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