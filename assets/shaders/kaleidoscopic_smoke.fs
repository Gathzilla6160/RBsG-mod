#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

// must match the shader key (the game sends it without the mod prefix)
// .x = tilt/hover-driven value (NOT used), .y = steady real-time clock in seconds
extern MY_HIGHP_OR_MEDIUMP vec2 kaleidoscopic_smoke;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

// ---- settings ----
const float OPACITY      = 0.7;    // 1.0 = pattern only, lower = more of the card art shows through
const float LOOP_SECONDS = 10.0;    // the original pattern loops every 10 seconds
const float CARD_AR      = 0.7474;  // card width / height (71 / 95)
const float ZOOM         = 4;     // >1 zooms in, <1 zooms out
const float CONTRAST     = 1.5;     // the original pattern is soft; try 1.5 - 2.5 for a punchier look
const int   LAYERS       = 8;       // original = 8. Lower (5-6) is faster but changes the look

const float SK_PI = 3.14159265359;
const vec3  cs = vec3(1., 2., 3.);
const mat2  R45 = mat2(0.70710678, 0.70710678, -0.70710678, 0.70710678);

vec3 c2(vec2 uv, float t) {
    vec3 col = vec3(0.);
    vec2 ov = uv;
    for (int i = 0; i < 13; i++) {
        uv = abs(uv) - 0.2;
    }
    for (int i = 0; i < 44; i++) {
        uv.x += sin(uv.y*122. + uv.x*-4. + t + ov.y*4. + uv.y*8.) * 0.003;
        uv *= R45;
    }
    col += 1.0 - smoothstep(0.0, 0.5, abs(uv.x + sin(uv.y*20.)*0.4));
    col += sin(uv.x*10. + cs + t) * 0.2;
    return col;
}

vec3 c1(vec2 uv, float t, float tm) {
    vec3 col = vec3(0.);
    vec2 ov = uv;
    for (int i = 0; i < 44; i++) {
        uv.x += sin(uv.y*122. + uv.x*-4. + t + ov.y*4. + uv.y*8.) * 0.003;
        uv *= R45;
    }
    col += 1.0 - smoothstep(0.0, 0.5, abs(uv.x + sin(uv.y*20.)*0.4));
    col += sin(uv.x*10. + cs + t) * 0.2;
    vec3 cx = c2(ov, t);
    col = mix(cx, col, sin(tm)*0.5 + 0.5);
    return col;
}

// p = position on the card (0..1), tm = time in radians (one loop = 2*SK_PI)
vec3 sk_pattern(vec2 p, float tm) {
    vec2 uv = p - 0.5;
    uv.x *= CARD_AR;
    uv /= ZOOM;
    vec3 col = vec3(0.);
    for (int i = 0; i < LAYERS; i++) {
        float ii  = float(i);
        float fi  = fract(ii/6. + tm/SK_PI/2.);
        float f2  = fract(ii/6. + tm/SK_PI/2. + 0.5);
        float afi = abs(fi - 0.5) * 2.;
        float nf2 = 1. - f2;
        float nafi = 1. - afi;
        vec2 av = uv + sin(uv.yx*6. + ii*SK_PI/3. + tm) * 0.02 * pow(nf2, 4.);
        uv.y += 0.1;
        uv.y += 0.02 * sin(tm + ii);
        vec3 c = c1(av, ii*0.5 + tm*-2., tm) * afi
               * (1. - (sin(sin(av.x*4. + afi + ii*3.)*4. + sin(av.y*3. + ii)*4. + nafi*3. + ii)*0.5 + 0.5));
        col += c;
    }
    col *= 0.2;
    col += 0.3;
    return col;
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

    float t  = kaleidoscopic_smoke.y + time;
    float tm = t * 2.0 * SK_PI / LOOP_SECONDS;

    if (!shadow) {
        vec3 col = sk_pattern(uv, tm);
        col = clamp((col - 0.5) * CONTRAST + 0.5, 0.0, 1.0);

        tex.rgb = mix(tex.rgb, col, OPACITY);
    }

    return dissolve_mask(tex * colour, texture_coords, uv);
}

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a * 0.3 : tex.a);
    }

    float adjusted_dissolve = (dissolve * dissolve * (3. - 2. * dissolve)) * 1.02 - 0.01;

    float t = time * 10.0 + 2003.;
    vec2 floored_uv = (floor((uv * texture_details.ba))) / max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

    vec2 field_part1 = uv_scaled_centered + 50. * vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50. * vec2(cos(t / 53.1532), cos(t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50. * vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1. + (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92))) / 2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5 * cos((adjusted_dissolve) / 82.612 + (field + -.5) * 3.14))
        - (floored_uv.x > borders.y ? (floored_uv.x - borders.y) * (5.5 * (1. - adjusted_dissolve)) : 0.)
        - (floored_uv.y > borders.y ? (floored_uv.y - borders.y) * (5.5 * (1. - adjusted_dissolve)) : 0.)
        - (floored_uv.x < borders.x ? (borders.x - floored_uv.x) * (5.5 * (1. - adjusted_dissolve)) : 0.)
        - (floored_uv.y < borders.x ? (borders.x - floored_uv.y) * (5.5 * (1. - adjusted_dissolve)) : 0.);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a * 0.3 : tex.a) : .0);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    if (hovering <= 0.) {
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5 * love_ScreenSize.xy) / length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy) / screen_scale;
    float scale = 0.2 * (-0.03 - 0.3 * max(0., 0.3 - mid_dist))
        * hovering * (length(mouse_offset) * length(mouse_offset)) / (2. - mid_dist);

    return transform_projection * vertex_position + vec4(0, 0, 0, scale);
}
#endif
