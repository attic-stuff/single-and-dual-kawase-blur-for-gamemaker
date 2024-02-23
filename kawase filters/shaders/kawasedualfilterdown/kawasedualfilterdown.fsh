/* fragment shader for kawase blur, double filter */
varying vec2 vv_texturecoordinate;
varying vec4 vv_vertexcolor;

uniform float offset;
uniform vec2 halftexel;


void main() {
	vec3 color = vec3(0.0);
	
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate).rgb * 4.0;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + halftexel * offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(halftexel.x, -halftexel.y) * offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate - vec2(halftexel.x, -halftexel.y) * offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate - halftexel * offset).rgb;
	color = color * 0.125;
	
	gl_FragColor = vv_vertexcolor * vec4(color, 1.0);
}