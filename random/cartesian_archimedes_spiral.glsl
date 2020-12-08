#ifdef GL_ES
precision mediump float;
#endif

#define TWO_PI 6.28319
#define SPIRAL_LEN 500.

uniform vec2 u_resolution;
uniform float u_time;

void main(){
  // uv centered and normalized from -.5 to .5
  vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;

  // scale
  uv*=1.;

  vec3 col = vec3(0.);

  // Outline - double archimedes spiral
  // https://math.stackexchange.com/questions/2622447/archimedean-spiral-in-cartesian-coordinates
  col += step(.01, abs(uv.y-uv.x*(tan(sqrt(SPIRAL_LEN*pow(uv.x,2.)+SPIRAL_LEN*pow(uv.y,2.))))));

  gl_FragColor=vec4(col, 1.);
}