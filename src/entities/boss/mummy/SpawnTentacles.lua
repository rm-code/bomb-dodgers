--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Tentacles = require('src/entities/boss/mummy/ClothTentacle');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local SpawnTentacles = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function SpawnTentacles.new(fsm, boss, arena)
    local self = {};

    local timer = 2;

    ---
    -- Spawns an upgrade somewhere on the grid.
    -- @param amount
    --
    local function spawnTentacles(amount, arena)
        local rndX, rndY;
        local tentacle;
        local count = 0;
        while count < amount do
            rndX, rndY = love.math.random(1, arena:getWidth()), love.math.random(1, arena:getHeight());

            -- Only spawn upgrades on free tiles.
            if not arena:getTile(rndX, rndY):getContent() then
                tentacle = Tentacles.new(rndX, rndY);
                arena:getTile(rndX, rndY):addContent(tentacle);
                count = count + 1;
            end
        end
    end

    function self:enter() end

    function self:update(dt)
        timer = timer - dt;
        if timer <= 0 then
            spawnTentacles(5, arena);
            timer = 2;
            fsm:switch('move');
        end
    end

    function self:exit() end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return SpawnTentacles;

--==================================================================================================
-- Created 10.10.14 - 23:43                                                                        =
--==================================================================================================