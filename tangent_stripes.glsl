#ifdef GL_ES
precision mediump float;
#endif

#define TWO_PI 6.282
#define PI 3.14159

#define ANIMATE true

uniform vec2 u_resolution;
uniform float u_time;

void main(){
  vec2 uv=gl_FragCoord.xy;
  vec2 center=u_resolution.xy*.5;
  float minRes=min(u_resolution.x,u_resolution.y);
  float radius=.1*u_resolution.y/u_resolution.y;

  uv = (uv-center)/minRes;

  // uv *= .01;

  float time = ANIMATE ? u_time : 0.;

  float glow = .2 * (sin(5.*u_time)+PI)/TWO_PI;
  
  if(abs(uv.y)>8.*radius){
    discard;
  }
  
  vec3 color=vec3(0.);
  
  float atanNormal = atan(uv.y, uv.x)/TWO_PI;
  // gradient rays
  color+=smoothstep(0.,.2,mod(.2*time+atanNormal,.2));
  
  // glowing circle
  color+=1.-smoothstep(radius, radius+glow, abs(length(uv)));
  
  gl_FragColor=vec4(color,1);
}