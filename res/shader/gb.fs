/* ================================================================================================== */
/* Copyright (C) 2014 by Robert Machmer                                                               */
/* ================================================================================================== */

extern vec3 PALETTE[4];

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 tex = Texel(texture, texture_coords);

    // Replace the greyscale colours with the colours of the given palette.
    if (tex.r == 0.12549019607843 && tex.g == 0.27450980392157 && tex.b == 0.1921568627451) {
        tex.r = PALETTE[0][0];
        tex.g = PALETTE[0][1];
        tex.b = PALETTE[0][2];
    } else if (tex.r == 0.32156862745098 && tex.g == 0.49803921568627 && tex.b == 0.22352941176471) {
        tex.r = PALETTE[1][0];
        tex.g = PALETTE[1][1];
        tex.b = PALETTE[1][2];
    } else if (tex.r == 0.6823529411764706 && tex.g == 0.7686274509803922 && tex.b == 0.2509803921568627) {
        tex.r = PALETTE[2][0];
        tex.g = PALETTE[2][1];
        tex.b = PALETTE[2][2];
    } else if (tex.r == 0.84313725 && tex.g == 0.90980392 && tex.b == 0.58039216) {
        tex.r = PALETTE[3][0];
        tex.g = PALETTE[3][1];
        tex.b = PALETTE[3][2];
    }

    // Make sure the texture's alpha channel is affected by love.graphics.setColor(...).
    tex.a *= color.a;

    return tex;
}