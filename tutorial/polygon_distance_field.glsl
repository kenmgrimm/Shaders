#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform float u_time;

// Reference to
// http://thndl.com/square-shaped-shaders.html

void main(){
  // uv centered and resized to min resolution
  // min res resizes to -.5...5, no chopping
  // max res will be >.5
  float minRes=min(u_resolution.x,u_resolution.y);
  vec2 st=(gl_FragCoord.xy-.5*u_resolution.xy)/minRes;

  vec3 color=vec3(0.);
  float d=0.;
  
  // st*=2.;
  
  // Number of sides of your shape
  int N=5;
  
  // Angle and radius from the current pixel
  float a=atan(st.x,st.y)+PI;
  float r=TWO_PI/float(N);
  
  // Shaping function that modulates the distance
  d=cos(floor(.5+a/r)*r-a)*length(st);
  
  color=vec3(1.-smoothstep(.2,.21,d));
  // color = vec3(d);
  
  gl_FragColor=vec4(color,1.);
}
