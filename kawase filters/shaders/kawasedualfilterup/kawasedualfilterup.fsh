/* fragment shader for kawase blur, double filter */
varying vec2 vv_texturecoordinate;
varying vec4 vv_vertexcolor;

uniform float spread;
uniform vec2 texelsize;

void main() {
	vec2 halftexel = texelsize * 0.5;
	
	vec3 color = vec3(0.0);
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(texelsize.x, 0.0) * spread).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(halftexel.x, -halftexel.y) * spread).rgb * 2.0;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(0.0, -texelsize.y) * spread).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(-halftexel.x, -halftexel.y) * spread).rgb * 2.0;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(-texelsize.x, 0.0) * spread).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(-halftexel.x, halftexel.y) * spread).rgb * 2.0;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(0.0, texelsize.y) * spread).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(halftexel.x, halftexel.y) * spread).rgb * 2.0;
	
	color = color * 0.083333333333333;
	
	gl_FragColor = vv_vertexcolor * vec4(color, 1.0);
}