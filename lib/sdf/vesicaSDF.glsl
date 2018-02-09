#pragma glslify: circleSDF = require('./circleSDF')

float vesicaSDF(vec2 st, float w) {
  vec2 offset = vec2(w * 0.5, 0.0);
  return max(circleSDF(st - offset),
             circleSDF(st + offset));
}

#pragma glslify: export(vesicaSDF)
