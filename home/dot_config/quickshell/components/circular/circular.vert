#version 440

layout(location=0) in vec4 qt_Vertex;
layout(location=1) in vec2 qt_MultiTexCoord0;

layout(location=0) out vec2 qt_TexCoord0;

layout(std140,binding=0) uniform buf{
	mat4 qt_Matrix;
	float qt_Opacity;
	float ratio;
	float width;
	float height;
};

const float PI2=3.14159265*2.;

void main(){
	vec4 pos=qt_Vertex;
	vec2 uv=qt_MultiTexCoord0;
	float t=(uv.x-.25)*PI2;
	pos.xy=(vec2(cos(t),sin(t))*(1.-uv.y*ratio)*.5+.5)*vec2(width,height);
	gl_Position=qt_Matrix*pos;
	qt_TexCoord0=qt_MultiTexCoord0;
}
