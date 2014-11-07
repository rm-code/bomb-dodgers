/*===============================================================================*/
/*                                                                               */
/* Copyright (c) 2014 Robert Machmer                                             */
/*                                                                               */
/* This software is provided 'as-is', without any express or implied             */
/* warranty. In no event will the authors be held liable for any damages         */
/* arising from the use of this software.                                        */
/*                                                                               */
/* Permission is granted to anyone to use this software for any purpose,         */
/* including commercial applications, and to alter it and redistribute it        */
/* freely, subject to the following restrictions:                                */
/*                                                                               */
/*  1. The origin of this software must not be misrepresented; you must not      */
/*      claim that you wrote the original software. If you use this software     */
/*      in a product, an acknowledgment in the product documentation would be    */
/*      appreciated but is not required.                                         */
/*  2. Altered source versions must be plainly marked as such, and must not be   */
/*      misrepresented as being the original software.                           */
/*  3. This notice may not be removed or altered from any source distribution.   */
/*                                                                               */
/*===============================================================================*/

extern number time = 0.0;
const number size = 32.0;
const number strength = 8.0;
const vec2 res = vec2(512.0, 512.0);

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
    float tmp = sin(sqrt(pow(texture_coords.x * size - size / 2.0, 2.0) + pow(texture_coords.y * size - size / 2.0, 2.0)) - time * 16.0);
    vec2 uv = vec2(texture_coords.x - tmp * strength / 1024.0, texture_coords.y - tmp * strength / 1024.0);
    vec4 col = vec4(texture2D(texture, uv).x, texture2D(texture, uv).y, texture2D(texture, uv).z, texture2D(texture, uv).a);

    return col;
}
