#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define TWO_PI 6.28319
#define SPIRAL_LEN 500.

uniform vec2 u_resolution;
uniform float u_time;

// http://iquilezles.org/www/articles/palettes/palettes.htm
// https://www.shadertoy.com/view/ll2GD3
vec3 pal(in float t,in vec3 a,in vec3 b,in vec3 c,in vec3 d) {
  return a+b*cos(TWO_PI*(c*t+d));
}

vec3 watercolor_pal(float norm) {
  return pal(norm,vec3(.8,.5,.4),vec3(.2,.4,.2),vec3(2.,1.,1.),vec3(0.,.25,.25));
}
vec3 translucent_pal(float norm) {
  return pal(norm,vec3(.5,.5,.5),vec3(.5,.5,.5),vec3(2.,1.,0.),vec3(.5,.20,.25));
}

// Returns atan range 0..TWO_PI
float atan_pos(float y,float x){
  return atan(y,x)+PI;
}

// Returns atan normalized to range 0..1
float atan_norm(float y,float x){
  return atan_pos(y,x)/TWO_PI;
}

void main(){
  // uv centered and normalized from -.5 to .5
  vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;
  float time = -u_time / 4.;

  // scale
  uv*=1.;

  vec3 col = vec3(0.);

  // Single stripe spiral (yellow)
  col+= step(.9, mod(7.*pow(length(uv), .1) + time + atan_norm(uv.y, uv.x), 1.))*vec3(.3,.8,.2);
  // Double spiral gradient
  col+= smoothstep(0.1, 1.4, mod(7.*pow(length(uv), .1) + time + atan_norm(uv.y, uv.x), .5));
  // Thick gradient spiral
  col+= smoothstep(.1, 1.4, mod(7.*pow(length(uv), .1) + time + atan_norm(uv.y, uv.x), 1.));
  // Minimally-twisted spiral
  // col+= smoothstep(0., .3, mod(1.*pow(length(uv), .1) + .1*time + atan_norm(uv.y, uv.x), .1));
  // Straight spiral
  // col+= smoothstep(0., .3, mod(1.*pow(length(uv), .001) + .1*time + atan_norm(uv.y, uv.x), .1));

  col *= vec3(.5, .3, .1); 

  gl_FragColor=vec4(col, 1.);
  }