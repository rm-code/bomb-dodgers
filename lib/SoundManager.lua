local SoundManager = {};

-- ------------------------------------------------
-- Local Variables
-- ------------------------------------------------

local volumes = {};
volumes.sfx = 1;
volumes.music = 1;

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function SoundManager.play(source, type, x, y, z)
    source:stop();
    source:setVolume(volumes[type]);
    source:play();
    source:setPosition(x, y, z);
end

function SoundManager.stop(source)
    source:stop();
end

function SoundManager.setVolume(type, val)
    volumes[type] = val;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return SoundManager;

--==================================================================================================
-- Created 23.10.14 - 00:07                                                                        =
--==================================================================================================