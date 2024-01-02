precision mediump float;

uniform vec3 color;
uniform float density;
uniform float shellIndex;

// from vertex shader
varying vec2 texCoords;

float rand(vec2 co){
  return fract(sin(dot(co,vec2(12.9898,78.233)))*43758.5453);
}

void main(){
  float threshHold=.06;
  
  uint flooredX=uint(texCoords.x*density);
  uint flooredY=uint(texCoords.y*density);
  
  float r=rand(vec2(flooredX,flooredY));
  float height=shellIndex*threshHold;
  if(r>height){
    gl_FragColor=vec4(color,1.)*height;
  }else{
    discard;
  }
}