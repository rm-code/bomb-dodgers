local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local PlayerManager = require('src/entities/PlayerManager');
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

    local id;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function handleInput()
        if InputManager.hasCommand('UP') and InputManager.hasCommand('RIGHT') then
            self:move('n', 'e');
        elseif InputManager.hasCommand('UP') and InputManager.hasCommand('LEFT') then
            self:move('n', 'w');
        elseif InputManager.hasCommand('DOWN') and InputManager.hasCommand('RIGHT') then
            self:move('s', 'e');
        elseif InputManager.hasCommand('DOWN') and InputManager.hasCommand('LEFT') then
            self:move('s', 'w');
        elseif InputManager.hasCommand('UP') then
            self:move('n');
        elseif InputManager.hasCommand('DOWN') then
            self:move('s');
        elseif InputManager.hasCommand('RIGHT') then
            self:move('e');
        elseif InputManager.hasCommand('LEFT') then
            self:move('w');
        else
--            self:move('s', 'e');
        end

        if InputManager.hasCommand('BOMB') then
            self:plantBomb();
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:update(dt)
        handleInput();

        if self:getTile():getContentType() == CONTENT.EXPLOSION then
            self:kill();
            PlayerManager.remove(id);
        end

        self:updateCounters(dt);
    end

    function self:draw()
        love.graphics.setColor(255, 255, 255, self:getAlpha());
        love.graphics.draw(img, self:getRealX(), self:getRealY());
        love.graphics.setColor(255, 255, 255, 255);

        love.graphics.print('Bombs: ' .. self:getLivingBombs(), 800, 20);
        love.graphics.print('Cap: ' .. self:getBombCapacity(), 800, 40);
        love.graphics.print('Blast: ' .. self:getBlastRadius(), 800, 60);

        love.graphics.print('RealX: ' .. self:getRealX() .. ' RealY: ' .. self:getRealY(), 800, 100);
        love.graphics.print('GridX: ' .. self:getX() .. ' GridY: ' .. self:getY(), 800, 120);
    end

    function self:setId(nid)
        id = nid;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Player; --==================================================================================================
-- Created 08.08.14 - 12:29                                                                        =
--==================================================================================================