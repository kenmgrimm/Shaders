// From https://www.iquilezles.org/www/articles/functions/functions.htm

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265

uniform vec2 u_mouse;
uniform vec2 u_resolution;

// Almost Identity
/* Imagine you don't want to change a value unless it's zero or very close to it,in which case you want to replace the value with a small constant.Then,rather than doing a conditional branch which introduces a discontinuity,you can smoothly blend your value with your threshold.Let m be the threshold(anything above m stays unchanged),and n the value things will take when your input is zero.Then,the following function does the soft clipping(in a cubic fashion):
*/
float almostIdentity(float x,float threshold,float valAtZero){
  if(x>threshold)return x;
  
  float a=2.*valAtZero-threshold;
  float b=2.*threshold-3.*valAtZero;
  float t=x/threshold;
  return(a*t+b)*t*t+valAtZero;
}

/*
Almost Identity(II)
A different way to achieve a near identity that can also be used as smooth-abs()is through the square root of a biased square,instead of a cubic polynomail.I saw this technique first in a shader by user"omeometo"in Shadertoy.This approach can be a bit slower than the cubic above,depending on the hardware.And while it has zero derivative,it has a non-zero second derivative,which could cause problems in some situations:
*/
float almostIdentity2(float x,float n) {
  return sqrt(x*x+n);
}

/*
Exponential Impulse
Great for triggering behaviours or making envelopes for music or animation,and for anything that grows fast and then slowly decays.Use k to control the stretching of the function.Btw,its maximum,which is 1,happens at exactly x=1/k.
*/
float expImpulse(float x,float k) {
  float h=k*x;
  return h*exp(1.-h);
}

/*
* Polynomial Impulse
Another impulse function that doesn't use exponentials can be designed by using polynomicals.Use k to control falloff of the function.For example,a quadratic can be used,which peaks at x=sqrt(1/k).
*/
float quaImpulse(float k,float x) {
  return 2.*sqrt(k)*x/(1.+k*x*x);
}

/*
Power curve
This is a generalziation of the Parabola()above.It also maps the 0..1 interval into 0..1 by keeping the corners mapped to 0.But in this generalziation you can control the shape one either side of the curve,which comes handy when creating leaves,eyes,and many other interesting shapes.
*/

float pcurve(float x,float a,float b) {
  float k=pow(a+b,a+b)/(pow(a,a)*pow(b,b));
  return k*pow(x,a)*pow(1.-x,b);
}

/*
Sinc curve
A phase shifted sinc curve can be useful if it starts at zero and ends at zero,for some bouncing behaviors(suggested by Hubert-Jan).Give k different integer values to tweak the amount of bounces.It peaks at 1.,but that take negative values,which can make it unusable in some applications.
*/

float sinc(float x,float k) {
  float a=PI*(k*x-1.);
  return sin(a)/a;
}

void main() {
  vec2 anchor=vec2(0.);
  vec3 color=vec3(1.);

  vec2 res = u_resolution;

  // uv centered and resized to min resolution
  // min res resizes to -.5...5, no chopping
  // max res will be >.5
  float minRes=min(res.x,res.y);
  vec2 uv=(gl_FragCoord.xy-.5*res.xy)/minRes;
  
  uv*=5.;
  uv *= .5;

  // almostIdentity
  float almostId = almostIdentity2(uv.x,.001);
  color -= 1.-step(.008, distance(uv, vec2(uv.x, almostId)));
  
  // exponential impulse
  float impulse = expImpulse(uv.x,2.);
  color -= 1.-step(.008, distance(uv, vec2(uv.x, impulse)));
  
  // polynomial
  float poly = quaImpulse(uv.x,.3);
  color -= 1.-step(.003, distance(uv, vec2(uv.x, poly)));

  // power curve
  float power = pcurve(uv.x, 1., 6.);
  color -= 1.-step(.005, distance(uv, vec2(uv.x, power)));
  
  // sinc
  float si = sinc(uv.x, 6.);
  color -= 1.-step(.005, distance(uv, vec2(uv.x, si)));

  // gridlines
  color-=step(.998,1.-abs(uv.x));
  color-=step(.998,1.-abs(uv.y));
  
  // debug
  // color = vec3(0.);
  // color += vec3(vec2(almostIdentity(uv.x, .2, .1)), 0.);
  
  gl_FragColor=vec4(color,1.);
}
