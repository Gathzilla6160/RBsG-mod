#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 wildfire;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x), f.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 4; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 tex = Texel(texture, texture_coords);
    vec2 uv = (((texture_coords) * (image_details)) - texture_details.xy * texture_details.ba) / texture_details.ba;

    float t = wildfire.y * 2.221 + time;

    vec2 p = vec2(uv.x * 4.0, uv.y * 3.5 + t * 1.2);
    vec2 warp = vec2(fbm(p + vec2(0.0, t * 0.5)),
                     fbm(p + vec2(5.2, 1.3 - t * 0.4)));
    float heat = fbm(p + warp * 1.8);
    heat += fbm(vec2(uv.x * 10.0, uv.y * 8.0 + t * 2.5)) * 0.25;

    float base  = smoothstep(0.0, 1.0, uv.y);
    float flame = smoothstep(0.25, 0.75, heat + base * 0.35 - 0.1);
    float core  = smoothstep(0.55, 0.95, heat + base * 0.3);

    float lum = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    vec3 greenCard = vec3(lum * 0.25, lum * 0.9, lum * 0.25);
    tex.rgb = mix(tex.rgb, greenCard, 0.75);

    vec3 dark   = vec3(0.00, 0.12, 0.02);
    vec3 mid    = vec3(0.10, 0.85, 0.10);
    vec3 bright = vec3(0.45, 1.00, 0.30);
    vec3 white  = vec3(0.85, 1.00, 0.70);

    vec3 fire = mix(dark, mid, smoothstep(0.0, 0.5, flame));
    fire = mix(fire, bright, smoothstep(0.4, 0.9, flame));
    fire = mix(fire, white, core * 0.7);

    tex.rgb = mix(tex.rgb, fire, flame * 0.85);

    tex.rgb += vec3(0.0, 0.35, 0.05) * (0.3 + 0.7 * heat) * 0.5;

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