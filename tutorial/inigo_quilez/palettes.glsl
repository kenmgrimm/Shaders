#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define TWO_PI 6.28319

uniform vec2 u_resolution;
uniform float u_time;

// http://iquilezles.org/www/articles/palettes/palettes.htm
// https://www.shadertoy.com/view/ll2GD3
vec3 pal(in float t,in vec3 a,in vec3 b,in vec3 c,in vec3 d){
  return a+b*cos(TWO_PI*(c*t+d));
}

vec3 nature_pal(float norm){
  return pal(norm,vec3(.5,.5,.5),vec3(.5,.5,.5),vec3(1.,.7,.4),vec3(0.,.15,.20));
}
vec3 watercolor_pal(float norm){
  return pal(norm,vec3(.8,.5,.4),vec3(.2,.4,.2),vec3(2.,1.,1.),vec3(0.,.25,.25));
}
vec3 translucent_pal(float norm){
  return pal(norm,vec3(.5,.5,.5),vec3(.5,.5,.5),vec3(2.,1.,0.),vec3(.5,.20,.25));
}
vec3 outdoor_pal(float norm) {
  return pal(norm,vec3(.5,.5,.5),vec3(.5,.5,.5),vec3(1.,1.,.5),vec3(.8,.90,.30));
}
vec3 colorful_pal(float norm) {
  return pal(norm,vec3(.5,.5,.5),vec3(.5,.5,.5),vec3(1.,1.,1.),vec3(0.,.33,.67));
}

void main(){
  // uv normalized 0..1
  vec2 uv=gl_FragCoord.xy/u_resolution.x;
  
  // scale
  uv*=1.;
  
  vec3 col = outdoor_pal(uv.x);
  
  gl_FragColor=vec4(col,1.);
}