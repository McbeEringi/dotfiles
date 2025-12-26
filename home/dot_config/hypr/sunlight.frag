#version 320 es
// https://github.com/hyprwm/Hyprland/blob/75c0675e14655d7a859f184009360bd264806123/src/render/OpenGL.cpp#L1198
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
uniform vec2 screen_size;
out vec4 col;

void main(){
	vec4 x=texture(tex,v_texcoord);

	col=vec4(vec3(1)-clamp(dot(x.rgb,vec3(.299,.587,.114)),0.,1.)*x.a,x.a);
}

