#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform vec2 u_resolution;
uniform float u_time;

void main(){
  vec2 uv=gl_FragCoord.xy;
  vec2 center=u_resolution.xy*.5;
  float minRes=min(u_resolution.x,u_resolution.y);
  float radius=.1*u_resolution.y/u_resolution.y;

  vec2 normalized = (uv-center)/minRes;
  
  if(abs(normalized.y)>8.*radius){
    discard;
  }
  
  vec3 color=vec3(0.);
  
  // stripes
  // color+=smoothstep(1.1,1.4,mod(u_time+(atan(normalized.y,normalized.x)+PI)/2.*PI*3.,2.));
  // color+=smoothstep(1.1,1.4,mod(-u_time+(-atan(normalized.y,normalized.x)+PI)/2.*PI*3.,2.));
  float atanNormal = atan(normalized.y, normalized.x);
  if(atanNormal < 0.) {
    atanNormal += 2.*PI;
  }
  atanNormal/=(2.*PI);
  color+=step(1.1,mod(u_time+atanNormal,1.4));
  color+=step(1.1,mod(-u_time+(-atan(normalized.y,normalized.x)+PI)/2.*PI*3.,2.));
  
  // circle
  color+=1.-smoothstep(radius, radius+.08, abs(length(normalized)));
  
  gl_FragColor=vec4(color,1);
}