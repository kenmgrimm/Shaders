#ifdef GL_ES
precision mediump float;
#endif

#define TWO_PI 6.282
#define PI 3.14159

#define ANIMATE true
#define SPEED .5

uniform vec2 u_resolution;
uniform float u_time;

void main(){
  vec2 uv=gl_FragCoord.xy;
  vec2 center=u_resolution.xy*.5;
  float minRes=min(u_resolution.x,u_resolution.y);
  float radius=.1*u_resolution.y/u_resolution.y;

  uv = (uv-center)/minRes;

  // uv *= .8;

  float time = ANIMATE ? SPEED*u_time : 0.;
  float fanTime = 2.*(time+sin(time));

  float glow = .2 * (sin(5.*u_time)+PI)/TWO_PI;
  
  if(abs(uv.y)>8.*radius){
    discard;
  }
  
  vec3 color=vec3(0.);
  
  float atanNormal = (PI + atan(uv.y, uv.x))/TWO_PI;
  // gradient rays
  color+=smoothstep(0.,.2,mod(sin(PI*fract(fanTime+atanNormal)/PI),.18));

  // straight blades
  // float bladeWidth = .75;
  // color+=step((1.-bladeWidth)*.2,mod(fract(atanNormal+time),.1));
  
  // glowing circle
  color+=1.-smoothstep(radius, radius+glow, abs(length(uv)));
  
  gl_FragColor=vec4(color,1);
}