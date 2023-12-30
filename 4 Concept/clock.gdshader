shader_type canvas_item;

uniform vec3 face_color : source_color = vec3(1.0);
uniform vec3 second_color : source_color;
uniform vec3 minute_color : source_color;
uniform vec3 hour_color : source_color;

const float RING_THICKNESS = 0.1;
const float SMOOTHING = 1.5;

varying flat vec3 time_data;

void vertex() {
	time_data = COLOR.xyz;
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

#define ADD_RING(color, component) \
	COLOR.rgb = add_ring(COLOR.rgb, color, time_data.component, radius);

void fragment() {
	// Clock face radius at fragment, normalized so it is 1.0 at fade edge.
	float radius = 2.0 * distance(UV, vec2(0.5));
	COLOR.rgb = texture(TEXTURE, UV).rgb;
	ADD_RING(second_color, x)
	ADD_RING(minute_color, y)
	ADD_RING(hour_color, z)
	COLOR.a = smooth_below(1.0, radius);
}
