local Bomb = require('src/game/objects/Bomb');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Entity = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Entity.new(arena, x, y)
    local self = {};

    local arena = arena;
    local x = x;
    local y = y;

    local liveBombs = 0; -- The amount of bombs currently on the field.
    local bombCapacity = 1; -- The total amount of bombs the player can carry.
    local blastRadius = 1; -- The blast radius of a bomb.

    local dead = false;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function takeUpgrade(x, y)
        local target = arena:getTile(x, y);
        if target:getContentType() == 'blastboost' then
            blastRadius = blastRadius + 1;
            target:removeContent();
        elseif target:getContentType() == 'carryboost' then
            bombCapacity = bombCapacity + 1;
            target:removeContent();
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:move(direction)
        local adjTiles = arena:getAdjacentTiles(x, y);
        local target = adjTiles[direction];

        if target:isPassable() then
            x = target:getX();
            y = target:getY();
            takeUpgrade(x, y);
        elseif target:getContentType() == 'bomb' then
            target:signal({ name = 'kickbomb', direction = direction });
        end
    end

    function self:plantBomb()
        if liveBombs < bombCapacity then
            local bomb = Bomb.new();
            bomb:setStrength(blastRadius);
            bomb:setPlayer(self);
            arena:getTile(x, y):addContent(bomb);

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

    function self:getX()
        return x;
    end

    function self:getY()
        return y;
    end

    function self:isDead()
        return dead;
    end

    function self:getTile()
        return arena:getTile(x, y);
    end

    function self:getAdjacentTiles(x, y)
        return arena:getAdjacentTiles(x, y);
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

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Entity;

--==================================================================================================
-- Created 31.07.14 - 00:27                                                                        =
--==================================================================================================