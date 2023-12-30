shader_type canvas_item;

uniform vec3 second_color : source_color = vec3(0.5, 0.0, 0.0);
uniform vec3 minute_color : source_color = vec3(0.0, 0.5, 0.0);
uniform vec3 hour_color : source_color = vec3(0.0, 0.0, 0.5);

const float RING_THICKNESS = 0.1;
const float SMOOTHING = 1.5;

varying flat vec4 clock_data;

void vertex() {
	clock_data = COLOR;
}

float smooth_above(float threshold, float value) {
	return smoothstep(threshold, threshold + fwidth(SMOOTHING * value), value);
}

float smooth_below(float threshold, float value) {
	return smoothstep(threshold, threshold - fwidth(SMOOTHING * value), value);
}

float get_ring_weight(float start_radius, float radius) {
	return (
			smooth_above(start_radius, radius) *
			smooth_below(start_radius + RING_THICKNESS, radius)
	);
}

vec3 add_ring(vec3 color, vec3 ring_color, float start_radius, float radius) {
	return mix(color, ring_color, get_ring_weight(start_radius, radius));
}

void fragment() {
	// Clock radius at fragment, normalized so it is 1.0 at its face edge.
	float radius = 2.0 * distance(UV, vec2(0.5));
	float choice = clock_data.w;
	COLOR.rgb = texture(
			TEXTURE,
			vec2(
					choice > 0.5 ? UV.x : 1.0 - UV.x,
					choice < 0.25 || choice > 0.75 ? UV.y : 1.0 - UV.y
			)
	).rgb;
	COLOR.rgb = add_ring(COLOR.rgb, second_color, clock_data.x, radius);
	COLOR.rgb = add_ring(COLOR.rgb, minute_color, clock_data.y, radius);
	COLOR.rgb = add_ring(COLOR.rgb, hour_color, clock_data.z, radius);
	COLOR.a = smooth_below(1.0, radius);
}
