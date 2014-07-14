local BombHandler = {};

local bombs = {};
local arena;

function BombHandler.registerPlayer()
    local playerId = #bombs + 1;
    bombs[playerId] = {};
    return playerId;
end

function BombHandler.addBomb(playerId, bomb)
    bombs[playerId][#bombs[playerId] + 1] = bomb;
end

local function explode(bomb)
    arena:addExplosion(bomb:getX(), bomb:getY(), bomb:getStrength());
end

function BombHandler.update(dt)
    for playerId = 1, #bombs do
        for bombId = #bombs[playerId], 1, -1 do
            local bomb = bombs[playerId][bombId];
            bomb:update(dt);
            -- If the bomb timer runs out we explode the bomb.
            if bomb:getTimer() <= 0 or arena:isExplosion(bomb:getX(), bomb:getY()) then
                explode(bomb);
                table.remove(bombs[playerId], bombId);
            end
        end
    end
end

function BombHandler.draw()
    for id = 1, #bombs do
        for bombId = 1, #bombs[id] do
            bombs[id][bombId]:draw();
        end
    end
end

function BombHandler.setArena(narena)
    arena = narena;
end

return BombHandler;

--==================================================================================================
-- Created 15.07.14 - 02:43                                                                        =
--==================================================================================================