#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

float circle(vec2 anchor, vec2 uv, float radius) {
  float color = 0.;
  color+=step(-radius,-abs(distance(anchor,uv)));
  color-=step(-(radius-.01),-abs(distance(anchor, uv)));

  return color;
}

// Draws circle in various coord systems:
// - uv centered, resized to y, -.5...5
// - uv centered, resized to x, -.5...5
// - uv centered, resized to minRes, -.5...5
// - uv un-centered, resized to minRes, 0..1
void main(){
  vec2 anchor = vec2(0.);
  vec3 color=vec3(0.);

  // uv centered and resized to y resolution 
  // y resizes to -.5...5, x is fixed. When x res < y res, x will be chopped
  // normalized from -.5 to .5
  // vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;
  // color += circle(anchor, uv, .4);

  // uv centered and resized to x resolution 
  // x resizes to -.5...5, y is fixed. When y res < x res, y will be chopped
  // normalized from -.5 to .5
  // vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.x;
  // color += circle(anchor, uv, .4);

  // uv centered and resized to min resolution 
  // min res resizes to -.5...5, no chopping
  // max res will be >.5 
  float minRes=min(u_resolution.x,u_resolution.y);
  vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/minRes;
  color += circle(anchor, uv, .4);

  // uv un-centered, 0..1
  // resizes to smallest res, no chopping
  // anchor = vec2(.5);
  // float minRes=min(u_resolution.x,u_resolution.y);
  // vec2 uv=gl_FragCoord.xy/minRes;
  // color += circle(anchor, uv, .4);
  
  gl_FragColor=vec4(color,1.);
}
