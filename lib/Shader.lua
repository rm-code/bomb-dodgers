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