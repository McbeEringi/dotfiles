#version 440
layout(location=0)in vec2 qt_TexCoord0;
layout(location=0)out vec4 fragColor;
layout(std140,binding=0)uniform buf{
	mat4 qt_Matrix;
	float qt_Opacity;
	float time;
	vec2 cursor;
	float button;
	vec2 res;
};
layout(binding=1) uniform sampler2D img;

vec2 hash23(vec3 p3){
	p3 = fract(p3 * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx+33.33);
	return fract((p3.xx+p3.yz)*p3.zy);
}

vec2 perlin(vec3 p){
	vec3 i=floor(p),r=fract(p);
	r=r*r*(3.0-2.0*r);
	vec2
		p000=hash23(i+vec3(0,0,0)),
		p001=hash23(i+vec3(0,0,1)),
		p010=hash23(i+vec3(0,1,0)),
		p011=hash23(i+vec3(0,1,1)),
		p100=hash23(i+vec3(1,0,0)),
		p101=hash23(i+vec3(1,0,1)),
		p110=hash23(i+vec3(1,1,0)),
		p111=hash23(i+vec3(1,1,1));

	return mix(
		mix(mix(p000,p001,r.z),mix(p010,p011,r.z),r.y),
		mix(mix(p100,p101,r.z),mix(p110,p111,r.z),r.y),
		r.x
	);
}

void main(){
	vec4 c=texture(img,qt_TexCoord0
		-(cursor/res-.5)*.01
		// -button*.1

		-((
			perlin(vec3(qt_TexCoord0*res/res.y*vec2(.5,2.)*128.+time*vec2(1,.5),qt_TexCoord0.x+time*.5))+
			perlin(vec3(qt_TexCoord0*res/res.y*vec2(.5,2.)*32.+time*vec2(.5,-.5),qt_TexCoord0.y+(time+.5)*.2))
		)-1.)*mix(mix(.2,0.,button),1.,smoothstep(0.,.5,length(cursor/res-qt_TexCoord0)))*.02
	);
	fragColor=c;//vec4(qt_TexCoord0,1,p.a) * qt_Opacity;
}
