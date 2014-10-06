--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

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
        door5 = false,
        door6 = false,
    };
end

function FileHandler.delete()
    return love.filesystem.remove('player.sav');
end

return FileHandler;

--==================================================================================================
-- Created 06.10.14 - 02:46                                                                        =
--==================================================================================================