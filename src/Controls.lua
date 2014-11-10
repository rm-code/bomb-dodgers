--===============================================================================--
--                                                                               --
-- Copyright (c) 2014 Robert Machmer                                             --
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

local Controls = {};

-- ------------------------------------------------
-- GAME
-- ------------------------------------------------

Controls.GAME = {};
Controls.GAME.gamepad = {};
Controls.GAME.gamepad.axes = {};
Controls.GAME.gamepad.axes.lXRight   = { cmd = 'RIGHT',  value = 0, rep = true, locked = false };
Controls.GAME.gamepad.axes.lXLeft    = { cmd = 'LEFT',   value = 0, rep = true, locked = false };
Controls.GAME.gamepad.axes.lYUp      = { cmd = 'UP',     value = 0, rep = true, locked = false };
Controls.GAME.gamepad.axes.lYDown    = { cmd = 'DOWN',   value = 0, rep = true, locked = false };

Controls.GAME.gamepad.buttons = {};
Controls.GAME.gamepad.buttons.a      = { cmd = 'BOMB',     rep = false, locked = false };
Controls.GAME.gamepad.buttons.x      = { cmd = 'COL',     rep = false, locked = false };

Controls.GAME.keyboard = {};
Controls.GAME.keyboard.right         = { cmd = 'RIGHT',   rep = true, locked = false };
Controls.GAME.keyboard.left          = { cmd = 'LEFT',    rep = true, locked = false };
Controls.GAME.keyboard.up            = { cmd = 'UP',      rep = true, locked = false };
Controls.GAME.keyboard.down          = { cmd = 'DOWN',    rep = true, locked = false };
Controls.GAME.keyboard[' ']          = { cmd = 'BOMB',    rep = false, locked = false };
Controls.GAME.keyboard['tab']        = { cmd = 'COL',     rep = false, locked = false };

Controls.MENU= {};
Controls.MENU.gamepad = {};
Controls.MENU.gamepad.axes = {};
Controls.MENU.gamepad.axes.lXRight   = { cmd = 'RIGHT',  value = 0, rep = false, locked = false };
Controls.MENU.gamepad.axes.lXLeft    = { cmd = 'LEFT',   value = 0, rep = false, locked = false };
Controls.MENU.gamepad.axes.lYUp      = { cmd = 'UP',     value = 0, rep = false, locked = false };
Controls.MENU.gamepad.axes.lYDown    = { cmd = 'DOWN',   value = 0, rep = false, locked = false };

Controls.MENU.gamepad.buttons = {};
Controls.MENU.gamepad.buttons.a      = { cmd = 'SELECT', rep = false, locked = false };
Controls.MENU.gamepad.buttons.x      = { cmd = 'COL',    rep = false, locked = false };

Controls.MENU.keyboard = {};
Controls.MENU.keyboard.up            = { cmd = 'UP',     rep = false, locked = false };
Controls.MENU.keyboard.down          = { cmd = 'DOWN',   rep = false, locked = false };
Controls.MENU.keyboard.right         = { cmd = 'RIGHT',  rep = false, locked = false };
Controls.MENU.keyboard.left          = { cmd = 'LEFT',   rep = false, locked = false };
Controls.MENU.keyboard['return']     = { cmd = 'SELECT', rep = false, locked = false };
Controls.MENU.keyboard['tab']        = { cmd = 'COL',    rep = false, locked = false };

Controls.LEVELMENU= {};
Controls.LEVELMENU.gamepad = {};
Controls.LEVELMENU.gamepad.axes = {};
Controls.LEVELMENU.gamepad.axes.lXRight   = { cmd = 'RIGHT',  value = 0, rep = true, locked = false };
Controls.LEVELMENU.gamepad.axes.lXLeft    = { cmd = 'LEFT',   value = 0, rep = true, locked = false };
Controls.LEVELMENU.gamepad.axes.lYUp      = { cmd = 'UP',     value = 0, rep = true, locked = false };
Controls.LEVELMENU.gamepad.axes.lYDown    = { cmd = 'DOWN',   value = 0, rep = true, locked = false };

Controls.LEVELMENU.gamepad.buttons = {};
Controls.LEVELMENU.gamepad.buttons.x      = { cmd = 'COL',       rep = false, locked = false };
Controls.LEVELMENU.gamepad.buttons.b      = { cmd = 'BACK',       rep = false, locked = false };

Controls.LEVELMENU.keyboard = {};
Controls.LEVELMENU.keyboard.up            = { cmd = 'UP',     rep = true, locked = false };
Controls.LEVELMENU.keyboard.down          = { cmd = 'DOWN',   rep = true, locked = false };
Controls.LEVELMENU.keyboard.right         = { cmd = 'RIGHT',  rep = true, locked = false };
Controls.LEVELMENU.keyboard.left          = { cmd = 'LEFT',   rep = true, locked = false };
Controls.LEVELMENU.keyboard['tab']        = { cmd = 'COL',    rep = false, locked = false };
Controls.LEVELMENU.keyboard['escape']     = { cmd = 'BACK',   rep = false, locked = false };

return Controls;

--==================================================================================================
-- Created 18.07.14 - 02:13                                                                        =
--==================================================================================================