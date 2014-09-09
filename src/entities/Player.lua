--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local PlayerManager = require('src/entities/PlayerManager');
local InputManager = require('lib/InputManager');
local AniMAL = require('lib/AniMAL');
local ResourceManager = require('lib/ResourceManager');

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
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Player);

---
-- Load images.
--
function Player.loadImages()
    images['idleN'] = ResourceManager.loadImage('res/img/player/idle_north.png');
    images['idleS'] = ResourceManager.loadImage('res/img/player/idle_south.png');
    images['walkN'] = ResourceManager.loadImage('res/img/player/walk_north.png');
    images['walkS'] = ResourceManager.loadImage('res/img/player/walk_south.png');
    images['walkE'] = ResourceManager.loadImage('res/img/player/walk_east.png');
    images['walkW'] = ResourceManager.loadImage('res/img/player/walk_west.png');

    images['anims'] = {
        idleN = AniMAL.new(images['idleN'], TILESIZE, TILESIZE, 0.2);
        idleS = AniMAL.new(images['idleS'], TILESIZE, TILESIZE, 0.2);
        walkN = AniMAL.new(images['walkN'], TILESIZE, TILESIZE, 0.2);
        walkS = AniMAL.new(images['walkS'], TILESIZE, TILESIZE, 0.2);
        walkE = AniMAL.new(images['walkE'], TILESIZE, TILESIZE, 0.2);
        walkW = AniMAL.new(images['walkW'], TILESIZE, TILESIZE, 0.2);
    };
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Player.new(arena, x, y)
    local self = Entity.new(arena, x, y, images.anims);

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

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Player; --==================================================================================================
-- Created 08.08.14 - 12:29                                                                        =
--==================================================================================================