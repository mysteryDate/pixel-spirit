vec2 rotate(vec2 st, float theta) {
  mat2 rotationMatrix = mat2(cos(theta), sin(theta), -sin(theta), cos(theta));
  return rotationMatrix * st;
}

#pragma glslify: export(rotate)
