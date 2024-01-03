precision mediump float;

uniform vec3 color;
uniform float density;

uniform float shellCount;
uniform float shellIndex;
uniform float shellThickness;

uniform float noiseMin;
uniform float noiseMax;

varying vec2 texCoords;

// https://www.shadertoy.com/view/flX3R2
float hash(uint seed){
  seed=(seed<<13)^seed;
  float t=float((seed*(seed*seed*15731u+789221u)+1376312589u)&0x7fffffffu);
  return 1.-(t/1073741824.);
}

void main(){
  vec2 newUV=texCoords*density;
  vec2 localUV=fract(newUV)*2.-1.;
  float localDistanceFromCenter=length(localUV);
  
  uint seed=uint(newUV.x)*uint(newUV.y);
  float rand=mix(noiseMin,noiseMax,hash(seed));
  
  float height=shellIndex/shellCount;
  bool outsideThickness=(localDistanceFromCenter)>(shellThickness*(rand-height));
  
  if(outsideThickness&&(shellIndex>1.))discard;
  
  gl_FragColor=vec4(color,1.)*height;
  
}