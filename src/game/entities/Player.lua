local Constants = require('src/Constants');
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
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Player.new(arena, x, y)
    local self = Entity.new(arena, x, y);

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

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

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(dt)
        handleInput();

        if self:getTile():getContentType() == CONTENT.EXPLOSION then
            self:kill();
        end
    end

    function self:draw()
        love.graphics.draw(img, self:getX() * TILESIZE, self:getY() * TILESIZE);

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