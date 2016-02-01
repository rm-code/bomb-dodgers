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

local Constants = {};

Constants.CONTENT = {};
Constants.CONTENT.SOFTWALL = 'softwall';
Constants.CONTENT.HARDWALL = 'hardwall';
Constants.CONTENT.BOMB = 'bomb';
Constants.CONTENT.EXPLOSION = 'explosion';
Constants.CONTENT.UPGRADE = 'upgrade';
Constants.CONTENT.DOOR = 'door';

Constants.TILESIZE = 32;
Constants.BOMBTIMER = 2.5;
Constants.EXPLOSIONTIMER = 1.5;

Constants.UPGRADES = {};
Constants.UPGRADES.TIMER = 30;
Constants.UPGRADES.DROPCHANCE = 5;

return Constants;

--==================================================================================================
-- Created 13.08.14 - 01:48                                                                        =
--==================================================================================================