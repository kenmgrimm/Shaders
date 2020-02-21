#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// Reference to
// http://thndl.com/square-shaped-shaders.html

void main(){
  float minRes = min(u_resolution.x, u_resolution.y);
  vec2 st=gl_FragCoord.xy/minRes;
  vec3 color=vec3(0.);
  float d=0.;
  
  // Remap the space to -1. to 1.
  st=st*2.-1.;
  // st*=10.;
  
  // Number of sides of your shape
  int N=3;
  
  // Angle and radius from the current pixel
  float a=atan(st.x,st.y)+PI;
  float r=TWO_PI/float(N);
  
  // Shaping function that modulate the distance
  d=cos(floor(.5+a/r)*r-a)*length(st);
  
  color=vec3(1.-smoothstep(.4,.41,d));
  // color = vec3(d);
  
  gl_FragColor=vec4(color,1.);
}
