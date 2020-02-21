/*
* Perlin noise
* https://www.raywenderlich.com/2323-opengl-es-pixel-shaders-tutorial
*/
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float randomNoise(vec2 p){
  return fract(u_time+6791.*sin(47.*p.x+p.y*9973.));
}

void main(){
  vec2 position=gl_FragCoord.xy/u_resolution.xx;
  if((position.x>1.)||(position.y>1.)){
    discard;
  }

  float n=randomNoise(position);
  gl_FragColor=vec4(vec3(n),1.);
}