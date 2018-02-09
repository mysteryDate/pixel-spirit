#pragma glslify: rectangle = require('./rectangle')

float cross(vec2 st, float s) {
  vec2 size = vec2(0.25, s);
  return min(rectangle(st, size.xy), rectangle(st, size.yx));
}

#pragma glslify: export(cross)
