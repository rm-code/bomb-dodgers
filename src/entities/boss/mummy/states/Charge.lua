-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Charge = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Charge.new(fsm, boss)
    local self = {};

    local adjTiles;
    local direction;
    local timer = 2;

    local function getDirection()
        if boss:getX() < 10 then
            return 'e';
        else
            return 'w';
        end
    end

    function self:enter()
        direction = getDirection();
        adjTiles = boss:getAdjacentTiles();
        boss:setSpeed(200);
    end

    function self:update(dt)
        if not adjTiles[direction]:isPassable() then
            fsm:switch('move');
            return;
        end

        timer = timer - dt;
        if timer <= 0 then
            if not boss:move(dt, direction) then
                fsm:switch('move');
                return;
            end
        end
    end

    function self:exit()
        boss:setSpeed(85);
        timer = 2;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Charge;

--==================================================================================================
-- Created 12.10.14 - 18:59                                                                        =
--==================================================================================================