/* ================================================================================================== */
/* Copyright (C) 2014 by Robert Machmer                                                               */
/* ================================================================================================== */

extern vec3 PALETTE[4];

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);

    // Replace the greyscale colours with the colours of the given palette.
    if (tex.r == 0 && tex.g == 0 && tex.b == 0) {                   // Black
        tex.r = PALETTE[0][0];
        tex.g = PALETTE[0][1];
        tex.b = PALETTE[0][2];
    } else if (tex.r == 1.0 && tex.g == 1.0 && tex.b == 1.0) {      // White
        tex.r = PALETTE[1][0];
        tex.g = PALETTE[1][1];
        tex.b = PALETTE[1][2];
    } else if (tex.r >= 0.5 && tex.g >= 0.5 && tex.b >= 0.5) {      // Light Gray
        tex.r = PALETTE[2][0];
        tex.g = PALETTE[2][1];
        tex.b = PALETTE[2][2];
    } else if (tex.r >= 0.2 && tex.g >= 0.2 && tex.b >= 0.2) {      // Dark Gray
        tex.r = PALETTE[3][0];
        tex.g = PALETTE[3][1];
        tex.b = PALETTE[3][2];
    }

    // Make sure the texture's alpha channel is affected by love.graphics.setColor(...).
    tex.a *= color.a;

    return tex;
}