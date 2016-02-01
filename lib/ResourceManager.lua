--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 - 2016 Robert Machmer                                      --
--                                                                               --
-- This software is provided 'as-is', without any express or implied             --
-- warranty. In no event will the authors be held liable for any damages         --
-- arising from the use of this software.                                        --
--                                                                               --
-- Permission is granted to anyone to use this software for any purpose,         --
-- including commercial applications, and to alter it and redistribute it        --
-- freely, subject to the following restrictions:                                --
--                                                                               --
--  1. The origin of this software must not be misrepresented; you must not      --
--      claim that you wrote the original software. If you use this software     --
--      in a product, an acknowledgment in the product documentation would be    --
--      appreciated but is not required.                                         --
--  2. Altered source versions must be plainly marked as such, and must not be   --
--      misrepresented as being the original software.                           --
--  3. This notice may not be removed or altered from any source distribution.   --
--                                                                               --
--===============================================================================--

local ResourceManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local images = {};
local fonts = {};
local sounds = {};
local music = {};
local toLoad = {};

local done = false;

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

---
-- Registers the target with the resource manager. When
-- the resource manager starts loading the resources it will
-- cycle through all registered targets and call their loading
-- functions.
--
-- @param target - The target to register.
--
function ResourceManager.register(target)
    toLoad[#toLoad + 1] = target;
end

---
-- Loads all resources. This includes images, sounds, music
-- and fonts.
--
function ResourceManager.loadResources()
    local startTime = love.timer.getTime();
    print("\n---- LOADING RESOURCES ----");
    print("Loading images: ");
    for i = 1, #toLoad do
        local target = toLoad[i];

        if target.loadImages then
            target.loadImages();
        end
    end

    print("Loading sounds: ");
    for i = 1, #toLoad do
        local target = toLoad[i];
        if target.loadSounds then
            target.loadSounds();
        end
    end

    print("Loading music: ");
    for i = 1, #toLoad do
        local target = toLoad[i];

        if target.loadMusic then
            target.loadMusic();
        end
    end

    print("Loading fonts: ");
    for i = 1, #toLoad do
        local target = toLoad[i];

        if target.loadFonts then
            target.loadFonts();
        end
    end

    local endTime = love.timer.getTime();
    print(string.format("\nResources loaded in %.3f ms!", 1000 * (endTime - startTime)))
    print("===================");

    done = true;
end

---
-- Loads an image and stores it in the resource manager's
-- image table. If the same image is already stored in that
-- table that one will be returned. This way no resource will be
-- loaded twice.
--
-- @param path - The path to the image to load.
--
function ResourceManager.loadImage(path)
    if not images[path] then
        images[path] = love.graphics.newImage(path);
        print("    " .. path);
    end
    return images[path];
end

---
-- Loads an font and stores it in the resource manager's
-- font table. If the same font is already stored in that
-- table, then that one will be returned. This way no resource
-- will be loaded twice.
--
-- @param path - The path to the font to load.
-- @param size - The fonts size.
--
function ResourceManager.loadFont(path, size)
    if not fonts[path] then
        fonts[path] = love.graphics.newFont(path, size);
        print("    " .. path);
    end

    return fonts[path];
end

---
-- Loads a sound and stores it in the resource manager's
-- sound table. If the same sound is already stored in that
-- table, then that one will be returned. This way no resource
-- will be loaded twice.
--
-- @param path - The path to the sound to load.
-- @param type - The sound type ('stream' or 'static').
--
function ResourceManager.loadSound(path, type)
    if not sounds[path] then
        sounds[path] = love.audio.newSource(path, type)
        print("    " .. path)
    end

    return sounds[path]
end

---
-- Loads a song and stores it in the resource manager's
-- music table. If the same song is already stored in that
-- table, then that one will be returned. This way no resource
-- will be loaded twice.
--
-- @param path - The path to the song to load.
-- @param type - The sound type ('stream' or 'static').
--
function ResourceManager.loadMusic(path, type)
    if not music[path] then
        music[path] = love.audio.newSource(path, type)
        print("    " .. path)
    end

    return music[path]
end

---
-- Returns true if the resource manager has completed loading
-- all resources.
--
function ResourceManager.isDone()
    return done;
end

-- ------------------------------------------------
-- Return module
-- ------------------------------------------------

return ResourceManager;

--==================================================================================================
-- Created 11.06.14 - 15:50                                                                        =
--==================================================================================================