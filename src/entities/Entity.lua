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

function Entity.new(arena, x, y)
    local self = {};

    local arena = arena;
    local gridX = x;
    local gridY = y;
    local realX = gridX * Constants.TILESIZE;
    local realY = gridY * Constants.TILESIZE;

    local liveBombs = 0; -- The amount of bombs currently on the field.
    local bombCapacity = 1; -- The total amount of bombs the player can carry.
    local blastRadius = 2; -- The blast radius of a bomb.

    local dead = false;

    local bombdown;
    local counters = {};

    local alpha = 255; -- The current alpha of the entity.
    local pulse = 0; -- The pulse which will be used to create a pulsating effect.

    local prevMovementDir; -- The direction in which the player moved previously.

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function takeUpgrade(x, y)
        local target = arena:getTile(x, y);
        if target:getContentType() == CONTENT.UPGRADE then
            local upgrade = target:getContent();
            if upgrade:getUpgradeType() == 'fireup' then
                blastRadius = blastRadius + 1;
            elseif upgrade:getUpgradeType() == 'bombup' then
                bombCapacity = bombCapacity + 1;
            elseif upgrade:getUpgradeType() == 'bombdown' then
                bombdown = true;
                counters.bombdown = 5;
            end
            upgrade:remove();
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------
    local speed = 2;
    local function lerp(a, b, t)
        return (1 - t) * a + t * b;
    end

    function self:updateCounters(dt)
        if bombdown then
            if counters.bombdown > 0 then
                counters.bombdown = counters.bombdown - dt;
            else
                bombdown = false;
                counters.bombdown = nil;
            end
        end

        if bombdown then
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
    --
    -- @param prefDir - The preferred direction to walk to.
    -- @param altDir - The alternative direction to walk to if the first one is not valid.
    --
    local function updatePlayerPosition(prefDir, altDir)
        local adjTiles = arena:getAdjacentTiles(gridX, gridY);
        local direction;

        -- If the preferred direction is valid we'll use it to move the
        -- player. If the preferred direction is invalid we check the
        -- passability of the alternative direction. If that one is
        -- invalid to, we lerp the players position to the current tile.
        if adjTiles[prefDir]:isPassable() then
            direction = prefDir;
        elseif altDir and adjTiles[altDir]:isPassable() then
            direction = altDir;
        else
            realX = lerp(realX, gridX * Constants.TILESIZE, 0.2);
            realY = lerp(realY, gridY * Constants.TILESIZE, 0.2);
        end

        -- Lerp the player's position into the direction we have
        -- determined above.
        if direction == 'n' then
            realY = realY - 1 * speed;
            realX = lerp(realX, gridX * Constants.TILESIZE, 0.2);
        elseif direction == 's' then
            realY = realY + 1 * speed;
            realX = lerp(realX, gridX * Constants.TILESIZE, 0.2);
        elseif direction == 'e' then
            realX = realX + 1 * speed;
            realY = lerp(realY, gridY * Constants.TILESIZE, 0.2);
        elseif direction == 'w' then
            realX = realX - 1 * speed;
            realY = lerp(realY, gridY * Constants.TILESIZE, 0.2);
        end

        -- Calculate the grid coordinates, by dividing the real
        -- coordinates by the tile size of the grid and rounding it
        -- to the next integer.
        gridX = math.floor((realX / Constants.TILESIZE) + 0.5);
        gridY = math.floor((realY / Constants.TILESIZE) + 0.5);

        -- Take upgrade.
        takeUpgrade(gridX, gridY);
    end

    function self:move(dirA, dirB)
        local adjTiles = arena:getAdjacentTiles(gridX, gridY);

        -- If no direction keys have been pressed reset the previous
        -- direction to nil.
        if not dirA and not dirB then
            prevMovementDir = nil;
            return;
        end

        -- If only one key is pressed store the direction
        -- as the previous direction.
        if dirA and not dirB then
            prevMovementDir = dirA;
            updatePlayerPosition(dirA);
            return;
        end

        -- If two keys are pressed, check if one of them was
        -- previously pressed and then try to move into the other
        -- direction.
        if dirA and dirB then
            if dirA == prevMovementDir then
                updatePlayerPosition(dirB, dirA);
            elseif dirB == prevMovementDir then
                updatePlayerPosition(dirA, dirB);
            else
                return;
            end
        end
    end

    function self:plantBomb()
        if liveBombs < bombCapacity and not bombdown then
            if self:getTile():isPassable() then
                self:getTile():plantBomb(blastRadius, self);
            end

            liveBombs = liveBombs + 1;
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

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Entity;

--==================================================================================================
-- Created 31.07.14 - 00:27                                                                        =
--==================================================================================================