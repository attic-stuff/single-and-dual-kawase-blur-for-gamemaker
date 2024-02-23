/* fragment shader for kawase single filter */

varying vec2 vv_uv;
varying vec4 vv_vertexcolor;

uniform float offset;

void main() {

	vec3 color = vec3(0.0);
	
	color = color + texture2D(gm_BaseTexture, vv_uv - offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_uv + offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_uv + vec2(-offset, offset)).rgb;
	color = color + texture2D(gm_BaseTexture, vv_uv + vec2(offset, -offset)).rgb;
	
	color = color * 0.25;
	
	gl_FragColor = vv_vertexcolor * vec4(color, 1.0);
}