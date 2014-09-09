--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local Content = require('src/arena/objects/Content');
local Constants = require('src/Constants');
local Explosion = require('src/arena/objects/Explosion');
local AniMAL = require('lib/AniMAL');
local ResourceManager = require('lib/ResourceManager');
local PlayerManager = require('src/entities/PlayerManager');
local NpcManager = require('src/entities/NpcManager');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Bomb = {};

-- ------------------------------------------------
-- Constants
-- ------------------------------------------------

local CONTENT = Constants.CONTENT;
local TILESIZE = Constants.TILESIZE;
local BOMBTIMER = Constants.BOMBTIMER;

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

-- Register module with resource manager.
ResourceManager.register(Bomb);

---
-- Load images.
--
function Bomb.loadImages()
    images['bomb_anim'] = ResourceManager.loadImage('res/img/content/bomb_animation.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Bomb.new(x, y)
    local self = Content.new(CONTENT.BOMB, false);

    -- ------------------------------------------------
    -- Private Variables
    -- ------------------------------------------------

    local blastRadius;
    local owner;
    local timer = BOMBTIMER;
    local anim = AniMAL.new(images['bomb_anim'], TILESIZE, TILESIZE, 0.2);
    local direction;
    local gridX = x;
    local gridY = y;
    local pxX = gridX * TILESIZE;
    local pxY = gridY * TILESIZE;
    local speed = 200;

    -- ------------------------------------------------
    -- Private Functions
    -- ------------------------------------------------

    ---
    -- Move the bomb into the direction it has been kicked in, until it hits
    -- something impassable.
    -- @param direction - The direction the bomb has been kicked in.
    --
    local function move(dt, direction)
        local adjTiles = self:getParent():getAdjacentTiles(gridX, gridY);
        local target = adjTiles[direction];
        local playerX, playerY = PlayerManager.getClosestPlayer(gridX, gridY);
        local npcX, npcY = NpcManager.getClosestNpc(gridX, gridY);

        if target:getContentType() == CONTENT.EXPLOSION then
            self:getParent():explode(blastRadius, 'all');
            return;
        elseif (playerX == target:getX() and playerY == target:getY())
                or (npcX == target:getX() and npcY == target:getY())
                or not target:isPassable() then
            gridX = self:getParent():getX();
            gridY = self:getParent():getY();
            pxX = gridX * TILESIZE;
            pxY = gridY * TILESIZE;
        elseif target:isPassable() then
            -- Update pixel coordinates
            if direction == 'n' then
                pxY = pxY - 1 * speed * dt;
            elseif direction == 's' then
                pxY = pxY + 1 * speed * dt;
            elseif direction == 'e' then
                pxX = pxX + 1 * speed * dt;
            elseif direction == 'w' then
                pxX = pxX - 1 * speed * dt;
            end

            -- Calculate the grid coordinates, by dividing the real
            -- coordinates by the tile size of the grid and rounding it
            -- to the next integer.
            local tmpX = math.floor(pxX / Constants.TILESIZE);
            local tmpY = math.floor(pxY / Constants.TILESIZE);

            if tmpX ~= gridX or tmpY ~= gridY then
                gridX = tmpX;
                gridY = tmpY;

                -- Decrease the danger value of all tiles within the blast radius.
                self:decreaseDanger(blastRadius, 'all', adjTiles);

                -- Remove the bomb from the current tile.
                self:getParent():clearContent();

                -- Add the bomb to the next tile.
                target:addContent(self);

                -- Update the bombs coordinates and make distribute the danger information.
                gridX = target:getX();
                gridY = target:getY();
                self:increaseDanger(blastRadius, 'all', target:getAdjacentTiles(gridX, gridY));
            end
            return direction;
        end
    end

    -- ------------------------------------------------
    -- Public Functions
    -- ------------------------------------------------

    function self:draw()
        anim:draw(pxX, pxY);
    end

    function self:update(dt)
        anim:update(dt);

        if direction then
            direction = move(dt, direction);
            print(direction);
        end

        timer = timer - dt;
        if timer <= 0 then
            self:getParent():explode(blastRadius, 'all');
        end
    end

    ---
    -- Makes the bomb explode.
    -- @param adjTiles - The tiles adjacent to the bomb's parent tile.
    --
    function self:explode(_, _, adjTiles)
        -- Send out a signal to decrease the danger value of the tiles within the blast radius.
        self:decreaseDanger(blastRadius, 'all', self:getParent():getAdjacentTiles(gridX, gridY));
        -- Add an explosion to the tile the bomb was on.
        self:getParent():addContent(Explosion.new(blastRadius, gridX, gridY));

        -- Notify neighbours about the explosion. They will know what to do with that information.
        adjTiles['n']:explode(blastRadius - 1, 'n');
        adjTiles['s']:explode(blastRadius - 1, 's');
        adjTiles['e']:explode(blastRadius - 1, 'e');
        adjTiles['w']:explode(blastRadius - 1, 'w');

        -- Remove the bomb from the player's planted bombs counter.
        owner:removeBomb();
    end

    ---
    -- Increase the danger of the current tile and notify the
    -- next tiles.
    -- @param radius - The blast radius.
    -- @param direction - The direction in which to distribute the signal.
    -- @param adjTiles - The adjacent tiles next to the bomb's parent tile.
    --
    function self:increaseDanger(radius, direction, adjTiles)
        if direction == 'all' then
            self:getParent():setDanger(blastRadius);
            adjTiles['n']:increaseDanger(blastRadius - 1, 'n');
            adjTiles['s']:increaseDanger(blastRadius - 1, 's');
            adjTiles['e']:increaseDanger(blastRadius - 1, 'e');
            adjTiles['w']:increaseDanger(blastRadius - 1, 'w');
        else
            self:getParent():setDanger(radius);
            adjTiles[direction]:increaseDanger(radius - 1, direction);
        end
    end

    ---
    -- Decrease the danger of the current tile and notify the
    -- next tiles.
    -- @param radius - The blast radius.
    -- @param direction - The direction in which to distribute the signal.
    -- @param adjTiles - The adjacent tiles next to the bomb's parent tile.
    --
    function self:decreaseDanger(radius, direction, adjTiles)
        if direction == 'all' then
            self:getParent():setDanger(-blastRadius);
            adjTiles['n']:decreaseDanger(blastRadius - 1, 'n');
            adjTiles['s']:decreaseDanger(blastRadius - 1, 's');
            adjTiles['e']:decreaseDanger(blastRadius - 1, 'e');
            adjTiles['w']:decreaseDanger(blastRadius - 1, 'w');
        else
            self:getParent():setDanger(-radius);
            adjTiles[direction]:decreaseDanger(radius - 1, direction);
        end
    end

    -- ------------------------------------------------
    -- Getters
    -- ------------------------------------------------

    function self:getBlastRadius()
        return blastRadius;
    end

    -- ------------------------------------------------
    -- Setters
    -- ------------------------------------------------

    function self:setBlastRadius(radius)
        blastRadius = radius;
    end

    function self:setOwner(entity)
        owner = entity;
    end

    function self:setDirection(dir)
        direction = dir;
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Bomb;

--==================================================================================================
-- Created 15.07.14 - 00:37                                                                        =
--==================================================================================================