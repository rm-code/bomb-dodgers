local Config = require('src/Config');
local Explosion = require('src/game/objects/Explosion');

local Tile = {};

function Tile.new()
    local self = {};

    local content;
    local grid;
    local x, y;

    function self:init(nx, ny)
        x = nx;
        y = ny;
    end

    function self:update(dt)
        if content then
            content:update(dt);
        end
    end

    function self:draw()
        if content then
            content:draw();
        end
    end

    function self:signal(signal, params)
        if signal == 'detonate' then
            -- Add explosion to this tile.
            local explosion = Explosion.new();
            explosion:init(x, y);
            self:addContent(explosion);

            -- Check adjacent tiles.
            local dx;
            for i = 1, params do
                dx = x + i;
                if grid[dx][y]:isPassable() then
                    local explosion = Explosion.new();
                    explosion:init(dx, y);
                    grid[dx][y]:addContent(explosion);
                elseif not grid[dx][y]:isPassable() then
                    grid[dx][y]:signal('explode', params);
                    break;
                end
            end
            for i = 1, params do
                dx = x - i;
                if grid[dx][y]:isPassable() then
                    local explosion = Explosion.new();
                    explosion:init(dx, y);
                    grid[dx][y]:addContent(explosion);
                elseif not grid[dx][y]:isPassable() then
                    grid[dx][y]:signal('explode', params);
                    break;
                end
            end

            local dy;
            for i = 1, params do
                dy = y + i;
                if grid[x][dy]:isPassable() then
                    local explosion = Explosion.new();
                    explosion:init(x, dy);
                    grid[x][dy]:addContent(explosion);
                elseif not grid[x][dy]:isPassable() then
                    grid[x][dy]:signal('explode', params);
                    break;
                end
            end
            for i = 1, params do
                dy = y - i;
                if grid[x][dy]:isPassable() then
                    local explosion = Explosion.new();
                    explosion:init(x, dy);
                    grid[x][dy]:addContent(explosion);
                elseif not grid[x][dy]:isPassable() then
                    grid[x][dy]:signal('explode', params);
                    break;
                end
            end
        end
        if content then
            content:signal(signal, params);
        end
    end

    function self:addContent(ncontent)
        content = ncontent;
        content:setTile(self);
    end

    function self:removeContent()
        content = nil;
    end

    function self:setGrid(ngrid)
        grid = ngrid;
    end

    function self:isPassable()
        if content then
            if content:getType() == 'softwall' or content:getType() == 'bomb' or content:getType() == 'hardwall' then
                return false;
            elseif content:getType() == 'explosion' then
                return true;
            end
        else
            return true;
        end
    end

    function self:getContentType()
        if content then
            return content:getType();
        end
    end

    return self;
end

return Tile;

--==================================================================================================
-- Created 24.07.14 - 16:06                                                                        =
--==================================================================================================