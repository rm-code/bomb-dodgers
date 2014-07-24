local Config = require('src/Config');
local Explosion = require('src/game/Explosion');

local Tile = {};

function Tile.new()
    local self = {};

    local content;
    local passable;
    local grid;
    local x, y;
    local background;

    function self:init(nx, ny, nbg, npassable)
        x = nx;
        y = ny;
        background = nbg;
        if npassable == 0 then
            passable = true;
        else
            passable = false;
        end
    end

    function self:update(dt)
        if content then
            content:update(dt);
        end
    end

    function self:draw()
        -- TODO replace with images
        if background == 0 then
            -- love.graphics.rectangle('line', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
        elseif background == 1 then
            love.graphics.setColor(200, 200, 200);
            love.graphics.rectangle('fill', x * Config.tileSize, y * Config.tileSize, Config.tileSize, Config.tileSize);
        end
        love.graphics.setColor(255, 255, 255);

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
        return passable and content == nil;
    end

    return self;
end

return Tile;

--==================================================================================================
-- Created 24.07.14 - 16:06                                                                        =
--==================================================================================================