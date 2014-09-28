local Math = require('lib/Math');
local Constants = require('src/Constants');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Entity = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Entity.new(arena, x, y, animations)
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

    local curAnim = animations.idleS;

    local speed = 150;
    local lerpFactor = 0.2; -- The lerpFactor to use for the entity's movement.

    local prevDirection;

    local alpha = 255; -- The current alpha of the entity.
    local pulse = 0; -- The pulse which will be used to create a pulsating effect.

    local camera;

    local dead;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

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

    local function updatePosition(dt, direction)
        -- Lerp the player's position into the direction we have
        -- determined above.
        if direction == 'n' then
            curAnim = animations.walkN;
            realY = realY - 1 * speed * dt;
            realX = Math.lerp(realX, gridX * Constants.TILESIZE, lerpFactor);
        elseif direction == 's' then
            curAnim = animations.walkS;
            realY = realY + 1 * speed * dt;
            realX = Math.lerp(realX, gridX * Constants.TILESIZE, lerpFactor);
        elseif direction == 'e' then
            curAnim = animations.walkE;
            realX = realX + 1 * speed * dt;
            realY = Math.lerp(realY, gridY * Constants.TILESIZE, lerpFactor);
        elseif direction == 'w' then
            curAnim = animations.walkW;
            realX = realX - 1 * speed * dt;
            realY = Math.lerp(realY, gridY * Constants.TILESIZE, lerpFactor);
        end

        -- Calculate the grid coordinates, by dividing the real
        -- coordinates by the tile size of the grid and rounding it
        -- to the next integer.
        gridX = math.floor((realX / Constants.TILESIZE) + 0.5);
        gridY = math.floor((realY / Constants.TILESIZE) + 0.5);
    end

    ---
    -- Checks the given direction for possible movement options.
    --
    -- @param dt
    -- @param adjTiles
    -- @param direction
    --
    local function checkDirection(dt, adjTiles, direction)

        -- If the adjTile in that direction is passable then the entity is moved.
        if adjTiles[direction]:isPassable() then
            updatePosition(dt, direction);
            return true;
        end

        -- If the adjTile is impassable an AABB check is made to see if the entity.
        -- is already colliding with the tile. If the entity isn't colliding yet,
        -- it can still be moved into the given direction.
        if not doesCollide(realX, realY, adjTiles[direction]:getRealX(), adjTiles[direction]:getRealY()) then
            updatePosition(dt, direction);
            return true;
        end

        -- If the AABB check is positive, we check if the tile's content is a bomb.
        -- If the content is a bomb the entity will try to kick it.
        if adjTiles[direction]:getContentType() == Constants.CONTENT.BOMB then
            adjTiles[direction]:kickBomb(direction);
            return true;
        end

        -- If all of the above options weren't valid, we lerp the entity to the tile's
        -- axis belonging to the movement direction and return 'false' to notify the
        -- game that this direction isn't valid anymore.
        if direction == 'n' or direction == 's' then
            realY = Math.lerp(realY, gridY * Constants.TILESIZE, lerpFactor);
            return false;
        elseif direction == 'e' or direction == 'w' then
            realX = Math.lerp(realX, gridX * Constants.TILESIZE, lerpFactor);
            return false;
        end
    end

    ---
    --
    -- @param prefDir - The preferred direction to walk to.
    -- @param altDir - The alternative direction to walk to if the first one is not valid.
    --
    local function moveIntoDirection(dt, prefDir, altDir)
        local adjTiles = arena:getAdjacentTiles(gridX, gridY);

        if prefDir and checkDirection(dt, adjTiles, prefDir) then
            return true;
        elseif altDir and checkDirection(dt, adjTiles, altDir) then
            return true;
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:move(dt, dirA, dirB)
        local adjTiles = arena:getAdjacentTiles(gridX, gridY);

        -- If no direction keys have been pressed reset the previous
        -- direction to nil.
        if not dirA and not dirB then
            curAnim = animations.idleS;
            prevDirection = nil;
            return;
        end

        -- If only one key is pressed store the direction
        -- as the previous direction.
        if dirA and not dirB then
            prevDirection = dirA;
            return moveIntoDirection(dt, dirA);
        end

        -- If two keys are pressed, check if one of them was
        -- previously pressed and then try to move into the other
        -- direction.
        if dirA and dirB then
            if dirA == prevDirection then
                return moveIntoDirection(dt, dirB, dirA);
            elseif dirB == prevDirection then
                return moveIntoDirection(dt, dirA, dirB);
            end
        end
    end

    ---
    -- Update the currently active animation.
    -- @param dt
    --
    function self:updateAnimation(dt)
        curAnim:update(dt);
    end

    function self:drawAnimation()
        love.graphics.setColor(255, 255, 255, alpha);
        curAnim:draw(realX, realY);
        love.graphics.setColor(255, 255, 255, 255);
    end

    ---
    -- This function will create a pulsating effect.
    -- @param dt
    --
    function self:pulse(dt)
        pulse = pulse + dt * 2;
        local sin = math.sin(pulse);
        if sin < 0 then
            pulse = 0;
            sin = 0;
        end
        alpha = sin * 255;
    end

    function self:updateCamera(dt)
        if camera then
            camera:track(realX, realY, 6, dt);
        end
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

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

    function self:getId()
        return id;
    end

    function self:getTile()
        return arena:getTile(gridX, gridY);
    end

    function self:getAdjacentTiles()
        return arena:getAdjacentTiles(gridX, gridY);
    end

    function self:getPosition()
        return gridX, gridY;
    end

    function self:isDead()
        return dead;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setPosition(x, y)
        gridX = x;
        gridY = y;
        realX = gridX * Constants.TILESIZE;
        realY = gridY * Constants.TILESIZE;
    end

    function self:setId(nid)
        id = nid;
    end

    function self:setAlpha(nalpha)
        alpha = nalpha;
    end

    function self:setSpeed(nspeed)
        speed = nspeed;
    end

    function self:setCamera(ncamera)
        camera = ncamera;
    end

    function self:setDead(ndead)
        dead = ndead;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Entity;

--==================================================================================================
-- Created 26.09.14 - 14:18                                                                        =
--==================================================================================================