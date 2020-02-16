#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define TWO_PI 6.28319
#define SPIRAL_LEN 500.

uniform vec2 u_resolution;
uniform float u_time;

// Returns atan normalized to range 0..1
float atan_norm(float y, float x) {
  return (atan(y,x)+PI)/TWO_PI;
}

vec3 web(vec2 anchor, vec2 uv, float radius) {
  vec2 offset = anchor-uv;
  float atn = atan_norm(offset.y, offset.x);
  float segment = floor(atn*10.)/10.;

  float dist = distance(uv, anchor);
  float distSegment = floor(dist*10.)/10.;

  if(mod(atn, .1) < .002) {
    if(abs(dist- distSegment) < 0.02) {
      return vec3(1.,1.,.1);
    }
    return vec3(1.,.3,.3);
  }

  if(dist-distSegment < .01) {
    return vec3(.8,1.,.8);
  }

  if(dist>radius) {
    return vec3(0.);
  }

  return vec3(fract(segment+distSegment));
}

void main(){
  // uv centered and normalized from -.5 to .5
  vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;

  // scale
  uv*=2.;

  vec3 col = vec3(0.);
  col += web(vec2(.0, .0), uv, .9);

  gl_FragColor=vec4(col, 1.);
}