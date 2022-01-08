shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform float smooth_size : hint_range(0.0, 1.0);
uniform sampler2D mask : hint_albedo;

void fragment()
{
	float value = texture(mask, UV).r;
	float alpha = smoothstep(cutoff, cutoff + smooth_size, value * (1.0 - smooth_size) + smooth_size);
	vec4 color = texture(TEXTURE, UV);
	COLOR = vec4(color.rgb, color.a * alpha);
}