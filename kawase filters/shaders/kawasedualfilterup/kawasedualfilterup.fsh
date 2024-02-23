/* fragment shader for kawase blur, double filter */
varying vec2 vv_texturecoordinate;
varying vec4 vv_vertexcolor;

uniform float offset;
uniform vec2 halftexel;

void main() {
	vec2 texel = halftexel * 2.0;
	
	vec3 color = vec3(0.0);
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(texel.x, 0.0)	* offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(halftexel.x, -halftexel.y) * offset).rgb * 2.0;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(0.0, -texel.y) * offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(-halftexel.x, -halftexel.y) * offset).rgb * 2.0;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(-texel.x, 0.0) * offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(-halftexel.x, halftexel.y) * offset).rgb * 2.0;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(0.0, texel.y)	* offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(halftexel.x, halftexel.y)	* offset).rgb * 2.0;
	
	color = color * 0.083333333333333;
	
	gl_FragColor = vv_vertexcolor * vec4(color, 1.0);
}