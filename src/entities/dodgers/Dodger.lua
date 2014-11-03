--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 Robert Machmer                                             --
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

local Constants = require('src/Constants');
local Entity = require('src/entities/Entity');
local NpcManager = require('src/entities/dodgers/NpcManager');
local PlayerManager = require('src/entities/dodgers/PlayerManager');
local ResourceManager = require('lib/ResourceManager');
local SoundManager = require('lib/SoundManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Dodger = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};
local sounds = {};

-- Register module with resource manager.
ResourceManager.register(Dodger);

---
-- Load images.
--
function Dodger.loadImages()
    images['bomb_anim'] = ResourceManager.loadImage('res/img/content/bomb_animation.png');
end

function Dodger.loadSounds()
    sounds['plant'] = ResourceManager.loadSound('res/snd/plant.ogg');
    sounds['plant']:setVolume(0.5);
    sounds['plant']:setRolloff(0.02);
    sounds['upgrade'] = ResourceManager.loadSound('res/snd/upgrade.ogg');
    sounds['upgrade']:setVolume(0.5);
    sounds['upgrade']:setRolloff(0.02);
end

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Dodger.new(arena, x, y, animations)
    local self = Entity.new(arena, x, y, animations);

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local liveBombs = 0; -- The amount of bombs currently on the field.
    local bombCapacity = 1; -- The total amount of bombs the player can carry.
    local blastRadius = 2; -- The blast radius of a bomb.

    local upgrades = {};
    upgrades['fireup'] = {};
    upgrades['bombup'] = {};
    upgrades['bombdown'] = {};
    upgrades['snail'] = {};

    local normalSpeed = 150;
    local slowSpeed = 50;

    local tmpCap, tmpRadius; -- Variables to temporarily store the bomb's capacity and radius.

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    ---
    -- Increases the blast radius of each bomb.
    --
    function upgrades.fireup.activate()
        if not upgrades.snail.active then
            blastRadius = blastRadius + 1;
        else
            tmpRadius = tmpRadius + 1;
        end
    end

    ---
    -- Increases the bomb carry capacity of the entity.
    --
    function upgrades.bombup.activate()
        if not upgrades.snail.active then
            bombCapacity = bombCapacity + 1;
        else
            tmpCap = tmpCap + 1;
        end
    end

    ---
    -- Prevents entity from planting bombs.
    --
    function upgrades.bombdown.activate()
        upgrades.bombdown.active = true;
        upgrades.bombdown.counter = 5;
    end

    ---
    -- Restores player's ability to plant bombs.
    --
    function upgrades.bombdown.deactivate()
        upgrades.bombdown.active = false;
        upgrades.bombdown.counter = nil;
    end

    ---
    -- Slows down the player and reduces his carry capacity and blast
    -- radius to a minimum.
    --
    function upgrades.snail.activate()
        upgrades.snail.active = true;
        upgrades.snail.counter = 5;
        tmpCap = bombCapacity;
        bombCapacity = 1;
        tmpRadius = blastRadius;
        blastRadius = 2;
        self:setSpeed(slowSpeed);
    end

    ---
    -- Restores the players original speed, bomb capacity and blast radius.
    --
    function upgrades.snail.deactivate()
        upgrades.snail.active = false;
        upgrades.snail.counter = nil;
        bombCapacity = tmpCap;
        blastRadius = tmpRadius;
        self:setSpeed(normalSpeed);
    end

    ---
    -- Takes an upgrade and decides what should happen to the entity
    -- based on the type of upgrade.
    -- @param x - The x position from which to pick the upgrade.
    -- @param y - The y position from which to pick the upgrade.
    --
    function self:takeUpgrade(x, y)
        local target = arena:getTile(x, y);
        if target:getContentType() == CONTENT.UPGRADE then
            local upgrade = target:getContent();
            if upgrade:getUpgradeType() == 'fireup' then
                upgrades.fireup.activate();
            elseif upgrade:getUpgradeType() == 'bombup' then
                upgrades.bombup.activate();
            elseif upgrade:getUpgradeType() == 'bombdown' then
                upgrades.bombdown.activate();
            elseif upgrade:getUpgradeType() == 'snail' and not upgrades.snail.active then
                upgrades.snail.activate();
            end
            SoundManager.play(sounds['upgrade'], 'sfx', x * Constants.TILESIZE, y * Constants.TILESIZE, 0);
            upgrade:remove();
        end
    end

    ---
    -- Upgrades the counter of each up / downgrade and deactivates
    -- it, if the counter has reached zero.
    -- @param dt
    --
    function self:updateUpgrades(dt)
        for name, upgrade in pairs(upgrades) do
            if upgrade.active then
                local player = PlayerManager.getClosest(self:getX(), self:getY());
                if player and not player:isActive(name)
                        and player ~= self
                        and player:getX() == self:getX()
                        and player:getY() == self:getY() then
                    player:infect(name);
                end

                local npc = NpcManager.getClosest(self:getX(), self:getY());
                if npc and npc.isActive and not npc:isActive(name)
                        and npc ~= self
                        and npc:getX() == self:getX()
                        and npc:getY() == self:getY() then
                    npc:infect(name);
                end

                if upgrade.counter and upgrade.counter > 0 then
                    upgrades[name].counter = upgrades[name].counter - dt;
                else
                    upgrades[name].deactivate();
                end
            end
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:plantBomb()
        if liveBombs < bombCapacity and not upgrades.bombdown.active then
            if self:getTile():isPassable() then
                self:getTile():plantBomb(blastRadius, self);
                liveBombs = liveBombs + 1;
                SoundManager.play(sounds['plant'], 'sfx', self:getRealX(), self:getRealY(), 0);
            end
        end
    end

    function self:removeBomb()
        liveBombs = liveBombs - 1;
    end

    function self:infect(upgrade)
        upgrades[upgrade].activate();
    end

    function self:reset()
        liveBombs = 0;
        bombCapacity = 1;
        blastRadius = 2;
        for name, upgrade in pairs(upgrades) do
            upgrades[name].active = false;
            upgrades[name].counter = nil;
        end
        self:setSpeed(normalSpeed);
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getLivingBombs()
        return liveBombs;
    end

    function self:getBombCapacity()
        return bombCapacity;
    end

    function self:getBlastRadius()
        return blastRadius;
    end

    function self:isActive(upgrade)
        return upgrades[upgrade].active;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Dodger;

--==================================================================================================
-- Created 31.07.14 - 00:27                                                                        =
--==================================================================================================