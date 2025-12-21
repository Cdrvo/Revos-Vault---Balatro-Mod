#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 magnetised;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
	if (dissolve < 0.001) {
		return vec4(shadow ? vec3(0.0) : tex.rgb, shadow ? tex.a * 0.2 : tex.a);
	}

	float adj = (pow(dissolve, 2.0) * (3.0 - 2.0 * dissolve)) * 1.11 - 0.05;

	float t = time * 11.17 + 1007.33;
	vec2 floored_uv = floor(uv * texture_details.ba) / max(texture_details.b, texture_details.a);
	vec2 uv_scaled = (floored_uv - 0.5) * 2.8 * max(texture_details.b, texture_details.a);

	vec2 f1 = uv_scaled + 35. * vec2(sin(t / 97.113), cos(t / 47.91));
	vec2 f2 = uv_scaled + 42. * vec2(cos(-t / 39.1), sin(-t / 27.3));
	vec2 f3 = uv_scaled + 30. * vec2(sin(t / 61.0), cos(t / 85.7));

	float field = (1.0 + (
		sin(length(f1) / 23.7) * cos(f1.y / 14.1) +
		cos(length(f2) / 19.1) * sin(f2.x / 31.4) +
		sin(length(f3) / 17.6)
	)) / 2.0;

	vec2 borders = vec2(0.15, 0.85);

	float res = 0.5 + 0.5 * sin(adj * 0.9 + field * 4.2)
		- (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(6.0 + 4.0*dissolve) : 0.0)*dissolve
		- (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(6.0 + 4.0*dissolve) : 0.0)*dissolve
		- (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(6.0 + 4.0*dissolve) : 0.0)*dissolve
		- (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(6.0 + 4.0*dissolve) : 0.0)*dissolve;

	if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adj + 0.9 * (0.5 - abs(adj - 0.5)) && res > adj) {
		if (res < adj + 0.4 * (0.5 - abs(adj - 0.5))) {
			tex.rgba = burn_colour_1.rgba;
		} else if (burn_colour_2.a > 0.01) {
			tex.rgba = burn_colour_2.rgba;
		}
	}

	return vec4(shadow ? vec3(0.0) : tex.rgb, res > adj ? (shadow ? tex.a * 0.25 : tex.a) : 0.0);
}

number hue(number s, number t, number h)
{
	number hs = mod(h, 1.0) * 6.0;
	if (hs < 1.0) return mix(s, t, hs);
	if (hs < 3.0) return t;
	if (hs < 4.0) return mix(t, s, hs - 3.0);
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.1)
		return vec4(vec3(c.z), c.a);

	number t = c.z < 0.5 ? c.y * c.z + c.z : -c.y * c.z + c.y + c.z;
	number s = 2.0 * c.z - t;
	return vec4(hue(s, t, c.x + 1.0 / 3.0), hue(s, t, c.x), hue(s, t, c.x + 1.0 - 3.0), c.w);
}

vec4 HSL(vec4 c)
{
	number low = min(c.r, min(c.g, c.b));
	number high = max(c.r, max(c.g, c.b));
	number delta = high - low;
	number sum = high + low;

	vec4 hsl = vec4(0.0, 0.0, 0.5 * sum, c.a);
	if (delta == 0.0)
		return hsl;

	hsl.y = (hsl.z < 0.5) ? delta / sum : delta / (2.0 - sum);
	hsl.x = high == c.r ? (c.g - c.b) / delta :
	         high == c.g ? (c.b - c.r) / delta + 2.0 :
	                      (c.r - c.g) / delta + 4.0;
	hsl.x = mod(hsl.x / 6.0, 1.0);

	return hsl;
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (texture_coords * image_details - texture_details.xy * texture_details.ba) / texture_details.ba;

	number low = min(tex.r, min(tex.g, tex.b));
	number high = max(tex.r, max(tex.g, tex.b));
	number delta = high - low;

	number sat_mod = 1.0 - max(0.0, 0.08 * (1.2 - delta));
	vec4 hsl = HSL(vec4(tex.r * sat_mod, tex.g * sat_mod, tex.b, tex.a));

	float t = time * 1.727 + magnetised.y * 3.138;
	vec2 floored_uv = floor(uv * texture_details.ba) / texture_details.ba;
	vec2 uv_scaled = (floored_uv - 0.5) * 40.0;

	vec2 f1 = uv_scaled + 32. * vec2(cos(t / 137.0), sin(t / 63.0));
	vec2 f2 = uv_scaled + 36. * vec2(sin(-t / 49.2), cos(-t / 45.0));
	vec2 f3 = uv_scaled + 28. * vec2(cos(t / 27.0), sin(t / 71.0));

	float field = (1.0 + (
		cos(length(f1) / 15.5) * sin(f1.x / 23.1) +
		sin(length(f2) / 19.7) * cos(f2.y / 28.3) +
		cos(length(f3) / 21.6)
	)) / 2.0;

	float res = 0.5 + 0.5 * sin(magnetised.x * 3.145 + field * 6.283);

	hsl.x = 0.66 + 0.1 * sin(res * 6.283 + time);
	hsl.y = min(1.0, hsl.y + 0.5 * (0.5 + 0.5 * sin(time * 0.5 + res * 10.0)));
	hsl.z = clamp(hsl.z + 0.1 * sin(field * 8.0 + time * 0.6), 0.0, 1.0);

	tex.rgb = RGB(hsl).rgb;
	if (tex.a < 0.6)
		tex.a *= 0.3;

	return dissolve_mask(tex * colour, texture_coords, uv);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	if (hovering <= 0.0) {
		return transform_projection * vertex_position;
	}

	float mid = length(vertex_position.xy - 0.5 * love_ScreenSize.xy) / length(love_ScreenSize.xy);
	vec2 offset = (vertex_position.xy - mouse_screen_pos.xy) / screen_scale;
	float s = 0.2 * (-0.04 - 0.4 * max(0.0, 0.25 - mid)) * hovering * dot(offset, offset) / (1.8 - mid);

	return transform_projection * vertex_position + vec4(0.0, 0.0, 0.0, s);
}
#endif
