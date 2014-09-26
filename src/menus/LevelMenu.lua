local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local Arena = require('src/arena/Arena');
local Player = require('src/entities/Player');
local Button = require('src/ui/Button');
local ButtonManager = require('src/ui/ButtonManager');
local InputManager = require('lib/InputManager');
local LevelSwitcher = require('src/screens/LevelSwitcher');
local Camera = require('lib/Camera');
local Constants = require('src/Constants');
local ResourceManager = require('lib/ResourceManager');
local PaletteSwitcher = require('src/colswitcher/PaletteSwitcher');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local LevelMenu = {};

-- ------------------------------------------------
-- Resource Loading
-- ------------------------------------------------

local images = {};

ResourceManager.register(LevelMenu);

function LevelMenu.loadImages()
    images['button'] = ResourceManager.loadImage('res/img/ui/button.png');
    images['lvl1'] = ResourceManager.loadImage('res/img/ui/preview_lvl_1.png');
    images['lvl2'] = ResourceManager.loadImage('res/img/ui/preview_lvl_2.png');
end

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function LevelMenu.new()
    local self = Screen.new();

    local arena;
    local player;
    local buttons;
    local camera;
    local shader;

    local function startOne()
        ScreenManager.switch(LevelSwitcher.new(1));
    end

    local function startTwo()
        ScreenManager.switch(LevelSwitcher.new(2));
    end

    function self:init()
        arena = Arena.new();
        arena:init('res/arenas/lvlselector.lua', true);

        camera = Camera.new();
        camera:setZoom(2.0);

        shader = love.graphics.newShader('res/shader/wave.fs');

        player = Player.new(arena, 2, 2);

        buttons = ButtonManager.new();
        buttons:register(Button.new(images['lvl1'], 128, 64, startOne));
        buttons:register(Button.new(images['lvl2'], 128, 256, startTwo));
    end

    local function handleInput()
        if InputManager.hasCommand('SELECT') then
            buttons:press();
        elseif InputManager.hasCommand('COL') then
            PaletteSwitcher.nextPalette();
        end
    end

    local function select()
        if player:getY() >= 2 and player:getY() <= 6 then
            buttons:select(1)
        elseif player:getY() > 7 and player:getY() <= 12 then
            buttons:select(2)
        end
    end

    function self:update(dt)
        arena:update(dt);
        player:update(dt);

        select();
        handleInput();

        camera:track(player:getRealX() + Constants.TILESIZE * 2.5, player:getRealY(), 6, dt);

        shader:send('time', love.timer.getTime());

        buttons:update(dt);
    end

    function self:draw()
        PaletteSwitcher.set();
        camera:set();
        arena:draw();
        player:draw();
        PaletteSwitcher.unset();

        love.graphics.setShader(shader);
        buttons:draw();
        love.graphics.setShader();

        camera:unset();
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return LevelMenu;

--==================================================================================================
-- Created 12.09.14 - 00:33                                                                        =
--==================================================================================================