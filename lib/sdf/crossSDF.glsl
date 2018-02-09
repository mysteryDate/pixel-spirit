#pragma glslify: rectangleSDF = require('./rectangleSDF')

float crossSDF(vec2 st, float s) {
  vec2 size = vec2(0.25, s);
  return min(rectangleSDF(st, size.xy), rectangleSDF(st, size.yx));
}

#pragma glslify: export(crossSDF)
