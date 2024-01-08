precision mediump float;

uniform float shellCount;
uniform float shellIndex;
uniform float shellLength;

uniform float time;

varying vec2 textureCoordinates;
varying vec3 normals;

vec3 wind(float shellHeight){
  float _Curvature=1.;
  float k=pow(shellHeight,_Curvature);
  
  vec3 _ShellDirection=vec3(0.,sin(time),0.);
  float _DisplacementStrength=.05;
  vec3 windDisplacement=_ShellDirection*k*_DisplacementStrength;
  
  return windDisplacement;
}

void main(){
  textureCoordinates=uv;
  normals=normal;
  
  float shellHeight=shellIndex/shellCount;
  float extrusionScalar=shellHeight*shellLength;
  vec3 extrudedPosition=position+normal*extrusionScalar;
  
  vec3 windDisplacedPosition=extrudedPosition+wind(shellHeight);
  
  vec4 modelViewPosition=modelViewMatrix*vec4(windDisplacedPosition,1.);// Transform extruded position to view space
  gl_Position=projectionMatrix*modelViewPosition;// Then transform to clip space
}