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

local FileHandler = {};

-- ------------------------------------------------
-- Public Functions
-- ------------------------------------------------

function FileHandler.save(profile)
    local file = love.filesystem.newFile('player.sav', 'w');

    file:write('return {\n');
    for key, value in pairs(profile) do
        file:write(string.format('    %s = %s,\n', key, tostring(value)));
    end
    file:write('};');
end

function FileHandler.load()
    local file = love.filesystem.load('player.sav');

    if file then
        return file();
    end

    return {
        door1 = true,
        door2 = false,
        door3 = false,
        door4 = false,
        vsync = true,
        mode = 1,
        scaleX = 1,
        scaleY = 1,
        shaders = true,
        sfx = 10,
        music = 10,
    };
end

function FileHandler.delete()
    return love.filesystem.remove('player.sav');
end

return FileHandler;

--==================================================================================================
-- Created 06.10.14 - 02:46                                                                        =
--==================================================================================================