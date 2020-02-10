#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define PETALS 5.

uniform vec2 u_resolution;
uniform float u_time;

void main(){
  // uv centered and normalized from -.5 to .5
  vec2 uv = (gl_FragCoord.xy-.5*u_resolution.xy) / u_resolution.y;

  vec2 st = vec2(atan(uv.x, uv.y), length(uv));

  uv = vec2(st.x/6.2831+.5, st.y);

  float x = uv.x*PETALS;
  float m = min(fract(x), fract(1.-x));
  float c = smoothstep(0., .1, m*.3+.2-uv.y);
  
  gl_FragColor=vec4(c);
}