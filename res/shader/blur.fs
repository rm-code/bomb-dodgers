extern number radius = 1.0;
const vec2 dir = vec2(2.0, 2.0);
const number res = 200;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
          vec4 sum = vec4(0.0);
          vec2 tc = texture_coords;
          number blur = radius / res;

          float hstep = dir.x;
          float vstep = dir.y;

          sum += Texel(texture, vec2(tc.x - 4.0 * blur * hstep, tc.y - 4.0 * blur * vstep)) * 0.0162162162;
          sum += Texel(texture, vec2(tc.x - 3.0 * blur * hstep, tc.y - 3.0 * blur * vstep)) * 0.0540540541;
          sum += Texel(texture, vec2(tc.x - 2.0 * blur * hstep, tc.y - 2.0 * blur * vstep)) * 0.1216216216;
          sum += Texel(texture, vec2(tc.x - 1.0 * blur * hstep, tc.y - 1.0 * blur * vstep)) * 0.1945945946;

          sum += Texel(texture, vec2(tc.x, tc.y)) * 0.2270270270;

          sum += Texel(texture, vec2(tc.x + 1.0*blur*hstep, tc.y + 1.0*blur*vstep)) * 0.1945945946;
          sum += Texel(texture, vec2(tc.x + 2.0*blur*hstep, tc.y + 2.0*blur*vstep)) * 0.1216216216;
          sum += Texel(texture, vec2(tc.x + 3.0*blur*hstep, tc.y + 3.0*blur*vstep)) * 0.0540540541;
          sum += Texel(texture, vec2(tc.x + 4.0*blur*hstep, tc.y + 4.0*blur*vstep)) * 0.0162162162;

          return color * vec4(sum.rgb, 1.0);
}