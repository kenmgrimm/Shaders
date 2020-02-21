/*
* Smooth noise - half-neighbor average interpolated noise on sphere
* https://www.raywenderlich.com/2323-opengl-es-pixel-shaders-tutorial
*/
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

const vec3 cLight=normalize(vec3(.5,.5,1.));

void main(){
  vec2 st=gl_FragCoord.xy/u_resolution;
  vec2 center=vec2(u_resolution.x/2.,u_resolution.y/2.);
  
  float radius=u_resolution.x/2.;
  
  vec2 position=gl_FragCoord.xy-center;
  float z=sqrt(radius*radius-position.x*position.x-position.y*position.y);
  
  vec3 normal=normalize(vec3(position.x,position.y,z));
  
  vec3 color=vec3(1.);
  
  if(length(position)>radius){
    discard;
  }
  
  float diffuse=max(0.,dot(normal,cLight));
  
  gl_FragColor=vec4(vec3(diffuse),1.);
}