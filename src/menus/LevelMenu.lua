local Screen = require('lib/screens/Screen');
local ScreenManager = require('lib/screens/ScreenManager');
local Arena = require('src/arena/Arena');
local Player = require('src/entities/Player');
local Button = require('src/ui/Button');
local ButtonManager = require('src/ui/ButtonManager');
local InputManager = require('lib/InputManager');
local Game = require('src/screens/Game');
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

    local function start()
        ScreenManager.switch(Game.new());
    end

    local function options()
    end

    local function exit()
    end

    function self:init()
        arena = Arena.new();
        arena:init('res/arenas/lvlselector.lua', true);

        camera = Camera.new();
        camera:setZoom(2.0);

        shader = love.graphics.newShader('res/shader/wave.fs');

        player = Player.new(arena, 2, 2);

        buttons = ButtonManager.new();
        buttons:register(Button.new(images['lvl1'], 128, 64, start));
    end

    local function handleInput()
        if InputManager.hasCommand('SELECT') then
            buttons:press();
        end
    end

    local function select()
        if player:getY() == 2 or player:getY() == 3 or player:getY() == 4 then
            buttons:select(1)
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