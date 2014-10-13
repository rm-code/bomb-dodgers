local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local StateManager = require('src/entities/StateManager');
local ResourceManager = require('lib/ResourceManager');
local PlayerManager = require('src/entities/dodgers/PlayerManager');
local AniMAL = require('lib/AniMAL');
local Move = require('src/entities/boss/mummy/states/Move');
local Hurt = require('src/entities/boss/mummy/states/Hurt');
local SpawnTentacles = require('src/entities/boss/mummy/states/SpawnTentacles');
local Charge = require('src/entities/boss/mummy/states/Charge');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Mummy = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local MAX_LIVES = 3;
local SPEED = 85;

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Mummy);

---
-- Load images.
--
function Mummy.loadImages()
    images['boss'] = ResourceManager.loadImage('res/img/boss/mummy.png');
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

function Mummy.new(arena, x, y)
    local self = Entity.new(arena, x, y, images.anims);

    local fsm = StateManager.new();
    local lives = MAX_LIVES;
    local invincible = false;
    local deathTimer = 5;
    local clouds = {};

    local states = {};
    states.move = Move.new(fsm, self);
    states.hurt = Hurt.new(fsm, self);
    states.spawntentacles = SpawnTentacles.new(fsm, self, arena);
    states.charge = Charge.new(fsm, self, arena);

    self:setIgnoreBombs(true);
    self:setSpeed(SPEED);

    fsm:initStates(states);
    fsm:switch('move');

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
                    return;
                end
            end
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

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
        end
    end

    function self:draw()
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

return Mummy;

--==================================================================================================
-- Created 09.10.14 - 13:44                                                                        =
--==================================================================================================