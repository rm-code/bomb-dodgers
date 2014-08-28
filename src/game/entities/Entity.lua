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
    local x = x;
    local y = y;

    local liveBombs = 0; -- The amount of bombs currently on the field.
    local bombCapacity = 1; -- The total amount of bombs the player can carry.
    local blastRadius = 2; -- The blast radius of a bomb.

    local dead = false;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    local function takeUpgrade(target)
        if target:getContentType() == CONTENT.UPGRADE then
            local upgrade = target:getContent();
            if upgrade:getUpgradeType() == 'fireup' then
                blastRadius = blastRadius + 1;
            elseif upgrade:getUpgradeType() == 'bombup' then
                bombCapacity = bombCapacity + 1;
            end
            upgrade:remove();
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
            takeUpgrade(target);
        elseif target:getContentType() == CONTENT.BOMB then
            target:kickBomb(direction);
        end
    end

    function self:plantBomb()
        if liveBombs < bombCapacity then
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

    function self:getAdjacentTiles()
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

    function self:getPosition()
        return x, y;
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