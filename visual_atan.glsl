#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define TWO_PI 6.28319
#define SPIRAL_LEN 500.

uniform vec2 u_resolution;
uniform float u_time;

// Returns atan range 0..TWO_PI
float atan_pos(float y, float x) {
  return atan(y, x)+PI;
}

// Returns atan normalized to range 0..1
float atan_norm(float y, float x) {
  return atan_pos(y, x) / TWO_PI;
}

void main(){
  // uv centered and normalized from -.5 to .5
  vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;

  // scale
  uv*=1.;

  vec3 col = vec3(0.);

  // 0..TWO_PI
  float atn = atan_pos(uv.y, uv.x);

  float edge = smoothstep(0., TWO_PI, atn);

  col+=edge;

  gl_FragColor=vec4(col, 1.);
}