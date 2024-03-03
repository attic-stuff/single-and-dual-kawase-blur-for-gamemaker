/* fragment shader for kawase blur, single filter */
varying vec2 vv_texturecoordinate;
varying vec4 vv_vertexcolor;

uniform float distances;
uniform vec2 texelsize;

const float multiplier = 0.3; //a true kawase blur uses 0.5, but 0.3 looks better thanks xor.

void main() {

	vec2 offset = (multiplier + distances) * texelsize;

	vec3 color = vec3(0.0);
	
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate - offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + offset).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(-offset.x, offset.y)).rgb;
	color = color + texture2D(gm_BaseTexture, vv_texturecoordinate + vec2(offset.x, -offset.y)).rgb;
	
	color = color * 0.25;
	
	gl_FragColor = vv_vertexcolor * vec4(color, 1.0);
}