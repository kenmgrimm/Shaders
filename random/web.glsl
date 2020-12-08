#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define TWO_PI 6.28319
#define SPIRAL_LEN 500.

uniform vec2 u_resolution;
uniform float u_time;

// Returns atan normalized to range 0..1
float atan_norm(float y, float x) {
  return (atan(y,x)+PI)/TWO_PI;
}

vec2 point(float dist, float angle) {
  return dist * vec2(cos(angle), sin(angle));
}

vec3 web(vec2 anchor, vec2 uv, float radius) {
  vec2 offset = anchor-uv;
  float atn = atan_norm(offset.y, offset.x);
  float segment = floor(atn*10.)/10.;

  float dist = distance(uv, anchor);
  // length to starting point of dist segment this point falls within
  float distSegmentMin = floor(dist*10.)/10.;
  float distSegmentMax = ceil(dist*10.)/10.;

  float segmentLen = sqrt(2.*pow(distSegmentMax, 2.));

  if(dist>radius) {
    discard;
  }

  if(mod(atn, .1) < .004) {
    if(abs(dist- distSegmentMin) < 0.01) {
      return vec3(1.,1.,.1);
    }
  }
  if(mod(atn, .1) < .002) {
    return vec3(1.,.3,.3);
  }

  // cosine rule:
  // c2=a2+b2-2abCos C
  float localAngle = fract(atn *10.);
  float c = sqrt(pow(dist, 2.) + pow(distSegmentMax, 2.) - 2.*dist*distSegmentMax*cos(localAngle));
  // if(c/dist < .2) {
  //   return vec3(.3,.3,1.);
  // }

  float distToLeftVertex =distance(uv,point(distSegmentMax,segment*TWO_PI));
  float distToRightVertex =distance(uv,point(distSegmentMax,(segment+.1)*TWO_PI));
  // Looking for distance from uv to line segment of the web segment
  // If close to 0 then color it
  // Start out finding distance to vertices
  // if(segmentLen - 2.*c < .6) {
  //   return vec3(.9, .3, .9);
  // }
  if(distance(distToLeftVertex, distToRightVertex) < .01) {
    return vec3(.9, .1, .9);
  }
  // if(distance(.2*segmentLen, distToLeftVertex + distToRightVertex) < .2) {
  //   return vec3(.1, .9, .1);
  // }
  if(distToLeftVertex < .05 || distToRightVertex < .05) {
    return vec3(.1, .8, .1);
  }

  // if(distToLeftVertex + distToRightVertex - segmentLen < 1.) {
    // return vec3(1., .84, 0.);
  // }

  // // sine rule:
  // // c / sin C == a / sin A
  // float sinRule = c/sin(1.-localAngle);
  // // sinRule == distSegmentMax/sin(segmentAngle)
  // // sinRule*sin(segmentAngle) == distSegmentMax
  // // sin(segmentAngle) = distSegmentMax / sinRule
  // float segmentAngle = distSegmentMax / sinRule;
  // if(9. - segmentAngle < .0) {
  //   return vec3(.8, .5, .5);
  // }

  // pin-wheel
  // float localAngle = fract(atn *10.);
  // if(dist + distSegmentMax + localAngle > 1.6) {
  //   return vec3(.3,.3,1.);
  // }

  // mint circles
  if(dist-distSegmentMin < .005) {
    return vec3(.7,1.,.7);
  }
  if(distSegmentMax-dist < .005) {
    return vec3(.7,.7,1.);
  }

  return vec3(fract(segment+distSegmentMin));
}

void main(){
  // uv centered and normalized from -.5 to .5
  vec2 uv=(gl_FragCoord.xy-.5*u_resolution.xy)/u_resolution.y;

  // scale
  uv*=2.;

  vec3 col = vec3(0.);
  col += web(vec2(.0, .0), uv, .9);

  gl_FragColor=vec4(col, 1.);
}