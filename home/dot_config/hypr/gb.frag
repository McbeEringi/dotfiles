#version 320 es
// https://github.com/hyprwm/Hyprland/blob/75c0675e14655d7a859f184009360bd264806123/src/render/OpenGL.cpp#L1198
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
uniform vec2 screen_size;
out vec4 col;

vec3 gb(vec3 col){
	float step=4.;
	vec3 panel_col=vec3(.6,.8,.2);

	float gray=clamp(dot(col,vec3(.298912,.586611,.114478)),.01,1.);
	return panel_col*ceil(gray*step)/step;
}

void main(){
	vec4 x=texture(tex,v_texcoord);
	col=vec4(gb(x.rgb)*x.a,x.a);
}

