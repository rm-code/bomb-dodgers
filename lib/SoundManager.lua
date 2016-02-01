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