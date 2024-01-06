#define PI 3.1415926535897932384626433832795

precision mediump float;

uniform vec3 color;
uniform float density;

uniform float shellCount;
uniform float shellIndex;
uniform float shellThickness;

uniform float noiseMin;
uniform float noiseMax;

uniform vec3 lightDirection;

varying vec2 textureCoordinates;
varying vec3 normals;

// https://www.shadertoy.com/view/flX3R2
float hash(uint seed){
  seed=(seed<<13)^seed;
  float t=float((seed*(seed*seed*15731u+789221u)+1376312589u)&0x7fffffffu);
  return 1.-(t/1073741824.);
}

float dotClamped(vec3 a,vec3 b,float min,float max){
  float dotProduct=dot(a,b);
  return clamp(dotProduct,min,max);
}

float valveHalfLambert(vec3 normals,vec3 light){
  float normalsDotLight=dotClamped(normals,light,0.,1.)*.5+.5;
  return normalsDotLight*normalsDotLight;
}

vec4 planeConfig(){
  vec2 newUV=textureCoordinates*density;
  vec2 localUV=fract(newUV)*2.-1.;
  float localDistanceFromCenter=length(localUV);
  
  uint seed=uint(newUV.x)*uint(newUV.y);
  float rand=mix(noiseMin,noiseMax,hash(seed));
  
  float height=shellIndex/shellCount;
  bool outsideThickness=(localDistanceFromCenter)>(shellThickness*(rand-height));
  
  if(outsideThickness&&(shellIndex>1.))discard;
  
  float halfLambert=valveHalfLambert(normals,lightDirection);
  
  vec4 finalColor=vec4(color*height*halfLambert,1.);
  
  return finalColor;
}

float sphericalHash(vec3 coords){
  // Adjust the hash function for spherical coordinates
  uint seed=uint(coords.x*43758.5453+coords.y*19395.437+coords.z*8347.235);
  seed=(seed<<13)^seed;
  return float((seed*(seed*seed*15731u+789221u)+1376312589u)&0x7fffffffu)/1073741824.;
}

vec4 sphereConfig(){
  float latitude=acos(normals.y)/PI;
  float longitude=(atan(normals.x,normals.z)+PI)/(2.*PI);
  
  float adjustedShellThickness=shellThickness*(1.-sin(latitude));
  float adjustedDensity=density*(1.+sin(latitude));
  
  vec3 localSphericalCoordinates=vec3(longitude,latitude,length(normals));
  
  vec2 newUV=textureCoordinates*adjustedDensity;
  vec2 localUV=fract(newUV)*2.-1.;
  float localDistanceFromCenter=length(localUV);
  
  float noise=sphericalHash(localSphericalCoordinates);
  float rand=mix(noiseMin,noiseMax,noise);
  
  float height=shellIndex/shellCount;
  // bool outsideThickness=(localDistanceFromCenter)>(adjustedShellThickness*(rand-height));
  
  // if(outsideThickness&&(shellIndex>1.))discard;
  if(height<rand)discard;
  
  float halfLambert=valveHalfLambert(normals,lightDirection);
  
  vec4 finalColor=vec4(color*height*halfLambert,1.);
  
  return finalColor;
}

void main(){
  
  vec4 finalColor=sphereConfig();
  
  gl_FragColor=finalColor;
  
}