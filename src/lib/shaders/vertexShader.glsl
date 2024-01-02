precision mediump float;

uniform float shellCount;
uniform float shellIndex;
uniform float shellLength;

varying vec2 texCoords;

void main(){
  texCoords=uv;
  
  float shellHeight=shellIndex/shellCount;
  float extrusionScalar=shellHeight*shellLength;
  vec3 extrudedPosition=position+normal*extrusionScalar;
  
  vec4 modelViewPosition=modelViewMatrix*vec4(extrudedPosition,1.);// Transform extruded position to view space
  gl_Position=projectionMatrix*modelViewPosition;// Then transform to clip space
  
}