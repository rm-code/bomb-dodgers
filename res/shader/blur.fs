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

uniform float radius;
const vec2 dir = vec2(2.0, 2.0);
const float res = 200.0;

vec4 effect( vec4 color, sampler2D texture, vec2 texture_coords, vec2 screen_coords )
{
          vec4 sum = vec4(0.0);
          vec2 tc = texture_coords;
          float blur = radius / res;

          float hstep = dir.x;
          float vstep = dir.y;

          sum += texture2D(texture, vec2(tc.x - 4.0 * blur * hstep, tc.y - 4.0 * blur * vstep)) * 0.0162162162;
          sum += texture2D(texture, vec2(tc.x - 3.0 * blur * hstep, tc.y - 3.0 * blur * vstep)) * 0.0540540541;
          sum += texture2D(texture, vec2(tc.x - 2.0 * blur * hstep, tc.y - 2.0 * blur * vstep)) * 0.1216216216;
          sum += texture2D(texture, vec2(tc.x - 1.0 * blur * hstep, tc.y - 1.0 * blur * vstep)) * 0.1945945946;

          sum += texture2D(texture, vec2(tc.x, tc.y)) * 0.2270270270;

          sum += texture2D(texture, vec2(tc.x + 1.0*blur*hstep, tc.y + 1.0*blur*vstep)) * 0.1945945946;
          sum += texture2D(texture, vec2(tc.x + 2.0*blur*hstep, tc.y + 2.0*blur*vstep)) * 0.1216216216;
          sum += texture2D(texture, vec2(tc.x + 3.0*blur*hstep, tc.y + 3.0*blur*vstep)) * 0.0540540541;
          sum += texture2D(texture, vec2(tc.x + 4.0*blur*hstep, tc.y + 4.0*blur*vstep)) * 0.0162162162;

          return color * vec4(sum.rgb, 1.0);
}
