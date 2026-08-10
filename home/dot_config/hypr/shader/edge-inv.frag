#version 320 es
// https://github.com/hyprwm/Hyprland/blob/75c0675e14655d7a859f184009360bd264806123/src/render/OpenGL.cpp#L1198
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
uniform vec2 screen_size;
out vec4 col;

vec4 get(float x,float y){return texture(tex,v_texcoord+vec2(x,y)/screen_size);}

void main(){
	float d=1.;
	vec4 x=get(0.,0.);

	col=vec4((1.-pow(max(
		abs(x-get(d,0.)),
		abs(x-get(0.,d))
	).rgb,vec3(.7)))*x.a,x.a);
}
