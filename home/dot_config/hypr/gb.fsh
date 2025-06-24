precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

vec3 gb(vec3 col){
	float step=4.;
	vec3 panel_col=vec3(.6,.8,.2);

	float gray=clamp(dot(col,vec3(.298912,.586611,.114478)),.001,1.);
	return panel_col*ceil(gray*step)/step;
}

void main(){
	vec4 x=texture2D(tex,v_texcoord);
	gl_FragColor=vec4(gb(x.rgb),x.a);
}
