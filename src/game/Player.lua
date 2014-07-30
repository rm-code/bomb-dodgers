local Bomb = require('src/game/objects/Bomb');
local Config = require('src/Config');
local InputManager = require('lib/InputManager');

local img = love.graphics.newImage('res/img/dodger.png');

local Player = {};

function Player.new()
    local self = {};

    local x, y;
    local arena;

    local tile;
    local north;
    local south;
    local west;
    local east;

    local blastStrength = 1;
    local bombCapacity = 1;
    local liveBombs = 0;

    local function move(direction)
        local target;

        if direction == 'north' then
            target = north;
        elseif direction == 'south' then
            target = south;
        elseif direction == 'west' then
            target = west;
        elseif direction == 'east' then
            target = east;
        end

        if target:getContentType() == 'blastboost' then
            x = target:getX();
            y = target:getY();
            blastStrength = blastStrength + 1;
            target:removeContent();
        elseif target:getContentType() == 'carryboost' then
            x = target:getX();
            y = target:getY();
            bombCapacity = bombCapacity + 1;
            target:removeContent();
        elseif target:isPassable() then
            x = target:getX();
            y = target:getY();
        elseif target:getContentType() == 'bomb' then
            target:signal({ name = 'kickbomb', direction = direction });
        end
    end

    local function plantBomb(x, y)
        if liveBombs < bombCapacity then
            local bomb = Bomb.new();
            bomb:init(2, blastStrength);
            bomb:setPlayer(self);
            tile:addContent(bomb);
            liveBombs = liveBombs + 1;
            return true;
        else
            return false;
        end
    end

    function self:init(narena, nx, ny)
        arena = narena;
        x, y = nx, ny;
        tile = arena:getTile(x, y);
        north = arena:getTile(x, y - 1);
        south = arena:getTile(x, y + 1);
        west = arena:getTile(x - 1, y);
        east = arena:getTile(x + 1, y);
    end

    local function handleInput(dt)
        -- Vertical movement.
        if InputManager.hasCommand('UP') then
            move('north');
        elseif InputManager.hasCommand('DOWN') then
            move('south');
        end

        if InputManager.hasCommand('LEFT') then
            move('west');

        elseif InputManager.hasCommand('RIGHT') then
            move('east');
        end

        if InputManager.hasCommand('BOMB') then
            plantBomb(x, y);
        end
    end

    function self:update(dt)
        tile = arena:getTile(x, y);
        north = arena:getTile(x, y - 1);
        south = arena:getTile(x, y + 1);
        west = arena:getTile(x - 1, y);
        east = arena:getTile(x + 1, y);

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