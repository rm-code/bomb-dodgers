local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local StateManager = require('src/entities/StateManager');
local ResourceManager = require('lib/ResourceManager');
local PlayerManager = require('src/entities/dodgers/PlayerManager');
local Missile = require('src/entities/boss/ant/Missile');
local AniMAL = require('lib/AniMAL');
local Move = require('src/entities/boss/ant/states/Move');
local Hurt = require('src/entities/boss/ant/states/Hurt');
local SoundManager = require('lib/SoundManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Ant = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local MAX_LIVES = 3;
local SPEED = 55;

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};
local sounds = {};

-- Register module with resource manager.
ResourceManager.register(Ant);

---
-- Load images.
--
function Ant.loadImages()
    images['boss'] = ResourceManager.loadImage('res/img/boss/ant.png');
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

function Ant.loadSounds()
    sounds['explosion'] = ResourceManager.loadSound('res/snd/explosion.ogg');
    sounds['explosion']:setRolloff(0.02);
    sounds['hurt'] = ResourceManager.loadSound('res/snd/bosshurt.wav');
    sounds['hurt']:setRolloff(0.02);
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Ant.new(arena, x, y)
    local self = Entity.new(arena, x, y, images.anims);

    local fsm = StateManager.new();
    local lives = MAX_LIVES;
    local invincible = false;
    local deathTimer = 5;
    local clouds = {};

    local states = {};
    states.move = Move.new(fsm, self);
    states.hurt = Hurt.new(fsm, self);

    self:setIgnoreBombs(true);
    self:setSpeed(SPEED);

    fsm:initStates(states);
    fsm:switch('move');

    local missiles = {};

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function randomPosition(pos)
        return love.math.random(pos - 60, pos + 60);
    end

    local function updateSmoke(dt)
        SoundManager.play(sounds['explosion'], 'sfx', self:getRealX(), self:getRealY(), 0);
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
                SoundManager.play(sounds['explosion'], 'sfx', clouds[i].x, clouds[i].y, 0);
            else
                clouds[i].anim:update(dt);
            end
        end
    end

    local function damage()
        for x = -1, 1 do
            for y = -1, 1 do
                if arena:getTile(self:getX() + x, self:getY() + y):getContentType() == Constants.CONTENT.EXPLOSION then
                    SoundManager.play(sounds['hurt'], 'sfx', self:getRealX(), self:getRealY(), 0);
                    lives = lives - 1;
                    fsm:switch('hurt');
                    return;
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
        print('pew');
        missiles[1] = Missile.new(arena, 'ne', self:getX(), self:getY());
        missiles[2] = Missile.new(arena, 'nw', self:getX(), self:getY());
        missiles[3] = Missile.new(arena, 'se', self:getX(), self:getY());
        missiles[4] = Missile.new(arena, 'sw', self:getX(), self:getY());
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
        end
    end

    function self:move(dt, dirX, dirY)
        if self:getX() <= 2 then
            dirX = love.math.random(0, 2);
        elseif self:getX() >= 20 then
            dirX = -love.math.random(0, 2);
        end
        if self:getY() <= 2 then
            dirY = love.math.random(0, 2);
        elseif self:getY() >= 20 then
            dirY = -love.math.random(0, 2);
        end

        self:setRealX(self:getRealX() + (dirX * self:getSpeed() * dt));
        self:setRealY(self:getRealY() + (dirY * self:getSpeed() * dt));

        return dirX, dirY;
    end

    function self:draw()
        drawEntities(missiles);
        self:drawAnimation(-32, -32);
    end

    function self:reset()
        lives = MAX_LIVES;
        invincible = false;

        fsm:switch('move');

        self:setAlpha(255);
        self:setIgnoreBombs(true);
        self:setSpeed(SPEED);
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

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

return Ant;

--==================================================================================================
-- Created 09.10.14 - 13:44                                                                        =
--==================================================================================================