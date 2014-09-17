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

    local counters = {};
    local bombdown;
    local snail;

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
    -- Takes an upgrade and decides what should happen to the entity
    -- based on the type of upgrade.
    -- @param x - The x position from which to pick the upgrade.
    -- @param y - The y position from which to pick the upgrade.
    --
    local function takeUpgrade(x, y)
        local target = arena:getTile(x, y);
        if target:getContentType() == CONTENT.UPGRADE then
            local upgrade = target:getContent();
            if upgrade:getUpgradeType() == 'fireup' and not snail then
                blastRadius = blastRadius + 1;
            elseif upgrade:getUpgradeType() == 'bombup' and not snail then
                bombCapacity = bombCapacity + 1;
            elseif upgrade:getUpgradeType() == 'bombdown' then
                bombdown = true;
                counters.bombdown = 5;
            elseif upgrade:getUpgradeType() == 'snail' and not snail then
                snail = true;
                counters.snail = 5;
                lerpFactor = 0.1;
                tmpCap = bombCapacity;
                bombCapacity = 1;
                tmpRadius = blastRadius;
                blastRadius = 2;
                currentSpeed = slowSpeed;
            end
            upgrade:remove();
        end
    end

    local function doesCollide(x1, y1, x2, y2)
        return x1 < x2 + Constants.TILESIZE
                and x2 < x1 + Constants.TILESIZE
                and y1 < y2 + Constants.TILESIZE
                and y2 < y1 + Constants.TILESIZE;
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:updateCounters(dt)
        if bombdown then
            if counters.bombdown > 0 then
                counters.bombdown = counters.bombdown - dt;
            else
                bombdown = false;
                counters.bombdown = nil;
            end
        end
        if snail then
            if counters.snail > 0 then
                counters.snail = counters.snail - dt;
            else
                snail = false;
                counters.snail = nil;
                lerpFactor = 0.2;
                bombCapacity = tmpCap;
                blastRadius = tmpRadius;
                currentSpeed = normalSpeed;
            end
        end

        if bombdown or snail then
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

    function self:updateAnimation(dt)
        curAnim:update(dt);
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
        if liveBombs < bombCapacity and not bombdown then
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