precision mediump float;

uniform vec3 color;
uniform float density;

uniform float shellCount;
uniform float shellIndex;

// from vertex shader
varying vec2 texCoords;

// https://www.shadertoy.com/view/flX3R2
float hash(uint seed){
  seed=(seed<<13)^seed;
  float t=float((seed*(seed*seed*15731u+789221u)+1376312589u)&0x7fffffffu);
  return 1.-(t/1073741824.);
}

void main(){
  float noiseMin=0.;
  float noiseMax=1.;
  float thickness=3.53;
  
  vec2 newUV=texCoords*density;
  
  uint seed=uint(newUV.x)*uint(newUV.y);
  float rand=mix(noiseMin,noiseMax,hash(seed));
  
  float height=shellIndex/shellCount;
  bool shouldDiscard=rand<height;
  
  if(shouldDiscard)discard;
  
  gl_FragColor=vec4(color,1.)*height;
  
}