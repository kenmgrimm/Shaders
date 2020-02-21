// Based on google sheets flower tutorial by Inigo Quilez
// https://www.youtube.com/watch?time_continue=341&v=JnCkF62gkOY&feature=emb_logo
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define TWO_PI 6.28319
#define RADIUS .2

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;

vec3 petals(vec2 anchor, vec2 uv) {
  // 0..1
  float atanNorm=fract(atan(anchor.y-uv.y, anchor.x-uv.x)/TWO_PI);
  // 0..67
  float sinNorm=cos(10.*PI*atanNorm+cos(u_time))/1.;

  return vec3(step(RADIUS, 1.-distance(anchor, uv)+sinNorm));
}

vec3 centerCutout(vec2 anchor, vec2 uv) {
  return vec3(smoothstep(RADIUS, RADIUS+.05, distance(anchor, uv)));
}

vec3 center(vec2 anchor, vec2 uv) {
  return (1.-centerCutout(anchor, uv))*vec3(.9,.9,.3);
}

vec3 flower(vec2 anchor, vec2 uv) {
  vec3 col = vec3(0.);
  col+=petals(anchor, uv);
  col*=centerCutout(anchor, uv);
  col+=center(anchor, uv);

  return col;
}

void main(){
  // uv centered and normalized from -.5 to .5
  vec2 uv = (gl_FragCoord.xy-.5*u_resolution.xy) / u_resolution.y;

  // zoom
  uv*=20.;
  // uv.y+=u_time/2.;

  vec3 col = vec3(0.);
  for(float i = 0.; i < 20.; i++) {
    col += flower(vec2(-3.+mod(i,5.)+5.*sin(i*123.), 11.+i-2.*mod(u_time,30.)), uv);
    col += flower(vec2(-3.+mod(i,5.)+5.*sin(i), 11.+i-2.*mod(u_time+10.,30.)), uv);
    col += flower(vec2(-3.+mod(i,5.)+5.*sin(i), 11.+i-2.*mod(u_time+20.,30.)), uv);
  }

  // debug
  // if(uv.y < 0. && uv.x < 0.) {
  //   col = vec3(0.);
  // }

  // debug bounding box - adjust zoom to see
  // if(abs(length(uv.x) - 10.) < 0.01 ||
  //    abs(length(uv.y) - 10.) < 0.01) {
  //   gl_FragColor=vec4(vec3(0., 0., 1.), 1);
  //   return;
  // }

  gl_FragColor=vec4(col, 1);
}