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
	float[16] m=float[](
		0.,8.,2.,10.,
		12.,4.,14.,6.,
		3.,11.,1.,9.,
		15.,7.,13.,5.
	);

	int grid=int(dot(floor(fract(v_texcoord*screen_size*.25)*4.),vec2(1,4)));
	float gray=dot(col,vec3(.299,.587,.114));
	gray=clamp(gray*2.-1.+(m[grid]+.5)*.0625,.01,1.);

	return panel_col*ceil(gray*step)/step;
}

void main(){
	vec4 x=texture(tex,v_texcoord);
	col=vec4(gb(x.rgb)*x.a,x.a);
}

