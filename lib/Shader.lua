--==================================================================================================
-- Copyright (C) 2014 by Robert Machmer                                                            =
--==================================================================================================

local ProfileHandler = require('src/profile/ProfileHandler');

-- ------------------------------------------------
-- Module
-- ------------------------------------------------

local Shader = {};

-- ------------------------------------------------
-- Constructor
-- ------------------------------------------------

function Shader.new(path)
    local self = {};

    local shader = love.graphics.newShader(path);
    local profile = ProfileHandler.load();

    function self:set()
        if profile.shaders then
            love.graphics.setShader(shader);
        end
    end

    function self:unset()
        if profile.shaders then
            love.graphics.setShader();
        end
    end

    function self:send(name, value)
        shader:send(name, value);
    end

    return self;
end

-- ------------------------------------------------
-- Return Module
-- ------------------------------------------------

return Shader;

--==================================================================================================
-- Created 22.10.14 - 09:38                                                                        =
--==================================================================================================