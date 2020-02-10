#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main(){
  // uv centered and normalized from -.5 to .5
  vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;
  
  gl_FragColor=vec4(uv, .5+.5*sin(u_time), 1.);
}