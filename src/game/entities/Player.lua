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

    local adjTiles = self:getAdjacentTiles(self:getX(), self:getY());

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

    function self:update(dt)
        adjTiles = self:getAdjacentTiles(self:getX(), self:getY());

        handleInput();

        if self:getTile():getContentType() == 'explosion' then
            self:kill();
        end
    end

    function self:draw()
        love.graphics.draw(img, self:getX() * Config.tileSize, self:getY() * Config.tileSize);

        love.graphics.setColor(0, 0, 0);
        for dir, tile in pairs(adjTiles) do
            if not tile:isPassable() then
                love.graphics.setColor(255, 0, 0);
            end
            love.graphics.rectangle('line', tile:getX() * 32, tile:getY() * 32, 32, 32);
            love.graphics.setColor(0, 0, 0);
        end
        love.graphics.setColor(255, 255, 255);

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