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
vec3 pal(in float t,in vec3 a,in vec3 b,in vec3 c,in vec3 d){
  return a+b*cos(TWO_PI*(c*t+d));
}

vec3 colorful_pal(float norm){
  return pal(norm,vec3(.5,.5,.5),vec3(.5,.5,.5),vec3(1.,1.,1.),vec3(0.,.33,.67));
}

// Returns atan normalized to range 0..1
float atan_norm(float y, float x) {
  return (atan(y,x)+PI)/TWO_PI;
}

vec3 snowflake(vec2 anchor, vec2 uv, float radius) {
  vec2 offset = anchor-uv;
  float atn = atan_norm(offset.y, offset.x)+u_time*.1;
  float segment = floor(atn*8.)/8.;

  float dist = distance(uv, anchor);
  float distSegment = floor(dist*20.)/5.;

  if(dist>radius) {
    return vec3(0.);
  }

  return .3*colorful_pal(fract(segment+distSegment+2.*atn));
}

void main(){
  // uv centered and normalized from -.5 to .5
  vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;

  // scale
  // uv*=10.;

  vec3 col = vec3(0.);
  col += snowflake(vec2(-.02, .14), uv, .1);
  col += snowflake(vec2(.1, -.05), uv, .25);
  col += snowflake(vec2(.15, .3), uv, .5);
  col += snowflake(vec2(-.2, .25), uv, .1);
  col += snowflake(vec2(-.1, .5), uv, .15);
  col += snowflake(vec2(-.1, -.3), uv, .2);

  gl_FragColor=vec4(col, 1.);
}