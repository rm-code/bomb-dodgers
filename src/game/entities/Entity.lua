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

    -- ------------------------------------------------
    -- Function
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

    function self:move(direction)
        local dx, dy;
        if direction == 'north' then
            dx, dy = 0, -1;
        elseif direction == 'south' then
            dx, dy = 0, 1;
        elseif direction == 'west' then
            dx, dy = -1, 0;
        elseif direction == 'east' then
            dx, dy = 1, 0;
        end

        local target = arena:getTile(x + dx, y + dy);
        if target:isPassable() then
            x = x + dx;
            y = y + dy;
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

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getX()
        return x;
    end

    function self:getY()
        return y;
    end

    function self:getTile()
        return arena:getTile(x, y);
    end

    function self:getAdjacentTiles(x, y)
        return arena:getTile(x, y - 1),
        arena:getTile(x, y + 1),
        arena:getTile(x + 1, y),
        arena:getTile(x - 1, y);
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