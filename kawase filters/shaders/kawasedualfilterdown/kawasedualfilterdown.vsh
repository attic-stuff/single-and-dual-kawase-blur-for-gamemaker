/* vertex shader for kawase blur, double filter */
attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 vv_texturecoordinate;
varying vec4 vv_vertexcolor;

void main()	{
	vec4 position = vec4(in_Position.xyz, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * position;
	vv_texturecoordinate = in_TextureCoord;
	vv_vertexcolor = in_Colour;
}