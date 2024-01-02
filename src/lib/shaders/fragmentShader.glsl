precision mediump float;

uniform vec3 colorA;
uniform vec3 colorB;
uniform float density;
uniform float shellIndex;

// from vertex shader
varying vec2 texCoords;

float rand(vec2 co){
  return fract(sin(dot(co,vec2(12.9898,78.233)))*43758.5453);
}

void main(){
  float threshHold=.06;
  
  // given uv
  // clamp it to a value between [0, 1]
  uint flooredX=uint(texCoords.x*density);// [0, D]
  uint flooredY=uint(texCoords.y*density);// [0, D]
  
  float r=rand(vec2(flooredX,flooredY));// [0, 1]
  float height=shellIndex*threshHold;
  if(r>height){
    gl_FragColor=vec4(colorA,1.);
  }else{
    gl_FragColor=vec4(colorB,1.);
  }
}