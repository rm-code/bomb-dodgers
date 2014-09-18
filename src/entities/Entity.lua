--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Math = require('lib/Math');
local Constants = require('src/Constants');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Entity = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Entity.new(arena, x, y, anim)
    local self = {};

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local id; -- The unique id which is used to store a reference to the entity.

    local arena = arena;
    local gridX = x;
    local gridY = y;
    local realX = gridX * Constants.TILESIZE;
    local realY = gridY * Constants.TILESIZE;

    local liveBombs = 0; -- The amount of bombs currently on the field.
    local bombCapacity = 1; -- The total amount of bombs the player can carry.
    local blastRadius = 2; -- The blast radius of a bomb.

    local dead = false;

    local upgrades = {};
    upgrades['fireup'] = {};
    upgrades['bombup'] = {};
    upgrades['bombdown'] = {};
    upgrades['snail'] = {};

    local alpha = 255; -- The current alpha of the entity.
    local pulse = 0; -- The pulse which will be used to create a pulsating effect.

    local prevMovementDir; -- The direction in which the player moved previously.

    local normalSpeed = 150; -- The speed to use when walking normally.
    local slowSpeed = 50; -- The speed to use when snail downgrade is active.
    local currentSpeed = normalSpeed;

    local lerpFactor = 0.2; -- The lerpFactor to use for the entity's movement.

    local tmpCap, tmpRadius; -- Variables to temporarily store the bomb's capacity and radius.

    local anim = anim; -- The list of animations from which to pick one.
    local curAnim = anim.idleS; -- The current animation.

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
        lerpFactor = 0.1;
        tmpCap = bombCapacity;
        bombCapacity = 1;
        tmpRadius = blastRadius;
        blastRadius = 2;
        currentSpeed = slowSpeed;
    end

    ---
    -- Restores the players original speed, bomb capacity and blast radius.
    --
    function upgrades.snail.deactivate()
        upgrades.snail.active = false;
        upgrades.snail.counter = nil;
        lerpFactor = 0.2;
        bombCapacity = tmpCap;
        blastRadius = tmpRadius;
        currentSpeed = normalSpeed;
    end

    ---
    -- Takes an upgrade and decides what should happen to the entity
    -- based on the type of upgrade.
    -- @param x - The x position from which to pick the upgrade.
    -- @param y - The y position from which to pick the upgrade.
    --
    local function takeUpgrade(x, y)
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
            upgrade:remove();
        end
    end

    ---
    -- Checks for collisions between the bounding box of the
    -- entity versus another given bounding box.
    -- @param x1
    -- @param y1
    -- @param x2
    -- @param y2
    --
    local function doesCollide(x1, y1, x2, y2)
        return x1 < x2 + Constants.TILESIZE
                and x2 < x1 + Constants.TILESIZE
                and y1 < y2 + Constants.TILESIZE
                and y2 < y1 + Constants.TILESIZE;
    end

    ---
    -- This function will create a pulsating effect, by reducing
    -- and increasing the alpha channel of the entity as long as
    -- any negative effects are active.
    -- @param dt
    --
    local function updateAlpha(dt)
        if upgrades.bombdown.active or upgrades.snail.active then
            pulse = pulse + dt * 2;
            local sin = math.sin(pulse);
            if sin < 0 then
                pulse = 0;
                sin = 0;
            end
            alpha = sin * 255;
        else
            alpha = 255;
        end
    end

    ---
    -- Upgrades the counter of each up / downgrade and deactivates
    -- it, if the counter has reached zero.
    -- @param dt
    --
    local function updateUpgrades(dt)
        for name, upgrade in pairs(upgrades) do
            if upgrade.active then
                if upgrade.counter and upgrade.counter > 0 then
                    upgrades[name].counter = upgrades[name].counter - dt;
                else
                    upgrades[name].deactivate();
                end
            end
        end
    end

    ---
    -- Update the currently active animation.
    -- @param dt
    --
    local function updateAnimation(dt)
        curAnim:update(dt);
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:updateCounters(dt)
        updateUpgrades(dt);
        updateAlpha(dt);
        updateAnimation(dt);
    end

    function self:drawAnimation()
        love.graphics.setColor(255, 255, 255, alpha);
        curAnim:draw(realX, realY);
        love.graphics.setColor(255, 255, 255, 255);
    end

    local function updatePosition(dt, direction)
        -- Lerp the player's position into the direction we have
        -- determined above.
        if direction == 'n' then
            curAnim = anim.walkN;
            realY = realY - 1 * currentSpeed * dt;
            realX = Math.lerp(realX, gridX * Constants.TILESIZE, lerpFactor);
        elseif direction == 's' then
            curAnim = anim.walkS;
            realY = realY + 1 * currentSpeed * dt;
            realX = Math.lerp(realX, gridX * Constants.TILESIZE, lerpFactor);
        elseif direction == 'e' then
            curAnim = anim.walkE;
            realX = realX + 1 * currentSpeed * dt;
            realY = Math.lerp(realY, gridY * Constants.TILESIZE, lerpFactor);
        elseif direction == 'w' then
            curAnim = anim.walkW;
            realX = realX - 1 * currentSpeed * dt;
            realY = Math.lerp(realY, gridY * Constants.TILESIZE, lerpFactor);
        end

        -- Calculate the grid coordinates, by dividing the real
        -- coordinates by the tile size of the grid and rounding it
        -- to the next integer.
        gridX = math.floor((realX / Constants.TILESIZE) + 0.5);
        gridY = math.floor((realY / Constants.TILESIZE) + 0.5);
    end

    ---
    --
    -- @param prefDir - The preferred direction to walk to.
    -- @param altDir - The alternative direction to walk to if the first one is not valid.
    --
    local function calculatePosition(dt, prefDir, altDir)
        local adjTiles = arena:getAdjacentTiles(gridX, gridY);
        local direction;

        -- If tiles are passable just move into that direction.
        if adjTiles[prefDir]:isPassable() then
            direction = prefDir;
            updatePosition(dt, direction);
            takeUpgrade(gridX, gridY);
            return;
        elseif altDir and adjTiles[altDir]:isPassable() then
            direction = altDir;
            updatePosition(dt, direction);
            takeUpgrade(gridX, gridY);
            return;
        end

        -- If tile is not passable make an AABB check to see if we have to stop already.
        if not adjTiles[prefDir]:isPassable() then
            if not doesCollide(realX, realY, adjTiles[prefDir]:getRealX(), adjTiles[prefDir]:getRealY()) then
                direction = prefDir;
                updatePosition(dt, direction);
                takeUpgrade(gridX, gridY);
                return;
            else
                if adjTiles[prefDir]:getContentType() == CONTENT.BOMB then
                    adjTiles[prefDir]:kickBomb(prefDir);
                end
                if prefDir == 'n' or prefDir == 's' then
                    realY = Math.lerp(realY, gridY * Constants.TILESIZE, lerpFactor);
                elseif prefDir == 'e' or prefDir == 'w' then
                    realX = Math.lerp(realX, gridX * Constants.TILESIZE, lerpFactor);
                end
            end
        end

        -- If tile is not passable make an AABB check to see if we have to stop already.
        if altDir and not adjTiles[altDir]:isPassable() then
            if not doesCollide(realX, realY, adjTiles[altDir]:getRealX(), adjTiles[altDir]:getRealY()) then
                direction = altDir;
                updatePosition(dt, direction);
                takeUpgrade(gridX, gridY);
                return;
            else
                if adjTiles[altDir]:getContentType() == CONTENT.BOMB then
                    adjTiles[altDir]:kickBomb(altDir);
                end
                if altDir == 'n' or altDir == 's' then
                    realY = Math.lerp(realY, gridY * Constants.TILESIZE, lerpFactor);
                elseif altDir == 'e' or altDir == 'w' then
                    realX = Math.lerp(realX, gridX * Constants.TILESIZE, lerpFactor);
                end
            end
        end
    end

    function self:move(dt, dirA, dirB)
        local adjTiles = arena:getAdjacentTiles(gridX, gridY);

        -- If no direction keys have been pressed reset the previous
        -- direction to nil.
        if not dirA and not dirB then
            curAnim = anim.idleS;
            prevMovementDir = nil;
            return;
        end

        -- If only one key is pressed store the direction
        -- as the previous direction.
        if dirA and not dirB then
            prevMovementDir = dirA;
            calculatePosition(dt, dirA);
            return;
        end

        -- If two keys are pressed, check if one of them was
        -- previously pressed and then try to move into the other
        -- direction.
        if dirA and dirB then
            if dirA == prevMovementDir then
                calculatePosition(dt, dirB, dirA);
            elseif dirB == prevMovementDir then
                calculatePosition(dt, dirA, dirB);
            else
                return;
            end
        end
    end

    function self:plantBomb()
        if liveBombs < bombCapacity and not upgrades.bombdown.active then
            if self:getTile():isPassable() then
                self:getTile():plantBomb(blastRadius, self);
                liveBombs = liveBombs + 1;
            end
        end
    end

    function self:removeBomb()
        liveBombs = liveBombs - 1;
    end

    function self:kill()
        dead = true;
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getAlpha()
        return alpha;
    end

    function self:getX()
        return gridX;
    end

    function self:getY()
        return gridY;
    end

    function self:getId()
        return id;
    end

    function self:getRealX()
        return realX;
    end

    function self:getRealY()
        return realY;
    end

    function self:isDead()
        return dead;
    end

    function self:getTile()
        return arena:getTile(gridX, gridY);
    end

    function self:getAdjacentTiles()
        return arena:getAdjacentTiles(gridX, gridY);
    end

    function self:getLivingBombs()
        return liveBombs;
    end

    function self:getBombCapacity()
        return bombCapacity;
    end

    function self:getBlastRadius()
        return blastRadius;
    end

    function self:getPosition()
        return gridX, gridY;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setId(nid)
        id = nid;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Entity;

--==================================================================================================
-- Created 31.07.14 - 00:27                                                                        =
--==================================================================================================