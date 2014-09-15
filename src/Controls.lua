--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

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
Controls.MENU.keyboard = {};
Controls.MENU.keyboard.up            = { cmd = 'UP',      rep = true, locked = false };
Controls.MENU.keyboard.down          = { cmd = 'DOWN',    rep = true, locked = false };
Controls.MENU.keyboard[' ']          = { cmd = 'SELECT',  rep = false, locked = false };
Controls.MENU.keyboard['tab']        = { cmd = 'COL',     rep = false, locked = false };

return Controls;

--==================================================================================================
-- Created 18.07.14 - 02:13                                                                        =
--==================================================================================================