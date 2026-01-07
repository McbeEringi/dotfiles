#version 320 es
// https://github.com/hyprwm/Hyprland/blob/75c0675e14655d7a859f184009360bd264806123/src/render/OpenGL.cpp#L1198
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
uniform vec2 screen_size;
out vec4 col;

vec3 rgb2hsv(vec3 c){
	vec4 K=vec4(0.,-1./3.,2./3.,-1.);
	vec4 p=mix(vec4(c.bg,K.wz),vec4(c.gb,K.xy),step(c.b,c.g));
	vec4 q=mix(vec4(p.xyw,c.r),vec4(c.r,p.yzx),step(p.x,c.r));

	float d=q.x-min(q.w,q.y);
	float e=1.0e-10;
	return vec3(abs(q.z+(q.w-q.y)/(6.*d+e)),d/(q.x+e),q.x);
}

vec3 hsv2rgb(vec3 c){
	vec4 K=vec4(1.,2./3.,1./3.,3.);
	vec3 p=abs(fract(c.xxx+K.xyz)*6.-K.www);
	return c.z*mix(K.xxx,clamp(p-K.xxx,0.,1.),c.y);
}

void main(){
	vec4 x=texture(tex,v_texcoord);
	vec3 hsv=rgb2hsv(x.rgb);

	col=vec4(hsv2rgb(vec3(hsv.xy*vec2(1.,.2),1.-hsv.z))*x.a,x.a);
	// col=vec4((vec3(1)-clamp(dot(x.rgb,vec3(.299,.587,.114)),0.,1.))*x.a,x.a);
}

