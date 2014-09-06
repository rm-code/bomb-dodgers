local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local PlayerManager = require('src/entities/PlayerManager');
local InputManager = require('lib/InputManager');
local AniMAL = require('lib/AniMAL');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Player = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local anim_idleN = love.graphics.newImage('res/img/player/idle_north.png');
local anim_idleS = love.graphics.newImage('res/img/player/idle_south.png');
local anim_walkS = love.graphics.newImage('res/img/player/walk_south.png');
local anim_walkN = love.graphics.newImage('res/img/player/walk_north.png');
local anim_walkW = love.graphics.newImage('res/img/player/walk_west.png');
local anim_walkE = love.graphics.newImage('res/img/player/walk_east.png');

local anim = {
    idleN = AniMAL.new(anim_idleN, TILESIZE, TILESIZE, 0.2);
    idleS = AniMAL.new(anim_idleS, TILESIZE, TILESIZE, 0.2);
    walkN = AniMAL.new(anim_walkN, TILESIZE, TILESIZE, 0.2);
    walkS = AniMAL.new(anim_walkS, TILESIZE, TILESIZE, 0.2);
    walkE = AniMAL.new(anim_walkE, TILESIZE, TILESIZE, 0.2);
    walkW = AniMAL.new(anim_walkW, TILESIZE, TILESIZE, 0.2);
}

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Player.new(arena, x, y)
    local self = Entity.new(arena, x, y, anim);

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
            self:move();
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
        self:updateAnimation(dt);
    end

    function self:draw()
        self:drawAnimation();
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