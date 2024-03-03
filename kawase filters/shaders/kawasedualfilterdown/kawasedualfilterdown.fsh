/* fragment shader for kawase blur, double filter */
varying vec2 vv_texturecoordinate;
varying vec4 vv_vertexcolor;

uniform float spread;
uniform vec2 texelsize;

const float multiplier = 0.3; //a true kawase blur uses 0.5, but 0.3 looks better thanks xor.

void main() {
	vec3 color = vec3(0.0);
	
	vec2 halftexel = texelsize * multiplier;
	
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate).rgb * 4.0;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + halftexel * spread).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(halftexel.x, -halftexel.y) * spread).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate - vec2(halftexel.x, -halftexel.y) * spread).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate - halftexel * spread).rgb;
	color = color * 0.125;
	
	gl_FragColor = vv_vertexcolor * vec4(color, 1.0);
}