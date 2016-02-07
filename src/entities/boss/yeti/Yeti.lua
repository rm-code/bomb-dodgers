--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 - 2016 Robert Machmer                                      --
--                                                                               --
-- This software is provided 'as-is', without any express or implied             --
-- warranty. In no event will the authors be held liable for any damages         --
-- arising from the use of this software.                                        --
--                                                                               --
-- Permission is granted to anyone to use this software for any purpose,         --
-- including commercial applications, and to alter it and redistribute it        --
-- freely, subject to the following restrictions:                                --
--                                                                               --
--  1. The origin of this software must not be misrepresented; you must not      --
--      claim that you wrote the original software. If you use this software     --
--      in a product, an acknowledgment in the product documentation would be    --
--      appreciated but is not required.                                         --
--  2. Altered source versions must be plainly marked as such, and must not be   --
--      misrepresented as being the original software.                           --
--  3. This notice may not be removed or altered from any source distribution.   --
--                                                                               --
--===============================================================================--

local Constants = require( 'src.Constants' );
local Entity = require( 'src.entities.Entity' );
local StateManager = require( 'src.entities.StateManager' );
local ResourceManager = require( 'lib.ResourceManager' );
local PlayerManager = require( 'src.entities.dodgers.PlayerManager' );
local AniMAL = require( 'lib.AniMAL' );
local Missile = require( 'src.entities.boss.yeti.Missile' );
local Move = require( 'src.entities.boss.yeti.Move' );
local Hurt = require( 'src.entities.boss.Hurt' );
local SoundManager = require( 'lib.SoundManager' );

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Yeti = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local MAX_LIVES = 3;
local SPEED = 105;

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};
local sounds = {};

-- Register module with resource manager.
ResourceManager.register(Yeti);

---
-- Load images.
--
function Yeti.loadImages()
    images['boss'] = ResourceManager.loadImage('res/img/boss/yeti.png');
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

function Yeti.loadSounds()
    sounds['explosion'] = ResourceManager.loadSound('res/snd/explosion.ogg');
    sounds['explosion']:setRolloff(0.02);
    sounds['hurt'] = ResourceManager.loadSound('res/snd/bosshurt.wav');
    sounds['hurt']:setRolloff(0.02);
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Yeti.new(arena, x, y)
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

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:shoot()
        missiles[1] = Missile.new(arena, 'n', self:getX(), self:getY());
        missiles[2] = Missile.new(arena, 'e', self:getX(), self:getY());
        missiles[3] = Missile.new(arena, 's', self:getX(), self:getY());
        missiles[4] = Missile.new(arena, 'w', self:getX(), self:getY());
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

            for i = 1, #missiles do
                missiles[i]:setOrigin(self:getRealX(), self:getRealY());
                missiles[i]:update(dt);
            end
        end
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

return Yeti;

--==================================================================================================
-- Created 09.10.14 - 13:44                                                                        =
--==================================================================================================
