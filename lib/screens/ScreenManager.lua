--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local ScreenManager = {};

-- ------------------------------------------------
-- Module Functions
-- ------------------------------------------------

---
-- Initialise the ScreenManager and
-- @param screen
--
function ScreenManager:init(screen)
    self.stack = {};
    self:push(screen);
end

---
-- Clears the ScreenManager, creates a new screen and switches
-- to it. Use this if you don't want to stack onto other screens.
--
-- @param nscreen
--
function ScreenManager:switch(screen)
    self:clear();
    self:push(screen);
end

---
-- Creates a new screen and pushes it on the screen stack, where
-- it will overlay all the other screens.
-- Screens below the this new screen will be set inactive.
--
-- @param nscreen
--
function ScreenManager:push(nscreen)
    -- Deactivate the previous screen if there is one.
    if self:peek() then
        self:peek():setActive(false);
    end

    -- Create the new screen and initialise it.
    nscreen:init();

    -- Push the new screen onto the stack.
    self.stack[#self.stack + 1] = nscreen;
end

---
-- Returns the screen on top of the screen stack without removing it.
--
function ScreenManager:peek()
    return self.stack[#self.stack];
end

---
-- Removes the topmost screen of the stack
--
function ScreenManager:pop()
    if #self.stack > 1 then
        -- Close the currently active screen.
        self:peek():close();

        -- Remove the now inactive screen from the stack.
        self.stack[#self.stack] = nil;

        -- Activate next screen on the stack.
        self:peek():setActive(true);
    else
        error("Can't close the last screen. Use switch() to clear the screen manager and add a new screen");
    end
end

---
-- Close and remove all screens from the stack.
--
function ScreenManager:clear()
    for i = 1, #self.stack do
        self.stack[i]:close();
        self.stack[i] = nil;
    end
end

---
-- Draw all screens on the stack. Screens that are higher on the stack
-- will overlay screens that are on the bottom.
--
function ScreenManager:draw()
    for i = 1, #self.stack do
        self.stack[i]:draw();
    end
end

---
-- Update all screens on the stack.
--
function ScreenManager:update(dt)
    for i = 1, #self.stack do
        self.stack[i]:update(dt);
    end
end

---
-- Resize all screens on the stack.
-- @param w
-- @param h
--
function ScreenManager:resize(w, h)
    for i = 1, #self.stack do
        self.stack[i]:resize(w, h);
    end
end

---
-- Update all screens on the stack whenever the game window gains or
-- loses focus.
-- @param dfocus
--
function ScreenManager:focus(dfocus)
    for i = 1, #self.stack do
        self.stack[i]:focus(dfocus);
    end
end

---
-- Update all screens on the stack whenever the game window is minimized.
-- @param dvisible
--
function ScreenManager:visible(dvisible)
    for i = 1, #self.stack do
        self.stack[i]:visible(dvisible);
    end
end

---
-- Reroutes the keypressed callback to the currently active screen.
-- @param key
--
function ScreenManager:keypressed(key)
    self:peek():keypressed(key);
end

---
-- Reroutes the keyreleased callback to the currently active screen.
-- @param key
--
function ScreenManager:keyreleased(key)
    self:peek():keyreleased(key);
end

---
-- Reroute the textinput callback to the currently active screen.
-- @param input
--
function ScreenManager:textinput(input)
    self:peek():textinput(input);
end

---
-- Reroute the mousepressed callback to the currently active screen.
-- @param x
-- @param y
-- @param button
--
function ScreenManager:mousepressed(x, y, button)
    self:peek():mousepressed(x, y, button);
end

---
-- Reroute the mousereleased callback to the currently active screen.
-- @param x
-- @param y
-- @param button
--
function ScreenManager:mousereleased(x, y, button)
    self:peek():mousereleased(x, y, button);
end

---
-- Reroute the mousefocus callback to the currently active screen.
-- @param x
-- @param y
-- @param button
--
function ScreenManager:mousefocus(focus)
    self:peek():mousefocus(focus);
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return ScreenManager;

--==================================================================================================
-- Created 02.06.14 - 17:30                                                                        =
--==================================================================================================