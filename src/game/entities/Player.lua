local Config = require('src/Config');
local Entity = require('src/game/entities/Entity');
local InputManager = require('lib/InputManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Player = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local img = love.graphics.newImage('res/img/dodger.png');

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Player.new(arena, x, y)
    local self = Entity.new(arena, x, y);

    local north, south, east, west;
    north, south, east, west = self:getAdjacentTiles(self:getX(), self:getY());

    local function handleInput()
        if InputManager.hasCommand('UP') then
            self:move('north');
        elseif InputManager.hasCommand('DOWN') then
            self:move('south');
        end

        if InputManager.hasCommand('LEFT') then
            self:move('west');
        elseif InputManager.hasCommand('RIGHT') then
            self:move('east');
        end

        if InputManager.hasCommand('BOMB') then
            self:plantBomb(self.x, self.y);
        end
    end

    local delay = 0;
    function self:update(dt)
        north, south, east, west = self:getAdjacentTiles(self:getX(), self:getY());

        delay = delay + dt;
        handleInput();

        if delay > 0.2 then
            delay = 0;
        end

        if self:getTile():getContentType() == 'explosion' then
            self:kill();
        end
    end

    function self:draw()
        love.graphics.draw(img, self:getX() * Config.tileSize, self:getY() * Config.tileSize);

        love.graphics.setColor(0, 0, 0);
        if north then
            if not north:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', north:getX() * 32, north:getY() * 32, 32, 32);
            love.graphics.setColor(0, 0, 0);
        end

        if south then
            if not south:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', south:getX() * 32, south:getY() * 32, 32, 32);
            love.graphics.setColor(0, 0, 0);
        end

        if east then
            if not east:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', east:getX() * 32, east:getY() * 32, 32, 32);
            love.graphics.setColor(0, 0, 0);
        end

        if west then
            if not west:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', west:getX() * 32, west:getY() * 32, 32, 32);
            love.graphics.setColor(255, 255, 255);
        end

        love.graphics.print('Bombs: ' .. self:getLivingBombs(), 800, 20);
        love.graphics.print('Cap: ' .. self:getBombCapacity(), 800, 40);
        love.graphics.print('Blast: ' .. self:getBlastRadius(), 800, 60);
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Player; --==================================================================================================
-- Created 08.08.14 - 12:29                                                                        =
--==================================================================================================