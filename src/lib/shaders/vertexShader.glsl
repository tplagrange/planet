varying vec2 texCoords;

// applied to every vertex - good for updating shape of mesh

// no-op
void main(){
  texCoords=uv;
  
  vec4 modelViewPosition=modelViewMatrix*vec4(position,1.);
  gl_Position=projectionMatrix*modelViewPosition;
}