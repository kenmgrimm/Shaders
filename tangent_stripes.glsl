#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159

uniform vec2 u_resolution;
uniform float u_time;

void main(){
  vec2 st=(gl_FragCoord.xy/u_resolution) * 2. - 1.;

  vec3 color=vec3(0.);

  color += step(1., mod((atan(st.y, st.x) + PI) / 2.*PI*3., 2.));

  gl_FragColor=vec4(color, 1);
}