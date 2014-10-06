/* ================================================================================================== */
/* Copyright (C) 2014 by Robert Machmer                                                               */
/* ================================================================================================== */

extern Image lut;
extern number index;
extern number palettes;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    // Sample the texture.
    vec4 tex = Texel(texture, texture_coords);

    // Get the color from the LUT based on the color of the texture.
    vec4 lut = Texel(lut, vec2(tex.r, index / palettes));

    // Make sure the texture's alpha channel is affected by love.graphics.setColor(...).
    lut.a = tex.a *color.a;

    return lut;
}