--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local Missile = require('src/entities/boss/Missile');
local Minion = require('src/entities/boss/Minion');
local StateManager = require('src/entities/states/StateManager');
local Move = require('src/entities/boss/states/Move');
local Hurt = require('src/entities/boss/states/Hurt');
local PlayerManager = require('src/entities/PlayerManager');
local ResourceManager = require('lib/ResourceManager');
local AniMAL = require('lib/AniMAL');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Boss = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local MAX_LIVES = 3;
local SPEED = 125;

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Boss);

---
-- Load images.
--
function Boss.loadImages()
    images['boss'] = ResourceManager.loadImage('res/img/boss/boss.png');
    images['smoke'] = ResourceManager.loadImage('res/img/boss/smoke.png');
    images['anims'] = {
        idleS = AniMAL.new(images['boss'], 96, 96, 0.2);
        idleN = AniMAL.new(images['boss'], 96, 96, 0.2);
        walkN = AniMAL.new(images['boss'], 96, 96, 0.2);
        walkS = AniMAL.new(images['boss'], 96, 96, 0.2);
        walkE = AniMAL.new(images['boss'], 96, 96, 0.2);
        walkW = AniMAL.new(images['boss'], 96, 96, 0.2);
    }
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Boss.new(arena, x, y)
    local self = Entity.new(arena, x, y, images.anims);

    local fsm = StateManager.new();

    local lives = MAX_LIVES;
    local invincible = false;
    local deathTimer = 5;
    local clouds = {};

    local states = {};
    states.move = Move.new(fsm, self);
    states.hurt = Hurt.new(fsm, self);

    fsm:initStates(states);
    fsm:switch('move');

    self:setIgnoreBombs(true);
    self:setSpeed(SPEED);

    local missiles = {};
    local minions = {};

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function randomPosition(pos)
        return love.math.random(pos - 60, pos + 60);
    end

    local function updateSmoke(dt)
        for i = 1, 5 do
            if not clouds[i] then
                clouds[i] = {};
                clouds[i].anim = AniMAL.new(images['smoke'], 32, 32, 0.2, 2);
                clouds[i].x = randomPosition(self:getRealX());
                clouds[i].y = randomPosition(self:getRealY());
            elseif clouds[i].anim:isDone() then
                clouds[i].x = randomPosition(self:getRealX());
                clouds[i].y = randomPosition(self:getRealY());
                clouds[i].anim:rewind();
            else
                clouds[i].anim:update(dt);
            end
        end
    end

    local function damage()
        for x = -1, 1 do
            for y = -1, 1 do
                if arena:getTile(self:getX() + x, self:getY() + y):getContentType() == Constants.CONTENT.EXPLOSION then
                    lives = lives - 1;
                    fsm:switch('hurt');
                end
            end
        end
    end

    local function drawEntities(entities)
        for i = 1, #entities do
            if not entities[i]:isDead() then
                entities[i]:draw();
            end
        end
    end

    local function updateEntities(dt, entities)
        for i = 1, #entities do
            if not entities[i]:isDead() then
                entities[i]:update(dt);
            end
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:shoot()
        missiles[1] = Missile.new(arena, 'n', self:getX(), self:getY());
        missiles[2] = Missile.new(arena, 's', self:getX(), self:getY());
        missiles[3] = Missile.new(arena, 'e', self:getX(), self:getY());
        missiles[4] = Missile.new(arena, 'w', self:getX(), self:getY());
    end

    function self:releaseMinions()
        minions[1] = Minion.new(arena, self:getX(), self:getY());
        minions[2] = Minion.new(arena, self:getX(), self:getY());
        minions[3] = Minion.new(arena, self:getX(), self:getY());
        minions[4] = Minion.new(arena, self:getX(), self:getY());
    end

    function self:update(dt)
        if not invincible then
            damage();
        end

        if lives <= 0 then
            deathTimer = deathTimer - dt;
            updateSmoke(dt);

            if deathTimer <= 0 then
                self:setDead(true);
                return;
            end
        else
            fsm:update(dt);

            -- Check for collision with player.
            local player = PlayerManager.getClosest(self:getX(), self:getY());
            if player:getX() >= self:getX() - 1 and player:getX() <= self:getX() + 1
                    and player:getY() >= self:getY() - 1 and player:getY() <= self:getY() + 1 then
                player:setDead(true);
                return;
            end

            updateEntities(dt, missiles);
            updateEntities(dt, minions);
        end
    end

    function self:draw()
        drawEntities(missiles);
        drawEntities(minions);

        self:drawAnimation(-32, -32);

        if lives <= 0 then
            for i = 1, #clouds do
                clouds[i].anim:draw(clouds[i].x, clouds[i].y);
            end
        end
    end

    function self:reset()
        lives = MAX_LIVES;
        invincible = false;

        fsm:switch('move');

        self:setAlpha(255);
        self:setIgnoreBombs(true);
        self:setSpeed(SPEED);

        for i = 1, 4 do
            missiles[i] = nil;
            minions[i] = nil;
        end
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getMinionCount()
        local cnt = 0;
        for i = 1, #minions do
            if not minions[i]:isDead() then
                cnt = cnt + 1;
            end
        end
        return cnt;
    end

    function self:getMissileCount()
        local cnt = 0;
        for i = 1, #missiles do
            if not missiles[i]:isDead() then
                cnt = cnt + 1;
            end
        end
        return cnt;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setInvincible(ninv)
        invincible = ninv;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Boss;

--==================================================================================================
-- Created 25.09.14 - 10:10                                                                        =
--==================================================================================================