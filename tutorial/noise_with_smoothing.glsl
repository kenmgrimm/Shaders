/*
* Smooth noise - half-neighbor average
* https://www.raywenderlich.com/2323-opengl-es-pixel-shaders-tutorial
*/
#ifdef GL_ES
precision mediump float;
#endif

#define tiles 8.

uniform vec2 u_resolution;
uniform float u_time;

float randomNoise(vec2 p){
  return fract(6791.*sin(47.*p.x+p.y*9973.));
}

// Half-neighbor average
float smoothNoise(vec2 p){
  vec2 nn=vec2(p.x,p.y+1.);
  vec2 ee=vec2(p.x+1.,p.y);
  vec2 ss=vec2(p.x,p.y-1.);
  vec2 ww=vec2(p.x-1.,p.y);
  vec2 cc=vec2(p.x,p.y);
  
  float sum=0.;
  sum+=randomNoise(nn)/8.;
  sum+=randomNoise(ee)/8.;
  sum+=randomNoise(ss)/8.;
  sum+=randomNoise(ww)/8.;
  sum+=randomNoise(cc)/2.;
  
  return sum;
}

void main(void){
  vec2 position=gl_FragCoord.xy/u_resolution.xx;
  position=floor(position*tiles);
  float n=smoothNoise(position);
  gl_FragColor=vec4(vec3(n),1.);
}
